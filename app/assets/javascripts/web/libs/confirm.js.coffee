# Replace default rails confirmation dialog
$(document).on 'turbolinks:load', ->
  $.rails.allowAction = (link) ->
    return true unless link.attr 'data-confirm'

    $.rails.showConfirmDialog(link)

    false

  $.rails.confirmed = (link) ->
    window.history.pushState '', '', link.data('backurl') if link.data 'backurl'

    link.removeAttr 'data-confirm'
    link.trigger 'click.rails'

  $.rails.showConfirmDialog = (link) ->
    if typeof(link.attr('data-confirm')) == 'string' && link.attr('data-confirm') != 'true'
      message = link.attr 'data-confirm'
    else
      message = I18n.t 'js.modal.message'

    title   = link.attr('data-title') || link.attr('title') || I18n.t('js.modal.title')
    ok      = link.attr('data-ok') || I18n.t('js.modal.ok')
    cansel  = link.attr('data-cansel') || I18n.t('js.modal.cansel')
    icon    = link.attr('data-icon') || 'trash'

    html = """
          <div id="confirmation" class="ui small modal">
            <i class="close icon"></i>
            <div class="header">
              <i class="icon #{icon}"></i>
              #{title}
            </div>
            <div class="content">
              <p>#{message}</p>
            </div>
            <div class="actions">
              <div class="ui cancel black icon labeled button">
                <i class="remove icon"></i>
                #{cansel}
              </div>
              <div class="ui ok green icon labeled button">
                <i class="checkmark icon"></i>
                #{ok}
              </div>
            </div>
          </div>
           """
    $(html).modal(
      onApprove: (element) ->
        $.rails.confirmed link
    ).modal('show')
