@chatbox =
  selector: ->
    $('.chatbox')

  widget: ->
    $('.chatbox.widget', parent.document)

  is_iframe: ->
    top != window

  is_inner_link: (link) ->
    link.indexOf('/widgets/conversations') != -1

  correct_size: ->
    $(window).width() > 767

  close: ->
    if @is_iframe()
      localStorage.removeItem 'widgets.chatbox.link'
      localStorage.removeItem 'widgets.chatbox.minimized'

      @widget().remove()

  is_minimized: ->
    !!localStorage.getItem('widgets.chatbox.minimized')

  toggle: ->
    if @is_iframe()
      if @is_minimized()
        @widget().removeClass 'minimized'

        localStorage.removeItem 'widgets.chatbox.minimized'
      else
        @widget().addClass 'minimized'

        localStorage.setItem 'widgets.chatbox.minimized', true

$(document).on 'turbolinks:load', ->
  # iframe events
  if top == window
    $('.toggle.link').remove()
  else
    # go out from other pages
    chatbox.close() unless chatbox.is_inner_link(window.location.href)

    # close action
    $('.close.link').click (e) ->
      e.preventDefault()

      chatbox.close()

    # minimisze action
    $('.toggle.link').click ->
      chatbox.toggle()

    # save locations & goto outsize links
    $('a').not('[data-remote="true"]').click (e) ->
      e.preventDefault()

      link = this.href

      if chatbox.is_inner_link link
        localStorage.setItem 'widgets.chatbox.link', link

        Turbolinks.visit link
      else
        parent.window.open link, '_blank'
