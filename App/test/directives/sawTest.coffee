{expect} = chai

sawHTML = """
  <div id="container">
    <saw x="{{saw.x}}" ng-repeat="saw in saws" is-testing="true"></saw>
  </div>
"""

makeTrigger = (upDown) -> (key) ->
  $('saw').trigger "testkey#{upDown}", key

describe 'saw', ->

  beforeEach module 'LogRhythm'

  beforeEach inject ($rootScope, $compile, keyHASH) ->
    @scope      = $rootScope.$new()
    @scope.saws = (x : i for i in [0..5])
    @keyHASH    = keyHASH
    @triggerKeyUp   = makeTrigger 'up'
    @triggerKeyDown = makeTrigger 'down'
    @init       = =>
      @elem = $ $compile(sawHTML)(@scope)
      $('body').append @elem
      @scope.$digest()

  beforeEach -> @init()

  afterEach ->
    @elem.remove()
    KeyboardJS.clear.key key for key in @keyHASH

  it 'should update elemnt on scope', ->

    for key, i in @keyHASH
      expect(@scope.saws[i].isDown).to.be.false
      @triggerKeyDown key
      expect(@scope.saws[i].isDown).to.be.true
      @triggerKeyUp key
      expect(@scope.saws[i].isDown).to.be.false

  it 'should fire scope events', ->

    j = null
    @scope.$on 'keydown', (evt, x) -> expect(x).to.equal j
    for key, i in @keyHASH
      j = i
      @triggerKeyDown key
      @triggerKeyUp key

  it 'should add class "buzz"', ->
    saws = @elem.find 'saw'

    for key, i in @keyHASH
      expect(saws.eq(i).hasClass 'buzz').to.be.false
      @triggerKeyDown key
      expect(saws.eq(i).hasClass 'buzz').to.be.true
      @triggerKeyUp key
      expect(saws.eq(i).hasClass 'buzz').to.be.false
        

        





