window.RailsScript ||= {}
window.App ||= {}
window.Element ||= {}
window.Utility ||= {}

# Initializer
$(document).on "ready.rails_script page:load.rails_script turbolinks:load.rails_script",  ->
  controller = $('#rails-script').data('controller')
  action = $('#rails-script').data('action')
  Utility.RailsVars = $('#rails-script').data('vars')

  window.$this = new (App[controller] || App.Base)()

  if typeof $this.beforeAction == 'function'
    $this.beforeAction action
  if typeof $this[action] == 'function'
    $this[action]()
  if typeof $this.afterAction == 'function'
    $this.afterAction action

# Clear event handlers on navigation
RailsScript.setClearEventHandlers = ->
  jQuery(document).on 'page:before-change turbolinks:before-visit', ->
    for element in [window, document]
      for event, handlers of (jQuery._data(element, 'events') || {})
        for handler in handlers
          if handler? && handler.namespace == ''
            jQuery(element).off event, handler.handler