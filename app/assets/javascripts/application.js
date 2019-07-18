// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/widgets/draggable
//= require jquery-ui/widgets/sortable
//= require jquery.ui.touch-punch.min.js
//= require chosen-jquery
//= require autosize
//= require bootstrap
//= require Chart.bundle
//= require chartkick
//= require_self
//= require_tree .

/*
  We're using the Garber-Irish loading pattern to separate modules:
    https://www.viget.com/articles/extending-paul-irishs-comprehensive-dom-ready-execution/
*/

window.MASLOW = {
  common: {
    init: function () {
      var toDisable = document.querySelectorAll('.js-disabled')
      toDisable.forEach(function (el) {
        el.style.display = 'none'
      })

      document.querySelector('body').classList.add('js-enabled')
    }
  }
}

var UTIL = {
  exec: function (controller, action) {
    var ns = window.MASLOW
    action = (action === undefined) ? 'init' : action

    if (controller !== '' && ns[controller] && typeof ns[controller][action] === 'function') {
      ns[controller][action]()
    }
  },
  init: function () {
    var body = document.body
    var controller = body.getAttribute('data-controller')
    var action = body.getAttribute('data-action')

    UTIL.exec('common')
    UTIL.exec(controller)
    UTIL.exec(controller, action)
  }
}

$(document).ready(UTIL.init)
