angular.module('LogRhythm').directive 'log', ->
  restrict    : 'E'
  templateUrl : '/log.html'
  replace     : true
  link        : (scope, elem, attrs) ->
    {x
    y
    isTesting} = attrs
    element    = _.first elem

    y          = parseInt y
    x          = parseInt x

    height     = (y + 1) * 150
    left       = x * 87

    stage      = document.getElementById 'stage'

    elem.css
      height : height
      left   : left
    
    SPEED    = if isTesting then 0.016 else 3
    
    getIndex = -> scope.logs.indexOf scope.log

    new TweenLite.fromTo element, SPEED, {y : height * -1},
      y          : stage.offsetHeight
      onComplete : ->
        scope.logs.splice getIndex(), 1

        scope.$emit 'logEnd', scope.log.isBuzzed

        scope.$digest()

      onUpdate : ->
        this.kill() if scope.gameOver

        CONTAINER_HEIGHT = stage.offsetHeight
        transformY       = @target._gsTransform.y
        bottom           = CONTAINER_HEIGHT - height

        if transformY >= bottom
          scope.log.isPassing = true
          scope.$emit 'logPass', @target
