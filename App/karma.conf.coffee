module.exports = (config) ->
  aj  = 'assets/js'
  pv = 'public/vendor'
  config.set
    frameworks : ['mocha']
    browsers   : ['PhantomJS']
    reporters  : ['progress']
    autoWatch  : true
    logLevel   : config.LOG_ERROR
    plugins    : [
      'karma-mocha'
      'karma-chrome-launcher'
      'karma-phantomjs-launcher'
      'karma-coffee-preprocessor'
    ]
    preprocessors :
      'assets/**/*.coffee' : 'coffee'
      'test/**/*.coffee'   : 'coffee'
    files : [
      "#{pv}/lodash/dist/lodash.js"
      '../node_modules/chai/chai.js'
      "#{pv}/jquery/dist/jquery.js"
      "#{pv}/angular/angular.js"
      "#{pv}/angular-mocks/angular-mocks.js"
      "#{pv}/lodash/dist/lodash.js"
      "#{pv}/KeyboardJS/keyboard.js"
      "#{pv}/greensock/src/minified/TweenLite.min.js"
      "#{pv}/greensock/src/minified/plugins/CSSPlugin.min.js"
      'http://fresheyeball.github.io/Clog/javascripts/Clog.js'
      "#{aj}/module.coffee"
      "#{aj}/directives/*.coffee"
      "#{aj}/controllers/*.coffee"
      "#{aj}/services/*.coffee"
      'test/**/*.coffee'
    ]
