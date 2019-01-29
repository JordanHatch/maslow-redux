$(function () {
  $("*[data-module='tag-page-editor']").each(function () {
    var $form = $(this)

    var $container = $form.find('*[data-page-editor-role="column-set"]')

    var selectedNeedsSelector = '*[data-page-editor-role="selected-list"]'
    var otherNeedsSelector = '*[data-page-editor-role="other-list"]'
    var allNeedsSelector = '*[data-page-editor-role="all-needs"]'

    var $selectedNeedsList = $form.find(selectedNeedsSelector)
    var $otherNeedsList = $form.find(otherNeedsSelector)
    var $allNeedsList = $form.find(allNeedsSelector)

    $container.addClass('sortable-columns')
    $otherNeedsList.show()

    $allNeedsList.find('a').on('click', function (e) {
      e.preventDefault()
    })

    $selectedNeedsList.sortable({
      connectWith: otherNeedsSelector,
      items: '> li',
      receive: function (event, ui) {
        ui.item.find('input').removeAttr('disabled')
      },
      start: function (event, ui) {
        $container.addClass('dragging')
      },
      stop: function (event, ui) {
        $container.removeClass('dragging')
      }
    })
    $otherNeedsList.sortable({
      connectWith: selectedNeedsSelector,
      items: '> li',
      receive: function (event, ui) {
        window.console.dir(ui.item)
        ui.item.find('input').attr('disabled', 'disabled')
      },
      start: function (event, ui) {
        $container.addClass('dragging')
      },
      stop: function (event, ui) {
        $container.removeClass('dragging')
      }
    })

    $selectedNeedsList.find('.empty').remove()

    $.each($allNeedsList.find('li'), function () {
      var $item = $(this)
      var needId = $item.attr('data-need-id')

      var $input = $('<input>').attr('type', 'hidden')
      $input.attr('name', 'tag[priority_need_ids][]')
      $input.attr('value', needId)

      var $selectedItem = $selectedNeedsList.find('*[data-need-id=' + needId + ']')

      if ($selectedItem.length !== 0) {
        $selectedItem.remove()
        $input.appendTo($item)
        $item.appendTo($selectedNeedsList)
      } else {
        $input.attr('disabled', 'disabled')
        $input.appendTo($item)
        $item.appendTo($otherNeedsList)
      }
    })
  })
})
