$(function(){
  $('.main-alert').each( function(){
    var $item = $(this);
    $item.hide().slideDown('fast');
    setTimeout(function(){
      $item.slideUp('fast');
    }, 3000)
  });

});
