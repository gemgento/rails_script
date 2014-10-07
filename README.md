# RailsScript

RailsScript is a Rails-centric, object oriented, featherweight framework for writing CoffeeScript.  It is optimized for the [Rails Asset Pipeline](http://guides.rubyonrails.org/asset_pipeline.html) and is compatible with [TurboLinks](https://github.com/rails/turbolinks).  Using Rails controller names and actions to call JavaScript, it has never been easier to write clean, concise, and maintainable page specific JavaScript.

## Installation

Add this line to your application's Gemfile:

    gem 'rails_script'

And then execute:

    $ bundle
    
After bundling you need to run the initial installation generator:

    $ rails g rails_script:install
    
After the generator finishes, you will be prompted to add helper call to your application layout.  The generated code is responsible for initializing and calling the action specific JavaScript.  This helper shouyld be called before the closing body tag.

```
<%= include_rails_script %>
```

## Usage

### Global Functions

Any functions that need to be accessible in the global scope should be defined in ```global.js.coffee``` using the ```App``` namespace.  Below is an example of one of our favorite functions that we use to submit a form using AJAX as a JSON request.

```
# app/assets/javascripts/global.js.coffee
window.App ||= {}

App.remoteSubmission = ($form, onCompleteCallBack) ->
  $.ajax
    url: $form.attr('action')
    type: $form.attr('method')
    data: $form.serialize()
    dataType: 'json'
    complete: (result) ->
      onCompleteCallBack(result)

  return
```

Now you can access this function from anywhere in the application by just calling ```App.remoteSubmission($('#myForm'), alert('Hello'))```


### Page Specific JavaScript

This is where things get even easier, your JavaScript class is named after your Controller and there is a method for each Controller action.  Whenever you generate a Controller, the CoffeeScript file that is generated will define the new JavaScript class and the basic REST actions.  This means on ```Users#show``` we can submit that 'follow' request in the background like so:

```
# app/assets/javascripts/users.js.coffee

window.App ||= {}
class App.Users extends App.Base

   show: ->
      App.remoteSubmission($('#follow-user-form'), alert('You are now following them!'))
```


### Controller Specific JavaScript

Executing some JavaScript to run on all controller actions is just a matter of adding it to the class contstructor.  In the below example we will change the background color of the page for all actions in ```UsersController```.

```
# app/assets/javascripts/users.js.coffee
window.App ||= {}
class App.Example extends App.Base

  constructor: ->
    super
    $('body').css('background-color', 'yellow')
    return this
```

Note the call to ```super``` and the ```return this```, it is very important to keep these.  If you wanted your Controller specific JavaScript to run before Application wide JavaScript, then you would call ```super``` just before ```return this```.  Returning ```this``` allows the Application layout JavaScript to call the action specific functions.


### Application Wide JavaScript

Running some JavaScript on every page of an Application is a common need.  For example, we may want to create a site credit rollover in the footer of every page.

```
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

In this example we extracted the rollover action into a new function.  Doing so will make the class cleaner and easier to maintain as the application grows.  Once again note the ```return this``` in the contructor.


### Utilities

A ```Utility``` is a class that will be used to create similar functionality in many areas of the application.  A good example of this is a Modal, which could appear multiple times on the same page.  So, let's encapsulate this functionality in a highly reusable class.

First, generate the ```Utility```

    $ rails g rails_script:utility Modal
    
This will create the following in ```/app/assets/javascripts/utilities/modal.js.coffee```:

```
# /app/assets/javascripts/utilities/modal.js.coffee
window.Utility ||= {}
class Utility.Modal
    
    constructor: ->
        return this
```

Let's add some basic functionality:

```
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
        if @isShowing then @close() else @open()
        
    
    open: =>
        @isShowing = true
        @element.show()
        
    
    close: =>
        @isShowing = false
        @element.fadeOut('fast')
```

Now, here's how we use the utility from ```users#show```

```
# app/assets/javascripts/users.js.coffee

window.App ||= {}
class App.Users extends App.Base

   show: ->
        @galleryModal = new Utility.Modal($('#user-gallery-modal-wrapper'), $('user-gallery-modal-toggle-button'))

```


### Elements

An ```Element``` is a class that describes the funcionality of a one off element in the applicattion.  A Main Menu is a good example of this since there is usually only a single Main Menu.

First generate the ```Element```

    $ rails g rails_script:element MainMenu
    
This will create the following in ```/app/assets/javascripts/elements/main_menu.js.coffee```

```
# /app/assets/javascripts/elements/main_menu.js.coffee```

window.Element ||= {}
class Element.MainMenu

    constructor: ->
        return this
```

We can now add all the logic for the main menu in a separate class and call it on every page like so:

```
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

````
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

```
# app/assets/javascripts/some/new_controller.js.coffee

window.App ||= {}
class App.SomeNewController extends App.Base

  constructor: ->
    super
    return this


  index: ->
    return


  show: ->
    return


  new: ->
    return


  edit: ->
    return
```

None of the pre-defined functions are necessary, you can remove the ones you don't want.


### Generic Classes

To generate a generic class that isn't a Utility, Element or Controller, just use the following:

    $ rails g rails_script:class My::ClassName
    
Which generates:

```
# /app/assets/javascripts/my/class_name.js.coffee

window.App ||= {}
class App.MyClassName
    
    constructor: ->
        return this

```


### Events

Since Turbolinks doesn't refresh the page and only replaces the body, event listeners defined on ```window``` and ```document``` carry between page loads.  To avoid these event listeners stacking, RailsScript will destroy all event listeners on ```window``` and ```document``` that have a blank namespace, i.e. ```$(window).on 'scroll', myHandler```.  If you need an event handler to persist between page changes, then define a namespace, i.e. ```$(window).on 'scroll.namespace', myHandler```.




## Contributing

1. Fork it ( https://github.com/[my-github-username]/rails_script/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
