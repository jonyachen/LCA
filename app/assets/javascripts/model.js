/* global _, $, materials, SAVE_URL */


function make_new_material_section(name, id, quantity, measurement) {
	quantity = typeof quantity !=='undefined'? quantity : 1;
	measurement = typeof measurement !=='undefined'? measurement : "kg";
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

	 console.log("Creating a new Material..");

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
			var units = $(from).data("units")
			if (units == ""){ units = undefined }
			//if ($(from).data('type') == 'procedure') {
				//console.log($(this).find(".processes").children().length);
				if ($(this).find(".processes").children().length > 1) {
					add_proc_to($li, name, id, $head.find("#quantity").val(),units); //if already one child
				}
				else {
					add_proc_to($li, name, id, $head.find("#quantity").val(),units);
				}
			//}

		}
	});

	var $delButton = make_delete_button($li, 'material');
	$delButton.appendTo($head);

	$li.appendTo($('#build')); //appends material to bottom of build
	return $li;
}

function make_new_subassembly(){
	//quantity = typeof quantity !== 'undefined' ? quantity : 0;
	//measurement = typeof measurement !== 'undefined' ? measurement : "kg";
	var $li = $('<li></li>', {
		"class": 'material-section'
	});

	var $head = $('<div></div>', {
		"class": 'subassembly',
		"text":"\uD83D\uDCC2  " + "Subassembly A",
		//"data-id": id,
		//"data-name": name,
		//"quantity": quantity,
		//"measurement": measurement
	});
	
	var $delButton = make_delete_button($li, 'material');
	$delButton.appendTo($head);

	var $body = $('<ul></ul>', {
		"class": 'collection processes'
	});

	var $procdrop = $('<li></li>', {
		"class": 'subassembly-item',
		"text": "Drop items into subassembly here."
	});

	//console.log("Creating a new Material..");

	$procdrop.appendTo($body);
	$head.appendTo($li);
	$body.appendTo($li);
	//add_inputs($head, 'material');
	//$head.find("#quantity").val(quantity);
	//$head.find("#measurement").val(measurement);


	$li.droppable({
		greedy: true,

		drop: function(event, ui) {
			/*
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
				*/
				var from = ui.draggable[0];
				var id = "4";
				var name = from.innerText;
				add_subassembly_to($li, name, id, 0, 0);
				
				/*
				var $new_li = $('<li></li>', {
					"class": 'material-section'
				});
				var $new_head = $('<div></div>', {
					"class": 'material',
					"text":"TEST",
				});
				var $new_delButton = make_delete_button($new_li, 'material');
				$new_delButton.appendTo($new_head);
				var $new_body = $('<ul></ul>', {
					"class": 'collection processes'
				});
				var $new_procdrop = $('<li></li>', {
					"class": 'collection-item',
					"text": "Drop items into material here."
				});
				$new_procdrop.appendTo($new_body);
				$new_head.appendTo($new_li);
				$new_body.appendTo($new_li);
				$new_li.insertAfter(".subassembly");
				*/
			//}
		}
		
		/*
		drop: function (event, ui) {
			var item = ui.draggable[0]
			var name = item.innerText;
			var id = $(item).data("id")

			var type = $(item).data('type')
			if (type == 'material') {

				var $li = make_new_material_section(name, id);
			}
		}
		*/
	});



	$li.appendTo($('#build')); //appends material to bottom of build
	return $li;
}

function add_inputs($obj, obj_type, css_type) {
	console.log($obj);
	// Need to remove hardcode - grab from DB Unit table based on type attribute instead
	unit_types = {
		"mass": ["kg","oz","lb","metric ton"], 
		"SA": ["m^2","in^2","ft^2"], 
		"length": ["in","ft","m","mi"], 
		"volume": ["m^3"],
		"energy": ["kWh"],
		"payload": ["metric ton*km"]
	}
	if (obj_type == "material" || obj_type == "process") {
		console.log($obj)
		var unit_re = /measurement="(.*?)"/i;
		var default_unit = $obj[0].outerHTML.match(unit_re)[1]
		var unit_type = _.findKey(unit_types, function(list) { return _.contains(list, default_unit); });
		
		var $quant = $('<label for="quantity" class="label">Quantity</label> <input id="quantity" type="number" class="input-{#obj_type}" style="height:20px; width:30px; font-size:10pt;" >');
		$quant.appendTo($obj);
		
		
		
		//var $measure = $('<label for="measurement" class="label">Measure</label> <input id="measurement" type="text" class="input-{#obj_type}" style="height:20px; width:30px; font-size:10pt;">');
		var measurement_text = '<label for="measurement" class="label">Measure</label><select id="measurement">'
		var available_units = unit_types[unit_type];
		for (var i in available_units){
			measurement_text += '<option value="'
			measurement_text += available_units[i]
			measurement_text += '">'
			measurement_text += available_units[i]
			measurement_text += '</option>'
		} 
		measurement_text += '</select>'
		
		//measurement_text += '<select id="measurement"><option value="foo">kg</option><option value="bar">m^2</option></select>'
		//var $measure = $('<label for="measurement" class="label">Measure</label><select id="measurement"><option value="kg">kg</option><option value="m^2">m^2</option><option value="kWh">kWh</option></select>')
		var $measure = $(measurement_text)
		$measure.appendTo($obj);
	}
}

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

