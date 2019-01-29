# scoll nav change
$(document).scroll ->
  menu = $('.ui.fixed.main.menu')

  if $(this).scrollTop() > $('.main.branding').height() - 30
    menu.removeClass 'transparent' if menu.is '.transparent'
  else
    menu.addClass 'transparent' unless menu.is '.transparent'
