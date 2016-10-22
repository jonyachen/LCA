/* global $ */

function show_select_panel() {
	document.getElementById('select-panel').style.visibility = 'visible';
}

function hide_select_panel() {
	document.getElementById('select-panel').style.visibility = 'hidden';
}

$(document).ready( function() {
	$('select').material_select();
});