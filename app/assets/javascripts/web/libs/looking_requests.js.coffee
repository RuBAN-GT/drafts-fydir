@looking_requests =
  container: ->
    $('.looking_requests.grid')
  selector: ->
    @container().find('.looking_requests.items')
  collection: ->
    @selector().find '.item'

  status: ->
    return 'pause' unless location.search == ''

    if storage = localStorage.getItem 'looking_requests.status'
      default_status = storage
    else
      default_status = 'play'

    if @current_status == undefined then default_status else @current_status
  change_status: (status) ->
    if status == 'play'
      @current_status = 'play'
    else
      @current_status = 'pause'

    localStorage.setItem 'looking_requests.status', @current_status

  push: (request, id = null) ->
    if id != null && @find(id).length
      @find(id).replaceWith request
    else
      $(request).hide().prependTo(@selector()).fadeIn 400

    $('.empty.message').transition('hide') if @collection().length > 0

    if @collection().length > 300
      @collection().slice(30).fadeOut 400

  remove: (id) ->
    @find(id).fadeOut 400, ->
      $(this).remove()

      if looking_requests.collection().length == 0
        if looking_requests.container().find('.more.button').length
          location.reload()
        else
          $('.empty.message').transition('show')

  find: (id) ->
    @collection().filter "[data-id=#{id}]"

  scroll: (pos) ->
    pos = @container().height() if pos == null || pos == undefined

    $(window).scrollTop pos
