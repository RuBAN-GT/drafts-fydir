# handle feed's updates
$(".play.button[data-status=#{looking_requests.status()}]").show()
$('.play.button').on 'click', ->
  $(this).hide()
  $(this).siblings('.play.button').show()

  looking_requests.change_status $(this).siblings('.play.button').attr('data-status')

# handle 404 errors for requests
$('.loads').on 'ajax:error', (e, xhr, status, error) ->
  location.reload() if xhr.status == 404

# open modal windows
modals.start '.ui.modal.looking_request'
