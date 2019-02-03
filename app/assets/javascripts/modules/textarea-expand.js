$(function() {

  $("textarea[data-module='expand']").each(function () {
    var $input = $(this)

    var $form = $input.parents('form')
    var $label = $form.find('label')
    var $submit = $form.find("input[type='submit']")

    var hideFormUntilActive = $input.attr('data-expand-hide-form-until-active')

    autosize($input)
    $form.addClass('inactive')

    $label.hide()
    $input.attr('placeholder', $label.text() + '...')

    if (hideFormUntilActive) {
      $submit.hide()
      $input.on('focus', function () {
        $form.removeClass('inactive').addClass('active')
        $input.removeAttr('placeholder')
        $submit.show()
      })
    }
  })

})
