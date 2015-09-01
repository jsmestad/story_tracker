//= require jquery
//= require jquery_ujs
//= require intro.min
//= require_tree .

$(document).ready(function() {
  $('#tour').on('click', function() {
    introJs().setOption('showBullets', false).setOption('showStepNumbers', false).start();
  });

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

  $('.hidden').hide();

  $('.follow a').on('click', function(e) {
    e.preventDefault();

    var $link = $(this);
    if ($link.hasClass('follow')) {
      $.ajax({
        url: $link.attr('href'),
        method: 'POST',
        success: function(data) {
          $link.hide();
          $link.siblings('a.unfollow').show();
        }
      });
    } else {
      $.ajax({
        url: $link.attr('href'),
        method: 'POST',
        data: {'_method': 'delete'},
        success: function(data) {
          $link.hide();
          $link.siblings('a.follow').show();
        }
      });
    }
  });
});
