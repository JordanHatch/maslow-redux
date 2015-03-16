$(function(){

  var $navigation = $('nav.project');
  var $dropdownIcon = $('.dropdown-icon');

  $navigation.addClass('as-dropdown-menu').hide();
  $dropdownIcon.css('visibility', 'visible');

  $navigation.on('click', function(event){
    event.stopPropagation();
  });
  $('.app-title a').on('click', function(event){
    event.preventDefault();
    event.stopPropagation();
    $navigation.toggle();
  });
  $(window).on('click', function(){
    $navigation.hide();
  });

});
