/* global $ */

function show_select_panel() {
	document.getElementById('select-panel').style.visibility = 'visible';
}

function hide_select_panel() {
	document.getElementById('select-panel').style.visibility = 'hidden';
}

function show_assembly_panel() {
	document.getElementById('assembly-panel').style.visibility = 'visible';
}

function hide_assembly_panel() {
	document.getElementById('assembly-panel').style.visibility = 'hidden';
}

$(document).ready( function() {
	$('select').material_select();
});