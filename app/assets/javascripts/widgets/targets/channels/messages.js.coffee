App.messages = App.cable.subscriptions.create "MessagesChannel",
  connected: ->
    setTimeout =>
      @followConversation()
    , 1000

  disconnected: ->
    return

  followConversation: ->
    id = messages.id()

    if id
      @perform 'follow', conversation: id
    else
      @perform 'unfollow'

  received: (data) ->
    messages.push data
