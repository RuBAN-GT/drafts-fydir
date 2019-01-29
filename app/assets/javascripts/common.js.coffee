@default_handlers = ->
  # hand 401 errors
  $("a").bind 'ajax:error', (event, jqXHR, ajaxSettings, thrownError) ->
    if jqXHR.status == 401
      window.location.replace(this)

  # handle missing images
  $('img').bind 'error', ->
    $(this).unbind('error').attr 'src', '/images/missing.jpg'

  # loading
  $('.loads').on 'ajax:beforeSend', ->
    loader.start()
  $('.loads').on 'ajax:complete', ->
    loader.stop()

  # popups
  $('[tooltip=true]').popup
    on: 'hover'
    variation: 'inverted'
    position: 'top center'
    lastResort: 'top center'
    silent: true
    observeChanges: true

  # tabs
  $('.tabs .item, .tabular .item').tab
    history: true

  # checkbox
  $('.ui.checkbox').checkbox()

  # beautiful dropdown
  $('.ui.dropdown').dropdown
    placeholder: false
    direction: 'downward'
    silent: true
    message:
      noResults: I18n.t('js.no_results')

  # accordeion
  $('.ui.accordion').accordion()

$(document).on 'turbolinks:load', @default_handlers
