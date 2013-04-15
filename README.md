bci
===

Building a small game using WebRTC as a school assignment.

## Dependencies
To get this proejct running you'll need the following things:

* Chrome Canary (the one that supports WebRTC)
* Node.JS (with NPM)
* Git


## Getting started
To get started, run the following terminal commands:

* `git clone git@github.com:Tmw/bci.git`
* `cd bci`
* `npm install`
* `bower install`

When that finishes, start the project by running:

`grunt`

This command compiles all the Sass, Haml and CoffeeScript and runs the Browserify-command to package the JavaScript files into a single file. It also spins up a local development server on port 8000.

To see the project in action, visit the following URL:

`http://localhost:8000`