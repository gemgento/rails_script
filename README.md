# Rails Script

Rails Script is a Rails-centric, object oriented, featherweight framework for writting CoffeeScript.  It is optomized for the Rails Asset Pipeline and is compatible with TurboLinks.  Using Rails controller names and actions to call JavaScript, it has never been easier to write clean, concise, and maintanable page specific JavaScript.

## Installation

Add this line to your application's Gemfile:

    gem 'rails_script'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_script

## Usage

### Setup

First you need to run the initial installation generator:

    $ rails g rails_script:install
    
After the generator finishes, you will be prompted to add some JavaScript to your application layout.  The code is responsible for initializing and call the action specific JavaScript.  This snippet should be added before the closing body tag.

For ERB:
```
jQuery(function() {
    window.$this = new (App.#{controller_path.split(/\/|_/).map(&:capitalize).join('')} || App.Base)();
    if (typeof $this.#{action_name} === 'function') {
      return $this.#{action_name}.call();
    }
});
```

For HAML:
```
HAML:
:javascript
  jQuery(function() {
    window.$this = new (App.\#{controller_path.split(/\/|_/).map(&:capitalize).join('')} || App.Base)();
    if (typeof $this.\#{action_name} === 'function') {
      return $this.\#{action_name}.call();
    }
  });
```

### Global Functions

Any functions that need to be accessible in the global scope should be defined in ```global.js.coffee``` using the ```App``` namespace.  Below is an example of one of our favorite functions that we use to submit a jorm using AJAX as a JSON request.

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

Now you can access this function from anywhere in the application by just calling ```App.remoteSubmission($('#myForm', alert('Hello'))```


### Page Specific JavaScript

This is where things get even easier, your JavaScript class is named after your Controller and there is a method for each Controller action.  Whenever you generate a Controller, the CoffeeScript file that is generated will define the new JavaScript class and the basic REST actions.  This means on ```Users#show``` we can submit that 'follow' request in the background like so:

```
# app/assets/javascripts/users.js.coffee

window.App ||= {}
class App.Users extends App.Base

   show: ->
      App.remoteSubmission($('#follow-user-form'), alert('You are now following them!'))
```


### Generating New Controllers

When a new controller is generated, the JavaScript asset file will be generated with Rails Script.  However, if you need to manually generate a Rails Script controller you can use:

    $ rails g rails_script:controller Some::NewController

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rails_script/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
