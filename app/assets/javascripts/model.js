/* global $, materials, SAVE_URL */

function make_new_material_section(name, id, quantity, measurement) {
	quantity = typeof quantity !== 'undefined' ? quantity : 0;
	measurement = typeof measurement !== 'undefined' ? measurement : "kg";

	var $li = $('<li></li>', {
		"class": 'material-section'
	});

	var $head = $('<div></div>', {
		"class": 'material',
		"text": name,
		"data-id": id,
		"data-name": name,
		"quantity": quantity,
		"measurement": measurement
	});

	var $body = $('<ul></ul>', {
		"class": 'collection processes'
	});

	var $procdrop = $('<li></li>', {
		"class": 'collection-item',
		"text": "Drop your " + name + " processes here."
	});

	// console.log("Creating a new Material..");

	$procdrop.appendTo($body);
	$head.appendTo($li);
	$body.appendTo($li);
	add_inputs($head, 'material');
	$head.find("#quantity").val(quantity);
	$head.find("#measurement").val(measurement);

	$li.droppable({
		greedy: true,

		drop: function(event, ui) {
			var from = ui.draggable[0];
			var id = $(from).data("id");
			var name = $(from).data("name");
			//if ($(from).data('type') == 'procedure') {
				//console.log($(this).processes.offsetparent.childElementCount);
				console.log($(this).find(".processes").children().length);
				if ($(this).find(".processes").children().length > 1) {
					add_proc_to($li, name, id, 0,$head.find("#measurement").val());
				}
				else {
					add_proc_to($li, name, id, $head.find("#quantity").val(),$head.find("#measurement").val());
				}
			//}

		}
	});

	var $delButton = make_delete_button($li, 'material');
	$delButton.appendTo($head);

	$li.appendTo($('#build'));
	return $li;
}

function add_inputs($obj, obj_type, css_type) {
	if (obj_type == "material" || obj_type == "process") {
		var $quant = $('<label for="quantity" class="label">Quantity</label> <input id="quantity" type="number" class="input-{#obj_type}">');
		$quant.appendTo($obj);
		var $measure = $('<label for="measurement" class="label">Measure</label> <input id="measurement" type="text" class="input-{#obj_type}">');
		$measure.appendTo($obj);
	}
}
//var $test = $('<label for="measurement" class="label">Measure</label> <input id="measurement" type="text" class="input-{#obj_type}">');

function add_proc_to($mat, name, id, quantity, measurement) {
	quantity = typeof quantity !== 'undefined' ? quantity : 0;
	measurement = typeof measurement !== 'undefined' ? measurement : "";
	var $proc = $('<li></li>', {
		"class": 'collection-item process',
		"text": name,
		"data-id": id,
		"data-name": name,
		"quantity": quantity,
		"measurement": measurement
	});
	var $delButton = make_delete_button($proc, 'process');
	$delButton.appendTo($proc);
	add_inputs($proc, 'process');

	$proc.find("#quantity").val(quantity);
	$proc.find("#measurement").val(measurement);

	// $mat.find('.processes :last-child').before($proc);
	$mat.find('.processes :last').before($proc);
}

function make_delete_button(element, css_type) {
	var $delButton = $('<span></span>', {
		"class": 'close-' + css_type,
		"text": "\u00D7"
	}).click(function() {element.remove();});
	return $delButton;
}

function build_data() {
	var result = [];
	$('#build > .material-section').each(function( index ) {
		var material = {};
		material["name"] = $(this).find(".material").data("name");
		material["id"] = $(this).find(".material").data("id");
		material["quantity"] = $(this).find("input#quantity").val()
		material["measurement"] = $(this).find("input#measurement").val()

		var procedures = [];
		$(this).find(".process").each(function (index) {
			procedures.push({"name": $(this).data("name"), "id": $(this).data("id"), "quantity": $(this).find("input#quantity").val(), "measurement": $(this).find("input#measurement").val()});
		});
		material["procedures"] = procedures;

		result.push(material);
	})
	//console.log(result)
	
	return result;
}

