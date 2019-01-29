@messages =
  container: ->
    $('.conversation[data-conversation]')
  selector: ->
    @container().find ' > .messages'
  collection: ->
    @selector().find '> .message'

  id: ->
    @container().data 'conversation'

  scroll: (pos) ->
    pos = @selector().height() if pos == null || pos == undefined

    $('.scrollbox').scrollTop pos

  drop_full_message: ->
    @container().find('.full.message').remove()

  find: (id) ->
    @collection().filter "[data-id=#{id}]"

  render: (message, id = null) ->
    if id != null && @find(id).length
      @find(id).replaceWith message
    else
      $(message).hide().appendTo(@selector()).fadeIn 400

      @drop_full_message()

      @scroll()

  push: (message) ->
    $.getScript message.link
