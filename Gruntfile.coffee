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
        tasks: ['coffee']
      sass:
        files: 'src/stylesheets/**/*.sass'
        tasks: ['sass']
      haml:
        files: 'src/**/*.haml'
        tasks: ['haml']

    coffee:
      glob_to_multiple:
        expand: true
        cwd: 'src/coffeescript'
        src: ['**/*.coffee']
        dest: 'build/javascript'
        ext: '.js'

    sass:
      dist:
        files:
          'build/stylesheets/main.css' : 'src/stylesheets/main.sass'
    haml:
      dist:
        files: 'build/index.html' : 'src/index.haml'

  grunt.registerTask 'default', ['build', 'connect', 'regarde']
  grunt.registerTask 'build', ['coffee', 'sass', 'haml']

  # load NPM modules
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-haml'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-regarde'
  grunt.loadNpmTasks 'grunt-contrib-connect'