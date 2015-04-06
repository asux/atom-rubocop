{CompositeDisposable, BufferedProcess, File} = require 'atom'
path = require 'path'

module.exports = Rubocop =
  config:
    rubocopPath:
      title: 'Rubocop command'
      type: 'string'
      default: 'rubocop'

  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'rubocop:autocorrect-current-file': => @autocorrectCurrentFile()

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->

  isRubyFile: (filePath) ->
    path.extname(filePath) == '.rb'

  autocorrectCurrentFile: ->
    editor = atom.workspace.getActivePaneItem()
    filePath = editor.getPath()
    console.log "Rubocop: autocorrect current file: #{filePath}"
    unless @isRubyFile(filePath)
      return atom.notifications.addWarning "Rubocop: #{filePath} is not a Ruby file."
    if editor.isModified()
      return atom.notifications.addWarning 'Rubocop: current file is modified, please save it and try again.'
    try
      command = atom.config.get('rubocop.rubocopPath')
      args = ['-a', filePath]
      stdout = (output) -> console.log(output)
      stderr = (output) ->
        console.error(output)
        atom.notifications.addError "Rubocop: error on autocorrect: #{output}."
      exit = (code) ->
        console.log("Rubocop: #{command} exited with #{code}")
        if code < 2
          atom.notifications.addSuccess "Rubocop: #{filePath} autocorrected successfully."
      new BufferedProcess({command, args, stdout, exit})
    catch error
      atom.notifications.addError "Rubocop: error on autocorrect: #{error}."
