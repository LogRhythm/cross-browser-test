(function() {
  angular.module('LogRhythm').directive('log', function() {
    return {
      restrict: 'E',
      templateUrl: '/log.html',
      replace: true,
      link: function(scope, elem, attrs) {
        var SPEED, element, getIndex, height, isTesting, left, stage, x, y;
        x = attrs.x, y = attrs.y, isTesting = attrs.isTesting;
        element = _.first(elem);
        y = parseInt(y);
        x = parseInt(x);
        height = (y + 1) * 150;
        left = x * 87;
        stage = document.getElementById('stage');
        elem.css({
          height: height,
          left: left
        });
        SPEED = isTesting ? 0.016 : 3;
        getIndex = function() {
          return scope.logs.indexOf(scope.log);
        };
        return new TweenLite.fromTo(element, SPEED, {
          y: height * -1
        }, {
          y: stage.offsetHeight,
          onComplete: function() {
            scope.logs.splice(getIndex(), 1);
            scope.$emit('logEnd', scope.log.isBuzzed);
            return scope.$digest();
          },
          onUpdate: function() {
            var CONTAINER_HEIGHT, bottom, transformY;
            if (scope.gameOver) {
              this.kill();
            }
            CONTAINER_HEIGHT = stage.offsetHeight;
            transformY = this.target._gsTransform.y;
            bottom = CONTAINER_HEIGHT - height;
            if (transformY >= bottom) {
              scope.log.isPassing = true;
              return scope.$emit('logPass', this.target);
            }
          }
        });
      }
    };
  });

}).call(this);
