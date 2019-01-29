@Flash =
  # show notifciation
  push: (flash, timeout = 0) ->
    f = $(flash).hide().appendTo('#flash').fadeIn(400)

    if timeout > 0
      setTimeout (->
        @close f
      ), timeout

  # close notification
  close: (selector) ->
    $(selector).fadeOut 400, ->
      $(this).remove()

$(document).on 'turbolinks:load', ->
  $('#flash').on 'click', '.flash .close', ->
    Flash.close $(this).closest('.flash')
