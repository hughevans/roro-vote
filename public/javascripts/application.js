////
// Behaviours
$(document).ready(function() {

  ////
  // AJAX paginatation - http://ozmm.org/posts/ajax_will_paginate_jq_style.html
  $('.pagination a').livequery('click', function() {
    $('#live_table').fadeOut('fast').load(this.href).fadeIn('fast');
    return false;
  });
});

////
// Rails responds_to fix - http://ozmm.org/posts/jquery_and_respond_to.html
jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {
    xhr.setRequestHeader("Accept", "text/javascript");
  } 
})