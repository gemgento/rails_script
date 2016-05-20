window.RailsScript ||= {}
window.App ||= {}
window.Element ||= {}
window.Utility ||= {}

$(document).on "turbolinks:load.rails_script",  ->
  Utility.RailsVars = $('#rails-script').data('vars')
  window.$this = new (App["#{$('#rails-script').data('controller')}"] || App.Base)()

  action = $('#rails-script').data('action')

  if typeof $this.beforeAction == 'function'
    $this.beforeAction action
  if typeof $this[action] == 'function'
    $this[action]()
  if typeof $this.afterAction == 'function'
    $this.afterAction action

RailsScript.setClearEventHandlers = ->
  jQuery(document).on 'turbolinks:before-visit', ->
    for element in [window, document]
      for event, handlers of (jQuery._data(element, 'events') || {})
        for handler in handlers
          if handler? && handler.namespace == ''
            jQuery(element).off event, handler.handler