function fill_build(data, name) {
	//console.log(data)
	$("#assembly-title").val(name);
	for (var key in data){
		var material = data[key];
		var $mat = make_new_material_section(material["name"], material["id"], material["quantity"], material["units"]);
		for (var key in material["procedures"]) {
			var proc = material["procedures"][key];
			add_proc_to($mat, proc["name"], proc["id"], proc["quantity"], proc["units"]);
		}
	}
}

function clear_build() {
	$('#build *').remove();
}

function searchKeyPress(e){
	e = e||window.event;
    if (e.keyCode == 13) {
        $("#save").click();
        return false;
    }
    return true;
}
/*
Pretty hack-ey. document.ready doesn't seem to work here. This also causes problems loading custom css.
*/
// $(document).load(function() {
// 	$('#material-search').autocomplete({
// 		data: materials
// 	});
//
// 	$('.dropdown-content').css({'position': 'absolute', 'width': '350px'});
//
// });

    
$(document).on('turbolinks:load', function() {
	$('.draggable').draggable({
		containment: 'window',
		appendTo: 'body',
		helper: function (event) {
			return $('<div></div>', {
				"class": "drag-thing",
				"text": event.currentTarget.innerText
			})
		},

		cursorAt: {
			top: 25,
			left: 50,
		}
	});

	$('#material-search').autocomplete({
		data: materials
	});

	$('.dropdown-content').css({'position': 'absolute', 'width': '350px'});


	$('#assembly').droppable({
		drop: function (event, ui) {
			var item = ui.draggable[0]
			console.log(ui.draggable[0])
			var name = item.innerText;
			var id = $(item).data("id")

			//if ($(item).data('type') == 'material') {

				var $li = make_new_material_section(name, id);
			//}
		}
	});

	$('#build').sortable({
		containment: "window",
		appendTo: 'body'
	})
	
	$('#save').click(function() {
		Materialize.toast('Saving...', 2000);
		$.ajax({
			dataType: "json",
			type: "POST",
			url: SAVE_URL,
			data: { build: build_data(), assembly_name: $("#assembly-title").val() },
			success: function(response, status, xhr) {
				// console.log(response);
				Materialize.toast('Saved', 2000);
			},

			error: function(xhr, status, errorThrown) {
				// console.log(errorThrown);
			},

			complete: function (xhr, status) {
				// console.log(status);
			}
		});
	})

	$.ajaxSetup({
		headers: {
			'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
		}
	});

	// console.log(curr_assembly)
	if (curr_assembly !== null) {
		fill_build(curr_assembly, curr_name);
	}

	var menu_height = $('#menu .collapsible-header').first().height() * 5;
	var library_height = $('#library').height();


	// Tried dynamic height, fix later.
	// $('<style></style>', {
	// 	innerHTML: '#menu > li.active > .collapsible-body { max-height: ' + menu_height - library_height + ';}'
	// }).appendTo($('head'));
});


/* Material search feature: updates drop-down list every time material search text box is updated */
$(function(){

	$.expr[':'].Contains = function(a,i,m){
     return $(a).text().toUpperCase().indexOf(m[3].toUpperCase())>=0;
	};

	$('#material-search').keyup(function() {
		var input = $('#material-search').val();
		var categories = '#material-dropdown .collapsible .draggable';
		var materials = '#material-dropdown .collapsible .draggable'; //what makes material draggable - Todo: attach to materials
		$(categories).hide();
		$(materials).hide();
		$(materials + ':Contains('+ input +')').show();
		$(materials + ':Contains('+ input +')').closest('.collapsible').show();
	});

	$('#manufacturing-search').keyup(function() {
		var input = $('#manufacturing-search').val();
		var categories = '#manufacturing-dropdown .collapsible .draggable';
		var materials = '#manufacturing-dropdown .collapsible .draggable';
		$(categories).hide();
		$(materials).hide();
		$(materials + ':Contains('+ input +')').show();
		$(materials + ':Contains('+ input +')').closest('.collapsible').show();
	});
	
});
