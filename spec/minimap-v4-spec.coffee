{TextEditor} = require 'atom'
Minimap = require '../lib/minimap'

describe 'Minimap package v4', ->
  [workspaceElement, minimapPackage] = []

  beforeEach ->
    atom.config.set 'minimap.v4Preview', true

    waitsFor -> atom.packages.activatePackage('minimap')

    runs ->
      minimapPackage = atom.packages.getLoadedPackage('minimap').mainModule

  afterEach ->
    minimapPackage.deactivate()

  it 'returns a custom version instead of the one in package.json', ->
    expect(minimapPackage.version).toEqual('4.0.0-preview')

  it 'match semver expression in 4.x', ->
    expect(minimapPackage.versionMatch('4.x')).toBeTruthy()

  it 'registers the minimap views provider', ->
    textEditor = new TextEditor({})
    minimap = new Minimap({textEditor})
    minimapElement = atom.views.getView(minimap)

    expect(minimapElement).toExist()

  describe 'when an editor is opened', ->
    [editor, minimap, editorElement, minimapElement] = []

    beforeEach ->
      waitsFor ->
        atom.workspace.open('sample.coffee')

      runs ->
        workspaceElement = atom.views.getView(atom.workspace)
        jasmine.attachToDOM(workspaceElement)

      waitsFor -> atom.workspace.getActiveTextEditor()

      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)

    it 'creates a minimap model for the editor', ->
      expect(minimapPackage.minimapForEditor(editor)).toBeDefined()

    it 'attaches a minimap element to the editor view', ->
      expect(editorElement.shadowRoot.querySelector('atom-text-editor-minimap')).toExist()
