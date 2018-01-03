$ ->
# "nav"を非表示
  $('nav').css('display', 'none')

  # "btn-flow"がクリックされた場合
  $('.btn-flow').on('click', ->
    $('nav').toggle()
    $(".line1").toggleClass("lineclick1")
    $(".line2").toggleClass("lineclick2")
    $(".line3").toggleClass("lineclick3")
  )

$(document).on('ready turbolinks:load', ->
  # "btn-flow"がクリックされた場合
  $('.btn-flow').on('click', ->
    $('nav').toggle()
    $(".line1").toggleClass("lineclick1")
    $(".line2").toggleClass("lineclick2")
    $(".line3").toggleClass("lineclick3")
  )

  # "btn-up"がクリックされた場合
  $('.btn-up').on('click', ->
    $(window).scrollTop(0)
  )

  # "btn-down"がクリックされた場合
  $('.btn-down').on('click', ->
    $(window).scrollTop($('footer').offset().top)
  )
)
