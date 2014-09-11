window.App ||= {}
class App.Base

  constructor: ->
    return this


  create: ->
    if typeof $this.new == 'function'
      return $this.new()


  update: ->
    if typeof $this.edit == 'function'
      return $this.edit()