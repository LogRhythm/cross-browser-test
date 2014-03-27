{expect} = chai

modalHTML = """
  <div id="container">
    <div id="overlay"></div>
    <div id="modal">
      <div id="closeModal">X</div>
      <div id="modalContent"></div>
    </div>
  </div>
"""

describe 'modal', ->

  beforeEach module 'LogRhythm'

  beforeEach inject ($injector, $templateCache) ->
    $templateCache.put '/modal.html', modalHTML
    @modal = $injector.get 'modal'
    @$templateCache = $templateCache

  afterEach -> $('#container').remove()

  it 'should open on open', ->
    expect($ '#modal').to.have.length 0
    @modal.open()
    expect($ '#modal').to.have.length 1

  it 'should close on close', ->
    @modal.open()
    expect($ '#modal').to.have.length 1
    @modal.close()
    expect($ '#modal').to.have.length 0

  describe 'close if clicked', ->
    beforeEach ->
      $('body').append "<div class='closer'>close</div>"
    afterEach -> $('.closer').remove()

    for item in ['#overlay', '#closeModal', '.closer']
      it item, ->
        @modal.open()
        $(item).trigger 'click'
        expect($ '#modal').to.have.length 0

  describe 'open with template', ->
    beforeEach ->
      @$templateCache.set '/win.html', "<h1>WIN!</h1>"

    it 'should accept a template for open', ->
      @modal.open '/win.html'
      expect($('#modalContent').find 'h1').to.have.length 1

    it 'should fire callback on close', (done) ->
      @modal.open '/win.html', done
      @modal.close()



