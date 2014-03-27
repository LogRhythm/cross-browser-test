(function() {
  angular.module('LogRhythm').constant('keyHASH', "qwerty");

  angular.module('LogRhythm').directive('saw', function(keyHASH) {
    return {
      restrict: 'E',
      link: function(scope, elem, attrs) {
        var buzz, element, isTesting, key, saw, x;
        x = attrs.x, isTesting = attrs.isTesting;
        x = parseInt(x);
        key = keyHASH[x];
        saw = scope.saws[x];
        element = _.first(elem);
        saw.isDown = false;
        element.style.left = element.offsetWidth * x;
        buzz = {
          on: function() {
            scope.$emit('keydown', x);
            saw.isDown = true;
            return element.classList.add('buzz');
          },
          off: function() {
            scope.$emit('keyup', x);
            saw.isDown = false;
            return element.classList.remove('buzz');
          }
        };
        KeyboardJS.on(key, buzz.on, buzz.off);
        if (isTesting) {
          elem.bind('testkeyup', function(evt, testKey) {
            if (testKey === key) {
              return buzz.off();
            }
          });
          return elem.bind('testkeydown', function(evt, testKey) {
            if (testKey === key) {
              return buzz.on();
            }
          });
        }
      }
    };
  });

}).call(this);
