logTemplate = """
  <div class="log" style="position:absolute;">
    <div class="top"></div>
    <div class="bottom"></div>
    <div class="middle"></div>
  </div>
"""

STAGE_DIM = 300

logHTML = """
  <div id="stage"
    style="height:#{STAGE_DIM}px;width:#{STAGE_DIM}px;position:relative;">
    <log ng-repeat="log in logs" x="{{log.x}}" y="{{log.y}}"
    index="{{$index}}" is-testing="true"></log>
  </div>
"""

{expect} = chai

describe 'Log', ->

  beforeEach module 'LogRhythm'

  beforeEach inject ($rootScope, $templateCache, $compile) ->
    $templateCache.put '/log.html', logTemplate
    @scope      = $rootScope.$new()
    @scope.logs = [ x : 0, y : 0 ]
    @init       = =>
      @elem     = $ $compile(logHTML)(@scope)
      $('body').append @elem
      @scope.$digest()

  afterEach -> @elem.remove()

  describe 'animation', ->

    beforeEach ->
      @init()
      @logDom = @elem.find '.log'

    it 'should exist', ->
      expect(@logDom).to.exist

    it 'should animate right away', (done) ->
      originStyle = @logDom.attr 'style'
      setTimeout =>
        expect(@logDom.attr 'style').to.not.equal originStyle
        done()
      , 17

    it 'should delete itself on completion', (done) ->
      expect(@scope.logs).to.have.length 1
      setTimeout =>
        expect(@scope.logs).to.be.empty
        done()
      , 16 * 2

    it 'should emit a `logEnd` event with the end-state of the
    log on completion',(done) ->
      log = _.first @scope.logs
      log.isBuzzed = true
      @scope.$on 'logend', (evt, wasBuzzed)->
        expect(wasBuzzed).to.be.true
        done()

    it 'on gameOver, kills animation', (done)->
      tweens = TweenLite.getTweensOf @logDom
      @scope.gameOver = true
      @scope.$digest()

      setTimeout ->
        expect(tweens[0].isActive()).to.be.false
        done()
      , 200

    it 'should set the `isPassing` attribute to true per
    log appropriately', (done) ->
      @scope.$on 'logPass', (evt, log) =>
        index = parseInt log.getAttribute 'index'
        log = @scope.logs[index]
        expect(log.isPassing).to.be.true
        done()

    it 'should be positioned based left on x', ->
      @scope.logs = [ x : 5, y : 0 ]
      @scope.$digest()
      expect(parseInt $('.log').css 'left').to.equal 87 * 5
