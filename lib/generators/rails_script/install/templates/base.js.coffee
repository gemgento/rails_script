window.App ||= {}
class App.Base

  constructor: ->
    if (window.jQuery) then @setClearEventHandlers() # clearing application event handlers only possible with jQuery
    return this


  ###
  Run the new action for the create action.  Generally the create action will 'render :new' if there was a problem.
  This prevents doubling the code for each action.
  ###
  create: ->
    if typeof $this.new == 'function'
      return $this.new()


  ###
  Run the edit action for the update action.  Generally the update action will 'render :edit' if there was a problem.
  This prevents doubling the code for each action.
  ###
  update: ->
    if typeof $this.edit == 'function'
      return $this.edit()


  ###
  Clear event handlers with a blank namespace.  This will prevent window and document event handlers from stacking
  when each new page is fetched.  Adding a namespace to your events will prevent them from being removed between page
  loads, i.e. "$(window).on 'scroll.app', myHandler"
  ###
  setClearEventHandlers: ->
    jQuery(document).on 'page:before-change', ->
      for element in [window, document]
        for event, handlers of (jQuery._data(element, 'events') || {})
          for handler in handlers
            if handler? && handler.namespace == ''
              jQuery(element).off event, handler.handler
