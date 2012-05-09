
Bacon\_Rack
================

A Ruby gem providing helper methods for your Bacon and rack/test 
specs.

Installation
------------

    gem install Bacon_Rack

Usage
------

    require 'Bacon'
    require 'rack/test'
    require "Bacon_Rack"
    

    ...
    
      it 'renders a message' do
        get "/missing-page"
        renders 404, "my message"
      end
    
      it 'redirects to other page' do
        get "/redirect-page"
        redirects_to "/page"
        redirects_to 304, "/page"
      end

      it 'renders js/css/gif/jpg assets' do
        get '/my-bueatiful page'

        renders_assets 
        # response of asset link must be within 200..310
        # response HTTP code.
      end

The source code is one page long if you have more questions:
[Source Code](https://github.com/da99/Bacon_Rack/master/lib/Bacon_Rack/module.rb).

Run Tests
---------

    git clone git@github.com:da99/Bacon_Rack.git
    cd Bacon_Rack
    bundle update
    bundle exec bacon spec/lib/main.rb

"I hate writing."
-----------------------------

If you know of existing software that makes the above redundant,
please tell me. The last thing I want to do is maintain code.

