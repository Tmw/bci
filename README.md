bci
===

Building a small game using WebRTC as a school assignment.

## Dependencies
To get this project running you'll need the following things:

* Chrome Canary (the one that supports WebRTC)
* Node.JS (with NPM)
* Git


## Getting started
To get started, run the following terminal commands:

* `git clone git@github.com:Tmw/bci.git`
* `cd bci`
* `npm install`

Note: When `npm intall` finishes, it'll autostart the bower process to download and install any additional libraries such as jQuery. If that doesn't happen it means i've screwed up. You can fix my mistake by running `bower install` manually.


When this has finished you can start hacking away by running the `grunt` command. This watches and compiles all the Sass, Haml and CoffeeScript files for you and runs the Browserify-command to package the JavaScript files into a single file. 

To see the project in action, run:

`npm server`

This will run a local Node (Express.io) server which serves the assets and runs a Socket.IO server for signalling purposes.

`http://localhost:8000`

Happy Hacking!

##Copyright
Copyright (c) 2013 Tiemen Waterreus

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.