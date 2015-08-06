//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function() {
  $edit_user_form = $('form.edit_user');
  if ($edit_user_form.length > 0) {
    $api_key_field = $('#user_api_key');

    var changeState = function($field, $hint) {
      if ($field.val().length > 0) {
        $hint.addClass('done');
      } else {
        $hint.removeClass('done');
      }
    }

    $('#user_email_address').on('focusout', function() {
      changeState($(this), $(this).closest('form').find('.hint.email_address'));
    }).trigger('focusout');
    $('#user_api_key').on('focusout', function() {
      changeState($(this), $(this).closest('form').find('.hint.api_key'));
    }).trigger('focusout');
  }
});
