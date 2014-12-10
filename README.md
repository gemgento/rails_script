# RailsScript

RailsScript is a Rails-centric, object oriented, featherweight framework for writing CoffeeScript.  It is optimized for the [Rails Asset Pipeline](http://guides.rubyonrails.org/asset_pipeline.html) and is compatible with [TurboLinks](https://github.com/rails/turbolinks).  Using Rails controller names and actions to call JavaScript, it has never been easier to write clean, concise, and maintainable page specific JavaScript.

## Installation

Add this line to your application's Gemfile:

    gem 'rails_script', '~> 0.6.0'

And then execute:

    $ bundle
    
After bundling you need to run the initial installation generator:

    $ rails g rails_script:install
    
After the generator finishes, you will be prompted to add helper call to your application layout.  The generated code is responsible for initializing and calling the action specific JavaScript.  This helper should be called before the closing body tag.

```
<%= include_rails_script %>
```

## Usage

### Page (Action) Specific JavaScript

Your JavaScript class is named after your Controller and there is a method for each Controller action.  Whenever you generate a Controller, the CoffeeScript file that is generated will define the new JavaScript class and the basic REST actions.  The example below would print 'users#show' in the console for the ```Users#show``` action.

```coffeescript
# app/assets/javascripts/users.js.coffee

window.App ||= {}
class App.Users extends App.Base

   show: =>
      console.log 'users#show'
```



### Controller Specific JavaScript

Executing some JavaScript to run on all controller actions is just a matter of adding it to the ```beforeAction``` or ```afterAction``` function.  ```beforeAction``` is run before all controller action functions and ```afterAction``` is run after all controller action functions.  The before and after action functions have an optional argument ```action``` which is a string containing the current action name. The example below would print 'before ACTION action' and 'after ACTION action' for each ```Users``` controller action.  

```coffeescript
# app/assets/javascripts/users.js.coffee
window.App ||= {}
class App.Users extends App.Base

  beforeAction: (action) =>
    console.log "before #{action} action"
    
  afterAction: (action) =>
    console.log "after #{action} action"
```


### Application Wide JavaScript

Running some JavaScript on every page of an Application is a common need.  For example, we may want to create a site credit rollover in the footer of every page.

```coffeescript
# app/assets/javascripts/base.js.coffee
window.App ||= {}
class App.Base

  constructor: ->
    @footerRollover()
    return this
    
  footerRollover: ->
    $(".site-credit a").hoverIntent(
      over: ->
        $(".site-credit a").html("<div class='maui-logo'></div>")
      out: ->
        $(".site-credit a").html("SITE CREDIT")
    )
```

In this example we extracted the rollover action into a new function.  Doing so will make the class cleaner and easier to maintain as the application grows.  Once again note the ```return this``` in the constructor.



### Global Functions

Any functions that need to be accessible in the global scope should be defined in ```global.js.coffee``` using the ```App``` namespace.  Below is an example of one of our favorite functions that we use to submit a form using AJAX as a JSON request.

```coffeescript
# app/assets/javascripts/global.js.coffee
window.App ||= {}

App.remoteSubmission = ($form) ->
  $.ajax
    url: $form.attr('action')
    type: $form.attr('method')
    data: $form.serialize()
    dataType: 'json'

  return
```

Now you can access this function from anywhere in the application by just calling ```App.remoteSubmission($('#myForm'))```



### Utilities

A ```Utility``` is a class that will be used to create similar functionality in many areas of the application.  A good example of this is a Modal, which could appear multiple times on the same page.  So, let's encapsulate this functionality in a highly reusable class.

First, generate the ```Utility```

    $ rails g rails_script:utility Modal
    
This will create the following in ```/app/assets/javascripts/utilities/modal.js.coffee```:

```coffeescript
# /app/assets/javascripts/utilities/modal.js.coffee
window.Utility ||= {}
class Utility.Modal
    
    constructor: ->
        return this
```

Let's add some basic functionality:

```coffeescript
# /app/assets/javascripts/utilities/modal.js.coffee
window.Utility ||= {}
class Utility.Modal
    isOpen: false
    
    constructor: ($element, $trigger) ->
        @element = $element
        @trigger = $trigger
        @trigger.on 'click', @toggle
        return this
        
    
    toggle: (event) =>
        event.preventDefault()
        if @isOpen then @close() else @open()
        
    
    open: =>
        @isOpen = true
        @element.show()
        
    
    close: =>
        @isOpen = false
        @element.fadeOut('fast')
```

Now, here's how we use the utility from ```users#show```

```coffeescript
# app/assets/javascripts/users.js.coffee

window.App ||= {}
class App.Users extends App.Base

   show: ->
        @galleryModal = new Utility.Modal($('#user-gallery-modal-wrapper'), $('user-gallery-modal-toggle-button'))

```



### Elements

An ```Element``` is a class that describes the functionality of a one off element in the application.  A Main Menu is a good example of this since there is usually only a single Main Menu.

First generate the ```Element```

    $ rails g rails_script:element MainMenu
    
This will create the following in ```/app/assets/javascripts/elements/main_menu.js.coffee```

```coffeescript
# /app/assets/javascripts/elements/main_menu.js.coffee```

window.Element ||= {}
class Element.MainMenu

    constructor: ->
        return this
```

We can now add all the logic for the main menu in a separate class and call it on every page like so:

```coffeescript
# app/assets/javascripts/base.js.coffee

window.App ||= {}
class App.Base

  constructor: ->
    App.mainMenu = new Element.MainMenu()
    return this
```



#### Element Inheritance

Inheritance is another key tool for reusability.  Let's say our ```Element.MainMenu``` opens and closes in the same way as the ```Utility.Modal```.  Well then MainMenu should just extend Modal, this can be accomplished from the generator:

    $ rails g rails:script MainMenu Modal
    
Which generates:

````coffeescript
# /app/assets/javascripts/elements/main_menu.js.coffee

window.Element ||= {}
class Element.MainMenu extends Utility.Modal

    constructor: ->
        return this
````
    
Inheritance from the generator can only come from a Utility class.  Any class you wish to extend should be created as a Utility.  The installer adds the line ```//= require_tree ./utilities``` before loading tree to handle this.  If you have a utility that extends a utility, then make sure the extended utility is loaded first by explicitly requiring it before ```//= require_tree ./utilities```.



### Custom Controllers

When a new controller is generated, the JavaScript asset file will be generated with RailsScript.  However, if you need to manually generate a RailsScript controller you can use:

    $ rails g rails_script:controller Some::NewController
    
Since the above example includes a namespace, it would generate:

```coffeescript
# app/assets/javascripts/some/new_controller.js.coffee

window.App ||= {}
class App.SomeNewController extends App.Base

  beforeAction: (action) =>
    return
    
    
  afterAction: (action) =>
      return


  index: =>
    return


  show: =>
    return


  new: =>
    return


  edit: =>
    return
```

None of the pre-defined functions are necessary, you can remove the ones you don't need.



### Generic Classes

To generate a generic class that isn't a Utility, Element or Controller, just use the following:

    $ rails g rails_script:class My::ClassName
    
Which generates:

```coffeescript
# /app/assets/javascripts/my/class_name.js.coffee

window.App ||= {}
class App.MyClassName
    
    constructor: ->
        return this

```



### Passing Rails Variables

To pass data from Rails to JavaScript, just call ```to_javascript``` along with a hash of your data.  This is then converted to a JSON object with ```to_javascript.to_json``` and can be accessed with ```Utility.RailsVars```.  The ```to_javascript``` helper may be called from multiple points in the application, all data is merged together. 

Here's an example where ```to_javascript``` is used in a ```before_filter``` to pass the current user and their friends:
```ruby
# /app/controllers/application_controller.rb

class ApplicationController
    
    before_filter :set_javascript_vars
    
    private
    
    def set_javascript_vars
        to_javascript user: current_user, friends: current_user.friends
    end
    
end
```

And here's how we print that data to the console on the ```users#index``` action:

```coffeescript
# /app/assets/javascripts/users.js.coffee

window.App ||= {}
class App.Users extends App.Base

    index: =>
        console.log Utility.RailsVars.user
        console.log Utility.RailsVars.friends
```



### Events

Since Turbolinks doesn't refresh the page and only replaces the body, event listeners defined on ```window``` and ```document``` carry between page loads.  To avoid these event listeners stacking, RailsScript will destroy all event listeners on ```window``` and ```document``` that have a blank namespace, i.e. ```$(window).on 'scroll', myHandler```.  If you need an event handler to persist between page changes, then define a namespace, i.e. ```$(window).on 'scroll.namespace', myHandler```.



### Page Transitions

Full page transitions are super easy with RailsScript and Turbolinks.  Checkout the wiki for more information on how to add these to your RailsScript application, https://github.com/gemgento/rails_script/wiki/Turbolinks-Page-Transitions.



## Contributing

1. Fork it ( https://github.com/[my-github-username]/rails_script/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
