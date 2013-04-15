# some libraries need to be shimmed
shim = require 'browserify-shim'

module.exports = (grunt) ->

  grunt.initConfig
    connect:
      server:
        options:
          port: 8000
          base: 'build'

    regarde:
      coffee:
        files: 'src/coffeescript/**/*.coffee'
        tasks: ['buildJS']
      sass:
        files: 'src/stylesheets/**/*.sass'
        tasks: ['sass']
      haml:
        files: 'src/**/*.haml'
        tasks: ['haml']

    coffee:
      options:
        bare: true

      glob_to_multiple:
        expand: true
        cwd: 'src/coffeescript'
        src: ['**/*.coffee']
        dest: 'tmp/javascript'
        ext: '.js'

    browserify2:
      build:
        entry:    './tmp/javascript/main.js'
        compile:  'build/javascript/main.js'
        beforeHook: (bundle) ->
          shim(bundle, {jQuery: path: './components/jquery/jquery.js', exports: 'jQuery'});

    sass:
      dist:
        files:
          'build/stylesheets/main.css' : 'src/stylesheets/main.sass'
    haml:
      dist:
        files: 'build/index.html' : 'src/index.haml'

  grunt.registerTask 'default', ['build', 'connect', 'regarde']
  grunt.registerTask 'buildJS', ['coffee', 'browserify2']
  grunt.registerTask 'build',   ['buildJS', 'sass', 'haml']

  # load NPM modules
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-haml'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-regarde'
  grunt.loadNpmTasks 'grunt-browserify2'
  grunt.loadNpmTasks 'grunt-contrib-connect'