@chatbox =
  selector: ->
    $('.chatbox.widget')

  iframe: ->
    @selector().find('iframe')

  content: ->
    @iframe().contents()

  root_path: ->
    $('.chatbox.item').attr 'href'

  start: ->
    unless @is_started()
      $('body').append """
      <div class="not mobile chatbox widget"></div>
      """

      if @is_minimized()
        @selector().addClass 'minimized'
      else
        @new_loader()
  is_started: ->
    !!@selector().length

  new_loader: ->
    @selector().prepend """
      <div class="ui active inverted dimmer">
        <div class="ui text loader">#{I18n.t('js.loading')}</div>
      </div>
    """ unless @selector().find('.loader').length
  remove_loader: ->
    @selector().find('.ui.dimmer').remove()

  correct_size: ->
    $(window).width() > 991

  open: (link) ->
    link = @root_path() if link != @root_path() && link.indexOf(@root_path()) == -1

    unless @correct_size()
      window.open link, '_blank'
      return

    if @is_started()
      @close()
      @new_loader() unless @is_minimized()
    else
      @start()

    iframe = $('<iframe/>',
      id: 'widget',
      src: link,
      name: 'chatbox',
      style: 'display: none',
      load: ->
        $(this).show()

        chatbox.remove_loader() unless chatbox.is_minimized()
    )

    @selector().append iframe

    localStorage.setItem 'widgets.chatbox.link', link
  close: ->
    @iframe().remove()

    localStorage.removeItem 'widgets.chatbox.link'
    localStorage.removeItem 'widgets.chatbox.minimized'

  is_minimized: ->
    !!localStorage.getItem('widgets.chatbox.minimized')

$(document).on 'turbolinks:before-visit', ->
  # remove old dom with chat
  chatbox.selector().remove()

$(document).on 'turbolinks:load', ->
  # autoopen last chats
  if $('body').data('nickname') && chatbox.correct_size()
    link = localStorage.getItem 'widgets.chatbox.link'
    chatbox.open link unless link == null