function add_subassembly_to($mat, name, id, quantity, measurement) {
	quantity = typeof quantity !== 'undefined' ? quantity : 0;
	measurement = typeof measurement !== 'undefined' ? measurement : "";
	var $proc = $('<li></li>', {
		//"class": 'collection-item process',
		"class": 'material', //change to block?
		"text": "metals", //hack
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
		material["measurement"] = $(this).find("select#measurement :selected").val();
		
		var procedures = [];
		$(this).find(".process").each(function (index) {
			procedures.push({"name": $(this).data("name"), "id": $(this).data("id"), "quantity": $(this).find("input#quantity").val(), "measurement": $(this).find("select#measurement :selected").val()});
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

		var $mat = make_new_material_section(material["name"], material["id"], material["quantity"], material["measurement"]);
		for (var key in material["procedures"]) {
			var proc = material["procedures"][key];
			add_proc_to($mat, proc["name"], proc["id"], proc["quantity"], proc["measurement"]);
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


	$('#assembly').droppable({ //lets you drop things into main build
		drop: function (event, ui) {
			var item = ui.draggable[0]
			//console.log(ui.draggable[0])
			var name = item.innerText;
			var id = $(item).data("id")
			var units = $(item).data("units")
			if (units == ""){ units = undefined }
			var type = $(item).data('type')
			if (type == 'material') {
				var $li = make_new_material_section(name, id, undefined, units);
			}
		}
	});

	$('#build').sortable({
		containment: "window",
		appendTo: 'body'
	})
	
	$('#add_subassembly').click(function() {
		//var id = "test";
		var $li = make_new_subassembly();
	})
	
	$('#save').click(function() {
		Materialize.toast('Saving...', 2000);
		$.ajax({
			dataType: "json",
			type: "POST",
			url: SAVE_URL,
			data: { build: build_data(), assembly_name: $("#assembly-title").val() },
			success: function(response, status, xhr) {
				//console.log(response);
				Materialize.toast('Saved', 2000);
			},

			error: function(xhr, status, errorThrown) {
				 console.log(errorThrown);
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

	//Can be merged into one function, but this allows for unique implementations while testing
	
	$('#materials-search').keyup(function() {
		var input = $('#materials-search').val();
		var categories = '#materials-dropdown .collapsible';
		var materials = '#materials-dropdown .collapsible'; //what makes material draggable - Todo: attach to materials
		$(categories).hide();
		$(materials).hide();
		$(materials + ':Contains('+ input +')').show();
		// $(materials + ':Contains('+ input +')').trigger('expand'); Why does this do nothing?
		$(materials + ':Contains('+ input +')').closest('.collapsible').show();
		$(materials + ':Contains('+ input +')').closest('.collapsible').closest('.collapsible').show();
	});


	$('#manufacturing-search').keyup(function() {
		var input = $('#manufacturing-search').val();
		var categories = '#new-dropdown .collapsible .draggable';
		var materials = '#new-dropdown .collapsible .draggable';
	});
	
	$('#processes-search').keyup(function() {
		var input = $('#processes-search').val();
		var categories = '#processes-dropdown .draggable';
		var processes = '#processes-dropdown .draggable'; //what makes material draggable - Todo: attach to materials

		$(categories).hide();
		$(processes).hide();
		$(processes + ':Contains('+ input +')').show();
		$(processes + ':Contains('+ input +')').closest('.collapsible').show();
	});
	
	$('#transport-search').keyup(function() {
		var input = $('#transport-search').val();
		var categories = '#transport-dropdown .draggable';
		var transport = '#transport-dropdown .draggable'; //what makes material draggable - Todo: attach to materials
		$(categories).hide();
		$(transport).hide();
		$(transport + ':Contains('+ input +')').show();
		$(transport + ':Contains('+ input +')').closest('.collapsible').show();
	});
	
	$('#use-search').keyup(function() {
		var input = $('#use-search').val();
		var categories = '#use-dropdown .draggable';
		var use = '#use-dropdown .draggable'; //what makes material draggable - Todo: attach to materials
		$(categories).hide();
		$(use).hide();
		$(use + ':Contains('+ input +')').show();
		$(use + ':Contains('+ input +')').closest('.collapsible').show();
	});
	
	$('#eol-search').keyup(function() {
		var input = $('#eol-search').val();
		var categories = '#eol-dropdown .draggable';
		var eol = '#eol-dropdown .draggable'; //what makes material draggable - Todo: attach to materials
		$(categories).hide();
		$(eol).hide();
		$(eol + ':Contains('+ input +')').show();
		$(eol + ':Contains('+ input +')').closest('.collapsible').show();
	});
});
