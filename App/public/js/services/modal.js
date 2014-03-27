(function() {
  angular.module('LogRhythm').service('modal', function($templateCache) {
    var Modal;
    Modal = (function() {
      function Modal() {}

      Modal.prototype.open = function(template, callback) {
        var mc;
        this.callback = callback || function() {};
        this.container = document.createElement('div');
        this.container.innerHTML = $templateCache.get('/modal.html');
        document.body.appendChild(this.container);
        if (template) {
          mc = document.getElementById('modalContent');
          mc.innerHTML = $templateCache.get(template);
        }
        return this.listen();
      };

      Modal.prototype.listen = function() {
        var closer, closers, _i, _len, _results;
        closers = document.querySelectorAll('#closeModal, #overlay, .closer');
        _results = [];
        for (_i = 0, _len = closers.length; _i < _len; _i++) {
          closer = closers[_i];
          _results.push(angular.element(closer).bind('click', function() {
            return this.close();
          }));
        }
        return _results;
      };

      Modal.prototype.close = function() {
        document.body.removeChild(this.container);
        return this.callback();
      };

      return Modal;

    })();
    return new Modal();
  });

}).call(this);
