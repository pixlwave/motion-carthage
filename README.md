# motion-carthage

[Carthage](https://github.com/Carthage/Carthage) support for RubyMotion

Primarily this implements `carthage copy-frameworks` properly for iOS device builds, however it will also embed the fat binaries for simulator builds as well as OS X projects.

## Installation

Install Carthage using Homebrew:

    brew install carthage

Add this line to your application's Gemfile:

    gem 'motion-carthage', github: 'digitalfx/motion-carthage'

And then execute:

    $ bundle

## Usage

Create a Cartfile at the root of your project containing your project dependencies:

    github "User/Framework"

Fetch and install with the carthage command:

    carthage update

The frameworks will get built into `Carthage/Build/Platform/Framework.framework`. To embed them in your RubyMotion project, add the following line to your RakeFile:

    app.carts = ['Framework']

Run `rake` and let motion-carthage take care of everything else for you. Check out this [demo project](https://github.com/digitalfx/CartTest) for a working example.

## Contributing

This project is very much in it's early stages, so feel free to submit pull requests if you encounter any issues
