$(function(){
  $("*[data-module='bookmark']").each(function(i, item){
    var $el = $(item);
    var $submitBtn = $el.find('input[type=submit]');
    var $icon = $el.find('span.bookmark-icon');

    $submitBtn.hide();
    $icon.on('click', function(e){
      e.preventDefault();
      $submitBtn.click();
    });
  })
});
