$(function() {

  $("textarea[data-module='expand']").each(function () {
    var $input = $(this)

    var $form = $input.parents('form')
    var $label = $form.find('label')
    var $submit = $form.find("input[type='submit']")

    autosize($input)
    $form.addClass('inactive')

    $label.hide()
    $input.attr('placeholder', $label.text() + '...')

    $submit.hide()
    $input.on('focus', function () {
      $form.removeClass('inactive').addClass('active')
      $input.removeAttr('placeholder')
      $submit.show()
    })
  })

})
