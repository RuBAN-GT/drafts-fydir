@elements = {}

# search settings
@elements.search =
  minCharacters: 3
  maxResults: 10
  showNoResults: false
  error:
    noResults: I18n.t('js.no_results')

$(document).on 'turbolinks:load', ->
  # main sidebar
  $('.ui.main.sidebar').sidebar(
    mobileTransition: 'auto'
    silent: true
  ).sidebar('attach events', '.sidebar.switcher', 'show')

  # sticky
  $('.ui.sticky').sticky
    context: '.stickowner'
    offset: $('.main.fixed.menu').height() + 20
    pushing: true
    silent: true
    performance: false
    observeChanges: true
    verbose: false
    error:
      visible: ''
