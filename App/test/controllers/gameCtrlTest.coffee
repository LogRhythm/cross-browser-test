{expect} = chai

describe 'gameCtrl', ->

  beforeEach module 'LogRhythm'

  beforeEach inject ($rootScope, $controller, SETTINGS) ->
    @scope = $rootScope.$new()
    @SETTINGS = SETTINGS
    @initCtrl = =>
      @modal =
        open  : (@template, @cb) ->
        close : ->
      @ctrl            = $controller 'gameCtrl',
        $scope : @scope
        modal  : @modal

      {@player, @logs} = @scope
      {@generateLog, @continueGame}   = @scope._expose()

  it 'initial state', ->
    @initCtrl()
    expect(@player.score).to.equal 0
    expect(@player.lives).to.equal 10
    expect(@logs.length).to.equal 0
    expect(@modal.cb).to.be.ok
    expect(@modal.template).to.equal '/instructions.html'

  describe 'generateLog', ->

    beforeEach -> @initCtrl()

    it 'pushes a random log in acceptable parameters to be rendered', ->
      expect(@logs.length).to.equal 0

      @generateLog()

      expect(@logs.length).to.equal 1
      expect(@logs[0].x).to.exist
      expect(@logs[0].x).to.be.at.least 0
      expect(@logs[0].x).to.be.at.most @SETTINGS.COLS-1
      expect(@logs[0].y).to.exist
      expect(@logs[0].y).to.be.at.least 0
      expect(@logs[0].y).to.be.at.most @SETTINGS.MAX_HEIGHT

    it 'if all slots already have a log, do not push any more logs', ->
      for [0...@SETTINGS.COLS]
        @generateLog()

      # extra log
      @generateLog()

      expect(@logs.length).to.equal @SETTINGS.COLS

    it 'picks an available slot at random', ->

      testForN = (array) => =>
        @scope.logs = do -> for i in array
          y : 'foo'
          x : i

        @generateLog()

        xs = _.pluck @scope.logs, 'x'

        expect(xs).to.have.length array.length + 1

        expect(_.first xs, xs.length - 1).to.eql array
        lastX = _.last xs
        expect(lastX).to.not.equal i for i in array

      for j in [0..4]
        testForward  = testForN [0..j]
        testBackward = testForN [j..0]
        for [0...2000]
          testForward()
          testBackward()

  describe 'score', ->

    describe 'gain', ->
      beforeEach -> @initCtrl()

      it 'should increment score by 10 for every saw event matched by log', ->
        @generateLog()
        log = _.first @scope.logs

        log.isPassing = true
        @scope.$emit 'keydown', @scope.logs[0].x
        expect(@player.score).to.equal 10
        @scope.$emit 'keydown', @scope.logs[0].x
        expect(@player.score).to.equal 20
        @scope.$emit 'keydown', @scope.logs[0].x
        expect(@player.score).to.equal 30

      it 'should mark log as buzzed', ->
        @generateLog()
        log = _.first @scope.logs
        log.isPassing = true
        expect(log.isBuzzed).to.not.be.ok
        @scope.$emit 'keydown', @scope.logs[0].x
        expect(log.isBuzzed).to.be.true

    describe 'miss', ->
      beforeEach -> @initCtrl()

      it 'should decriment score by 20 if no log is passing', ->
        @player.score = 50
        @generateLog()
        log = _.first @scope.logs
        log.isPassing = false
        @scope.$emit 'keydown', @scope.logs[0].x
        expect(@player.score).to.equal 30

      it 'should remove one life if a log is missed entirely', (done)->
        @generateLog()
        log = _.first @scope.logs

        @scope.$on 'logEnd', =>
          expect(@player.lives).to.equal 9
          done()

        @scope.$emit 'logEnd', log.isBuzzed

    describe 'game over', ->
      beforeEach -> @initCtrl()

      it 'on player lives at 0', ->
        expect(@scope.gameOver).to.be.false

        @player.lives = 0
        @scope.$digest()

        expect(@modal.template).to.equal '/gameover.html'
        expect(@scope.gameOver).to.be.true

      it 'on player score less than -100', ->
        expect(@scope.gameOver).to.be.false

        @player.score = -101
        @scope.$digest()

        expect(@modal.template).to.equal '/gameover.html'
        expect(@scope.gameOver).to.be.true

    describe 'win', ->
      beforeEach -> @initCtrl()

      it 'on player score is 1000', ->
        expect(@scope.gameOver).to.be.false

        @player.score = 1000
        @scope.$digest()

        expect(@modal.template).to.equal '/win.html'
        expect(@scope.gameOver).to.be.true

      it 'on player score greater then 1000', ->
        expect(@scope.gameOver).to.be.false

        @player.score = 1000 + _.random 5, 500
        @scope.$digest()

        expect(@modal.template).to.equal '/win.html'
        expect(@scope.gameOver).to.be.true