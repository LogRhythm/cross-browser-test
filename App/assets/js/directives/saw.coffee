angular.module('LogRhythm').constant 'keyHASH', "qwerty"

angular.module('LogRhythm').directive 'saw', (keyHASH) ->
  restrict : 'E'
  link     : (scope, elem, attrs) ->
    {x
    isTesting} = attrs
    x          = parseInt x
    key        = keyHASH[x]
    saw        = scope.saws[x]
    element    = _.first elem
    saw.isDown = false

    element.style.left = element.offsetWidth * x

    buzz =
      on : ->
        scope.$emit 'keydown', x
        saw.isDown = true
        element.classList.add 'buzz'
      off : ->
        scope.$emit 'keyup', x
        saw.isDown = false
        element.classList.remove 'buzz'

    KeyboardJS.on key, buzz.on, buzz.off

    if isTesting
      elem.bind 'testkeyup', (evt, testKey) ->
        buzz.off() if testKey is key
      elem.bind 'testkeydown', (evt, testKey) ->
        buzz.on() if testKey is key
      

