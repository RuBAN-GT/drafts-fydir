@conversations =
  container: ->
    $('.conversations.grid')
  selector: ->
    @container().find('.conversations.elements')
  collection: ->
    @selector().find('.element')

  render: (conversation, id = null) ->
    if id != null && @find(id).length
      @find(id).replaceWith conversation
    else
      $(conversation).hide().prependTo(@selector()).fadeIn 400

    $('.full.message').transition('hide') if @collection().length > 0

    if @collection().length > 300
      @collection().slice(30).fadeOut 400

  push: (conversation) ->
    $.getScript conversation.link

  remove: (id) ->
    @find(id).fadeOut 400, ->
      $('.ui.popup.visible').remove()
      $(this).remove()

      if conversations.collection().length == 0
        if conversations.container().find('.pagination').length
          location.reload()
        else
          $('.full.message').transition('show')

  find: (id) ->
    @collection().filter "[data-id=#{id}]"
