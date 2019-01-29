App.conversations = App.cable.subscriptions.create "ConversationsChannel",
  connected: ->
    return

  disconnected: ->
    return

  received: (data) ->
    return unless data.type == 'conversation'

    if data.status == 'save'
      conversations.push data
    else if data.status == 'destroy'
      conversations.remove data.id
