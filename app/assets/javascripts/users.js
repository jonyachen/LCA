// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/
function runAnim(x) {
  $('#animator').removeClass().addClass(x + ' animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
    $(this).removeClass();
    $('#login_button').hide();
    $('#signup_button').hide();
  });
};

function ajaxcall(url, type, success_func) {
   $.ajax({
     url: url,
     type: type,
     success: success_func,
     error: function(){
        alert('Error occured!');
     }
   });
}


$(document).ready(function(){

   $('#login_button').click(function(e){
      runAnim('fadeOutDown');
      success_call = function(result){
        $("#loadcontent").html(result);
      };
      ajaxcall('/login', 'GET', success_call);
   });

   $('#signup_button').click(function(e){
      runAnim('fadeOutDown');
      success_call = function(result){
        $("#loadcontent").html(result);
      };
      ajaxcall('/signup', 'GET', success_call);
   });


});
