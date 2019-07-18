window.MASLOW = window.MASLOW || {}

var MASLOW = window.MASLOW

MASLOW.need_criteria = {}

MASLOW.need_criteria.edit = function () {
  var form = document.querySelector('form.need_criteria')
  var list = form.querySelector('ul')

  var baseTemplate = list.querySelector('li:first-child').cloneNode(true)

  var getIndex = function () {
    var items = list.querySelectorAll('li')
    var lastItem = items[items.length - 1]
    var lastIndex = parseInt(lastItem.getAttribute('data-index'))

    return lastIndex + 1
  }

  var buildCriteria = function () {
    var item = baseTemplate.cloneNode(true)
    var index = getIndex()

    item.setAttribute('data-index', index)

    var inputs = Array.from(
      item.querySelectorAll('input')
    )
    var labels = Array.from(
      item.querySelectorAll('label')
    )

    var atts = ['name', 'id', 'htmlFor']

    inputs.concat(labels).forEach(function (el) {
      atts.forEach(function (attr) {
        if (el[attr] !== undefined) {
          el[attr] = el[attr].replace('0', index)
        }
      })
    })

    inputs.forEach(function (input) {
      if (input.type === 'text') {
        input.value = ''
      }
    })

    labels.forEach(function (label) {
      var els = label.querySelectorAll('*[data-label-index]')
      els.forEach(function (el) {
        el.innerText = el.innerText.replace('1', index + 1)
      })
    })

    bindDeleteButton(item)

    return item
  }

  var bindDeleteButton = function (container) {
    var deleteButton = container.querySelectorAll('*[data-action="delete"]')
    deleteButton.forEach(function (el) {
      el.addEventListener('click', deleteCriteria)
    })
  }

  var addCriteria = function (event) {
    event.preventDefault()
    list.appendChild(buildCriteria())
  }

  var deleteCriteria = function (event) {
    event.preventDefault()

    var criteria = this.parentNode
    criteria.classList.add('deleted')

    var input = criteria.querySelector('input[type=text]')
    input.disabled = true

    var checkbox = criteria.querySelector('input[type=checkbox]')
    checkbox.checked = true

    this.remove()
  }

  var addButton = form.querySelectorAll('*[data-action="add"]')
  addButton.forEach(function (el) {
    el.addEventListener('click', addCriteria)
  })

  bindDeleteButton(form)
}
