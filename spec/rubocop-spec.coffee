Rubocop = require '../lib/rubocop'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Rubocop", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('rubocop')

  describe "when the rubocop:toggle event is triggered", ->
    it "hides and shows the modal panel", ->
      # Before the activation event the view is not on the DOM, and no panel
      # has been created
      expect(workspaceElement.querySelector('.rubocop')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'rubocop:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(workspaceElement.querySelector('.rubocop')).toExist()

        rubocopElement = workspaceElement.querySelector('.rubocop')
        expect(rubocopElement).toExist()

        rubocopPanel = atom.workspace.panelForItem(rubocopElement)
        expect(rubocopPanel.isVisible()).toBe true
        atom.commands.dispatch workspaceElement, 'rubocop:toggle'
        expect(rubocopPanel.isVisible()).toBe false

    it "hides and shows the view", ->
      # This test shows you an integration test testing at the view level.

      # Attaching the workspaceElement to the DOM is required to allow the
      # `toBeVisible()` matchers to work. Anything testing visibility or focus
      # requires that the workspaceElement is on the DOM. Tests that attach the
      # workspaceElement to the DOM are generally slower than those off DOM.
      jasmine.attachToDOM(workspaceElement)

      expect(workspaceElement.querySelector('.rubocop')).not.toExist()

      # This is an activation event, triggering it causes the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'rubocop:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        # Now we can test for view visibility
        rubocopElement = workspaceElement.querySelector('.rubocop')
        expect(rubocopElement).toBeVisible()
        atom.commands.dispatch workspaceElement, 'rubocop:toggle'
        expect(rubocopElement).not.toBeVisible()
