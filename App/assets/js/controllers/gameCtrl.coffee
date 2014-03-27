angular.module('LogRhythm').controller 'gameCtrl', ($scope,
  $interval, modal, SETTINGS) ->

  {COLS, MAX_HEIGHT} = SETTINGS
  continueGame       = null
  
  $scope.logs        = []
  $scope.gameOver    = false
  $scope.player      =
    score : 0
    lives : 10

  generateLog = ->
    if $scope.logs.length is COLS
      return

    if $scope.logs.length
    then x = _.sample(_.difference([0..COLS - 1], _.pluck($scope.logs, 'x')), 1)
    else x = _.sample([0..COLS-1], 1)

    $scope.logs.push
      x    : _.first x
      y    : _.random 0, MAX_HEIGHT

  gameOver = ->
    $interval.cancel continueGame
    $scope.gameOver = true

  lose = ->
    modal.open '/gameover.html', -> location.reload()
    gameOver()

  win = ->
    modal.open '/win.html', -> location.reload()
    gameOver()

  modal.open '/instructions.html', ->
    continueGame = $interval generateLog, 1500

  $scope.$watch 'player.lives', (value) ->
    lose() if value is 0

  $scope.$watch 'player.score', (value) ->
    if value < -100
      lose()
    if value >= 1000
      win()

  $scope.saws = (x : i for i in [0..COLS - 1])

  $scope.$on 'keydown', (evt, x) ->
    if $scope.gameOver
      return

    log = _.find $scope.logs, x : x
    if log and log.isPassing
      $scope.player.score += 10
      log.isBuzzed = true
    else $scope.player.score -= 20
    $scope.$digest()

  $scope.$on 'logPass', (evt, log) ->
    index = log.getAttribute 'index'

  $scope.$on 'logEnd', (evt, wasBuzzed) ->
    unless wasBuzzed
      $scope.player.lives--
      $scope.$digest()

  $scope._expose = ->
    generateLog  : generateLog
    continueGame : continueGame
