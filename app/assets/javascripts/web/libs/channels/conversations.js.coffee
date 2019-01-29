App.conversations = App.cable.subscriptions.create "ConversationsChannel",
  connected: ->
    return

  disconnected: ->
    return

  received: (data) ->
    return unless data.type == 'conversation'

    $('.unread.label').text data.unseen_count

    if data.unseen_count > 0
      $('.unread.label').removeClass('default').addClass 'red'
    else
      $('.unread.label').removeClass('red').addClass 'default'
