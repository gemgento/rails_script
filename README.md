# Rails Script

Rails Script is a Rails-centric, object oriented, featherweight framework for writting CoffeeScript.  It is optomized for the [Rails Asset Pipeline](http://guides.rubyonrails.org/asset_pipeline.html) and is compatible with [TurboLinks](https://github.com/rails/turbolinks).  Using Rails controller names and actions to call JavaScript, it has never been easier to write clean, concise, and maintanable page specific JavaScript.

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


### Generating New Controllers

When a new controller is generated, the JavaScript asset file will be generated with Rails Script.  However, if you need to manually generate a Rails Script controller you can use:

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


## Contributing

1. Fork it ( https://github.com/[my-github-username]/rails_script/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
