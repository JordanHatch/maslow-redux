/*
  Scrolls window to the top of an element on page load
*/
$(function(){
  $("*[data-module='scroll-to-element']").each(function(i, element) {
    $(window).scrollTop(
      $(element).offset().top
    );
  });
});
