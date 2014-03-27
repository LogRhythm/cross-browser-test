angular.module('LogRhythm').service 'modal', ($templateCache) ->
  class Modal
    open : (template, callback) ->
      @callback = callback or ->
      @container           = document.createElement 'div'
      @container.innerHTML = $templateCache.get '/modal.html'
      document.body.appendChild @container
      if template
        mc = document.getElementById 'modalContent'
        mc.innerHTML = $templateCache.get template
      @listen()

    listen : ->
      closers = document.querySelectorAll '#closeModal, #overlay, .closer'
      for closer in closers
        angular.element(closer).bind 'click', -> @close()

    close : ->
      document.body.removeChild @container
      @callback()

  return new Modal()