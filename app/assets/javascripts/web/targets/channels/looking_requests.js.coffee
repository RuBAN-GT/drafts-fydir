App.looking_requests = App.cable.subscriptions.create "LookingRequestsChannel",
  connected: ->
    return

  disconnected: ->
    return

  received: (data) ->
    return if looking_requests.status() == 'pause'

    if data.status == 'save'
      looking_requests.push data.content, data.extra
    else if data.status == 'destroy'
      looking_requests.remove data.content
