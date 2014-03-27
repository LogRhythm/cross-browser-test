# // steps to run the app
# npm install
# bower install
# sudo grunt start
# grunt build // if you are a developer

module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-karma'

  ASSETS = 'App/assets'
  PUBLIC = 'App/public'

  grunt.registerTask 'build', ['clean','coffee','stylus','watch']

  grunt.registerTask 'start', 'start the app', ->
    {exec} = require 'child_process'
    callback = @async()
    exec 'node app.js', (err, stdout, stderr) ->
      return console.log err if err
      console.log stdout
      callback()

  grunt.initConfig

    watch  :
      coffee :
        files : [
          "#{ASSETS}/**/*.coffee"
          "#{ASSETS}/**/*.styl"
        ]
        tasks : ['coffee','stylus']

    clean : ["#{PUBLIC}/js", "#{PUBLIC}/css"]

    coffee :
      transpile :
        expand  : true
        cwd     : ASSETS
        src     : ['**/*.coffee']
        dest    : PUBLIC
        ext     : '.js'

    stylus :
      transpile :
        files     :
          'App/public/css/main.css' : ['App/assets/css/**/*.styl']

    karma :
      unit  :
        configFile : 'App/karma.conf.coffee'
