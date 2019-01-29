@modals =
  container: ->
    $('.ui.main.container')

  exists: (selector) ->
    $('body').find(selector).length > 0

  init: (selector, layout = null) ->
    if @exists selector
      $(selector).remove()

    @container().append layout

    @start selector

  start: (selector)->
    return if $(selector).length == 0

    # prepare
    $('.ui.modal').not(selector).modal('hide')

    # init
    $(selector).modal(
      autofocus: false,
      onShow: ->
        modals.on_show()

        default_handlers()

        title = $(this).data 'target-title'
        window.history.replaceState {
          last_url: location.href,
          last_title: document.title
        }, title, $(this).data('target-url')

        document.title = title if title
      onVisible: ->
        modals.on_visible()
      onHide: ->
        modals.on_hide()

        title = modals.last_title()
        window.history.replaceState {
          last_url: location.href,
          last_title: document.title
        }, title, $(this).data('root-url')

        document.title = title if title
      onHidden: ->
        modals.on_hidden()
    ).modal 'show'

    # handle submit
    $(selector).find('> .actions button.primary').click ->
      $(selector).find('> .content form').submit()

    # history following
    window.onpopstate = (event) ->
      if modals.last_url() && modals.last_url() != location.href
        Turbolinks.visit modals.last_url()

    # clear old data
    $(document).on 'turbolinks:before-visit', ->
      # remove old dom with chat
      $(selector).modal 'hide'

      # clear cache
      Turbolinks.clearCache()

  # handlers
  on_show: ->
    return
  on_hidden: ->
    return
  on_hide: ->
    return
  on_visible: ->
    return
  last_title: ->
    tmp = window.history.state && window.history.state.last_title

    if (!!tmp) then tmp else null
  last_url: ->
    tmp = window.history.state && window.history.state.last_url

    if (!!tmp) then tmp else null
