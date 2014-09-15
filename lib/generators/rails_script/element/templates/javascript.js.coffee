window.App ||= {}
window.App.Element ||= {}
class App.Element.<%= element_name.gsub('::', '') %> <%= "extends App.Utility.#{utility.gsub('::', '')}" unless utility.blank?  %>

  constructor: ->
    super
    return this