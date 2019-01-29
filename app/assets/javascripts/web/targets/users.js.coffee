$(document).on 'turbolinks:load', ->
  # get list by nickname
  $('.ui.users.search[data-search="nickname"]')
    .search $.extend(elements.search, {
      apiSettings:
        url: "/api/v1/users/?nickname={query}"
        onResponse: (response) ->
          collection =
            results: []

          $.each response.Response.data, (i, item) ->
            collection.results.push
              title: item.nickname

          return collection
    })

  # get list by guardian name
  $('.ui.users.search[data-search="guardian_name"]')
    .search $.extend(elements.search, {
      apiSettings:
        url: "/api/v1/users/?guardian_name={query}"
        onResponse: (response) ->
          collection =
            results: []

          $.each response.Response.data, (i, item) ->
            collection.results.push
              title: item.guardian_name

          return collection
    })

  $('.ui.user.rating').rating
    maxRating: 5,
    interactive: false

  $('.ui.voted.rating').rating
    maxRating: 5,
    fireOnInit: false,
    clearable: true,
    onRate: (value) ->
      if $(this).is('.fired')
        url = $(this).data 'link'

        $.ajax
          method: 'POST',
          url: url,
          data: { user_ratio: { point: value } }
      else
        $(this).addClass 'fired'
