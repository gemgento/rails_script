window.Element ||= {}
class Element.<%= element_name.gsub('::', '') %> <%= "extends Utility.#{utility.gsub('::', '')}" unless utility.blank?  %>

  constructor: ->
    super
    return this