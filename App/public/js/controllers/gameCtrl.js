(function() {
  angular.module('LogRhythm').controller('gameCtrl', function($scope, $interval, modal, SETTINGS) {
    var COLS, MAX_HEIGHT, continueGame, gameOver, generateLog, i, lose, win;
    COLS = SETTINGS.COLS, MAX_HEIGHT = SETTINGS.MAX_HEIGHT;
    continueGame = null;
    $scope.logs = [];
    $scope.gameOver = false;
    $scope.player = {
      score: 0,
      lives: 10
    };
    generateLog = function() {
      var x, _i, _j, _ref, _ref1, _results, _results1;
      if ($scope.logs.length === COLS) {
        return;
      }
      if ($scope.logs.length) {
        x = _.sample(_.difference((function() {
          _results = [];
          for (var _i = 0, _ref = COLS - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; 0 <= _ref ? _i++ : _i--){ _results.push(_i); }
          return _results;
        }).apply(this), _.pluck($scope.logs, 'x')), 1);
      } else {
        x = _.sample((function() {
          _results1 = [];
          for (var _j = 0, _ref1 = COLS - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; 0 <= _ref1 ? _j++ : _j--){ _results1.push(_j); }
          return _results1;
        }).apply(this), 1);
      }
      return $scope.logs.push({
        x: _.first(x),
        y: _.random(0, MAX_HEIGHT)
      });
    };
    gameOver = function() {
      $interval.cancel(continueGame);
      return $scope.gameOver = true;
    };
    lose = function() {
      modal.open('/gameover.html', function() {
        return location.reload();
      });
      return gameOver();
    };
    win = function() {
      modal.open('/win.html', function() {
        return location.reload();
      });
      return gameOver();
    };
    modal.open('/instructions.html', function() {
      return continueGame = $interval(generateLog, 1500);
    });
    $scope.$watch('player.lives', function(value) {
      if (value === 0) {
        return lose();
      }
    });
    $scope.$watch('player.score', function(value) {
      if (value < -100) {
        lose();
      }
      if (value >= 1000) {
        return win();
      }
    });
    $scope.saws = (function() {
      var _i, _ref, _results;
      _results = [];
      for (i = _i = 0, _ref = COLS - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        _results.push({
          x: i
        });
      }
      return _results;
    })();
    $scope.$on('keydown', function(evt, x) {
      var log;
      if ($scope.gameOver) {
        return;
      }
      log = _.find($scope.logs, {
        x: x
      });
      if (log && log.isPassing) {
        $scope.player.score += 10;
        log.isBuzzed = true;
      } else {
        $scope.player.score -= 20;
      }
      return $scope.$digest();
    });
    $scope.$on('logPass', function(evt, log) {
      var index;
      return index = log.getAttribute('index');
    });
    $scope.$on('logEnd', function(evt, wasBuzzed) {
      if (!wasBuzzed) {
        $scope.player.lives--;
        return $scope.$digest();
      }
    });
    return $scope._expose = function() {
      return {
        generateLog: generateLog,
        continueGame: continueGame
      };
    };
  });

}).call(this);
