$(function() {

  $("textarea[data-module='expand']").each(function () {
    var $input = $(this)

    var $form = $input.parents('form')
    var $label = $form.find('label')
    var $submit = $form.find("input[type='submit']")

    var hideFormUntilActive = $input.attr('data-expand-hide-form-until-active')

    autosize($input)
    $form.addClass('inactive')

    if (hideFormUntilActive) {
      $submit.hide()

      $label.hide()
      $input.attr('placeholder', $label.text() + '...')
      
      $input.on('focus', function () {
        $form.removeClass('inactive').addClass('active')
        $input.removeAttr('placeholder')
        $submit.show()
      })
    }
  })

})
