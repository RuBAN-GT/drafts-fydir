# = require ./channels/messages

# hide paginations
$('.more').hide()

# hide button if iframe
$('.textbox button').hide() if chatbox.is_iframe()

# infinity scroll
messages.scroll()
$('.scrollbox').scroll ->
  link = $('.more').not('.disabled').find('a')

  if link && $('.scrollbox').scrollTop() == 0
    save = messages.collection().first()

    link.click()
    $(link).on 'ajax:complete', ->
      messages.scroll (save.position().top - save.height())

# keypressing & clicking
$('.textbox .textfield input').keypress (event) ->
  return unless event.which == 13 && $(this).val()

  event.preventDefault()

  $('.chatbox form').submit()

  $(this).val ''

# handle sendbutton
$('.textbox button').click (event) ->
  return unless $('.chatbox form .textfield input').val()

  event.preventDefault()

  $('.chatbox form').submit()

  $('.chatbox form .textfield input').val ''
