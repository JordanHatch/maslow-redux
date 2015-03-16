$(function(){

  var $navigation = $('nav.project');
  $navigation.hide();

  $navigation.on('click', function(event){
    event.stopPropagation();
  });
  $('.app-title a').on('click', function(event){
    // TODO: Re-enable this once the drop-down navigation is active.
    //
    // event.preventDefault();
    event.stopPropagation();
    $navigation.toggle();
  });
  $(window).on('click', function(){
    $navigation.hide();
  });

});
