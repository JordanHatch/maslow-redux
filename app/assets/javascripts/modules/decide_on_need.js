/*
  Display/hide applicable "Decide on need" form sections, based on
  the choice of decision
*/
$(function() {
  $("*[data-module='decide-on-need']").each(function(i, item) {
    var element = $(item);

    var displayRelevantFormFieldset = function() {
      var selectedStatusDescription = element.find('input.new-status-description:checked').val();
      var $relevantFieldset = element.find('fieldset[data-status-description="' + selectedStatusDescription + '"]');

      $relevantFieldset.show();

      var $allFieldsets = element.find('fieldset[data-status-description]');
      $allFieldsets.not($relevantFieldset).hide();
    }

    element.find('input.new-status-description').change(displayRelevantFormFieldset);
    displayRelevantFormFieldset(); // this arranges the form up correctly when it's first loaded
  });
});
