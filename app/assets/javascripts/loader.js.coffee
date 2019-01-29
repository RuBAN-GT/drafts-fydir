@loader =
  selector: ->
    $('body')

  block: ->
    $('body > .loading')

  render: ->
    """
    <div class="ui active #{@render_class} loading dimmer" style="display: none;">
      <div class="ui text loader">#{I18n.t('js.loading')}</div>
    </div>
    """

  render_class: 'default'

  start: ->
    @selector().append @render() if @block().length == 0

    @selector().css 'overflow', 'hidden'
    @block().fadeIn 400

  stop: ->
    @block().fadeOut 400, ->
      loader.selector().css 'overflow', ''

  remove: ->
    @block().fadeOut 400, ->
      loader.selector().css 'overflow', ''

      $(this).remove()
