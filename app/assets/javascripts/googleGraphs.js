/* global _, data, gon, d3 */
var project = flattenChildValues(JSON.parse(gon.data));
var projectTitle = JSON.parse(gon.data)[0].name;
var chartHeight = 340;
var chartWidth = 800;
var currViewBar = [{name: projectTitle, data: project}];
var currViewCandle = [{name: projectTitle, data: project}];

function flattenChildValues(data){
  // Accepts data array containing objects.
  // Flattens by remapping children name and value to same tier as parent category and uncertainty.
    var flattened = _.chain(data)
          .map(function(parent, index){
          return _.map(parent.children, function(children){
            return {
              'category' : children.category,
              'uncertain_lower': children.uncertain_lower,
              'uncertain_upper': children.uncertain_upper,
              'name' : children.name,
              'value' : children.value,
              'children': children.children
            };
          });
        })
        .flatten()
        .value();
    return flattened;
}

function drawChart(params){
  // Set chart parameters
  var chartType = params.type;
  var threshold_lo = 0.1;
  var threshold_hi = 0.2; 
  var errorColor;
  var totalImpact = 0;
  
  // Load the Visualization API and the corechart package.
  google.charts.load('current', {'packages':['corechart']});

  // Set a callback to run when the Google Visualization API is loaded.
  if (chartType == "bar"){
    google.charts.setOnLoadCallback(function() { drawBar(params) });
  } else if (chartType == "candle") {
    google.charts.setOnLoadCallback(function() { drawCandle(params) });
  }

  // Callbacks that creates and populates a data table,
  // instantiates the charts, passes in the data and
  // draws it.
  function drawBar(params) {
    var dataset = params.data;
    var divId = params.div;
    var title = params.title;
    totalImpact = 0;
    // Calculate total impact for error bars
    for (i = 0; i < dataset.length; i++){
      totalImpact += dataset[i].value;
    }
    // Create the data table.
    var data = new google.visualization.DataTable();
    data.addColumn('string', 'Item');
    data.addColumn('number', 'Value');
    data.addColumn({id:'i0', type:'number', role:'interval'});
    data.addColumn({id:'i0', type:'number', role:'interval'});
    data.addColumn({type:'string', role:'style'});
    
    var rows = []
    for (i = 0; i < dataset.length; i++){
      // Set percent error of total impact value
      dataset[i]["percent_error"] = 1.0 * (dataset[i]["uncertain_lower"] + dataset[i]["uncertain_upper"]) / totalImpact
      
      // Set colors for thresholds
      if (dataset[i].category == "Material"){
        var bar_color = "#7099C5"
      } else if (dataset[i].category == "Process"){
        var bar_color = "#BBD9D9"
      } else if (dataset[i].category == "Transport"){
        var bar_color = "#FAC6B0"
      } else if (dataset[i].category == "Use"){
        var bar_color = "#EEE52B"
      } else if (dataset[i].category == "End of Life"){
        var bar_color = "#784022"
      }
      
      var row = [];
      row.push(dataset[i].name);
      row.push(dataset[i].value);
      row.push(dataset[i].value - dataset[i].uncertain_lower);
      row.push(dataset[i].value + dataset[i].uncertain_upper);
      row.push("bar{ color: " + bar_color + "}");
      rows.push(row);
    }
    data.addRows(rows);
    
    // Chart instantiation and draw
    var chart = new google.visualization.ColumnChart(document.getElementById(divId));
    var options = {
                    title: title,
                    titleTextStyle: {
                      color: 'black',    
                      fontName: 'Roboto', 
                      fontSize: 14, 
                      //bold: false,
                    },
                    vAxis: {
                      title: 'ReCiPe Endpoint H Score'
                    },
                    legend: 'none',
                    width: chartWidth,
                    intervals: {
                      barWidth: 0.7,
                      lineWidth: 2,
                      color: '#998285',
                    },
                    height: chartHeight,
                    linewidth: 10,
                  };
    chart.draw(data, options);
    google.visualization.events.addListener(chart, 'select', selectHandler);
    
    // Redraws chart with selected column if it has children
    function selectHandler() {
      var selection = chart.getSelection();
      if (selection.length != 0){
        selection = dataset[chart.getSelection()[0].row];
      }
      if (selection.children != null){
        var child_tier = flattenChildValues([selection]);
        var selection_name = selection.name.replace(/\b\w/g, l => l.toUpperCase());
        title = selection_name + " breakdown";
        drawBar({data: child_tier, div: divId, title: title});
        currViewBar.push({name: selection_name, data: child_tier});
      }
    }
  }
  
  function drawCandle(params){
    var dataset = params.data;
    var divId = params.div;
    var title = params.title;
    // Calculate total impact for error bars
    totalImpact = 0;
    for (i = 0; i < dataset.length; i++){
      totalImpact += dataset[i].value;
    }
    // Create the data table.
    var data = new google.visualization.DataTable();
    data.addColumn('string', 'Item');
    data.addColumn('number', 'Lower Whisker');
    data.addColumn('number', 'Lower Box');
    data.addColumn('number', 'Upper Box');
    data.addColumn('number', 'Upper Whisker');
    data.addColumn({type:'string', role:'style'});
    
    var rows = []
    for (i = 0; i < dataset.length; i++){
      // Set percent error of total impact value
      dataset[i]["percent_error"] = 1.0 * (dataset[i]["uncertain_lower"] + dataset[i]["uncertain_upper"]) / totalImpact
           
      // Set colors for thresholds
      if (dataset[i].percent_error < threshold_lo){
        var error_color = "#e1bea8"
      } else if (dataset[i].percent_error > threshold_hi){
        var error_color = "#ff3d3d"
      } else {
        var error_color = "#ff8080"
      }
      
      var row = [];
      row.push(dataset[i].name);
      // Averaging error bounds with value for the box.
      row.push(dataset[i].value - dataset[i].uncertain_lower);
      row.push(( 2 * dataset[i].value - dataset[i].uncertain_lower ) / 2 );
      row.push(( 2 * dataset[i].value + dataset[i].uncertain_upper ) / 2 );
      row.push(dataset[i].value + dataset[i].uncertain_upper);
      row.push("bar{ color: " + error_color + "}");
      rows.push(row);
      
    }
    data.addRows(rows);
    
    // Chart instantiation and draw
    var chart = new google.visualization.CandlestickChart(document.getElementById(divId));
    var options = {
                    title: title,
                    titleTextStyle: {
                        color: 'black',    
                        fontName: 'Roboto', 
                        fontSize: 14, 
                        //bold: false,
                    },
                    vAxis: {
                      title: 'ReCiPe Endpoint H Score',
                    },
                    legend: 'none',
                    width: chartWidth,
                    strokeWidth: 5,
                    strokewidth: 5,
                    series: [{'color': '#998285', 'linewidth': 5}], //color of bars
                    height: chartHeight
                  };
    chart.draw(data, options);  
    google.visualization.events.addListener(chart, 'select', selectHandler);
    
    // Redraws chart with selected column if it has children
    function selectHandler() {
      var selection = chart.getSelection();
      if (selection.length != 0){
        selection = dataset[chart.getSelection()[0].row];
      }
      if (selection.children != null){
        var child_tier = flattenChildValues([selection]);
        var selection_name = selection.name.replace(/\b\w/g, l => l.toUpperCase());
        title = selection_name + " breakdown";
        drawCandle({data: child_tier, div: divId, title: title});
        currViewCandle.push({name: selection_name, data: child_tier});
      }
    
    }
  }
  drawChart.drawBar = drawBar;
  drawChart.drawCandle = drawCandle;
}

drawChart({
  data: project,
  title: projectTitle +  " breakdown",
  type: "bar",
  div: "chart_project_bar"
});

drawChart({
  data: project,
  title: projectTitle + " breakdown",
  type: "candle",
  div: "chart_project_candle"
});


$(document).ready( function() {
  $('#rewind-bar').click(function () {
    if (currViewBar.length != 1) {
      currViewBar.pop();
      var data = currViewBar[currViewBar.length - 1].data;
      var title = currViewBar[currViewBar.length - 1].name + " breakdown";
      drawChart.drawBar({data: data, div: "chart_project_bar", title: title});
    }
	});
	
	$('#rewind-candle').click(function () {
	  if (currViewCandle.length != 1) {
      currViewCandle.pop();
      var data = currViewCandle[currViewCandle.length - 1].data;
      var title = currViewBar[currViewBar.length - 1].name + " breakdown";
      drawChart.drawCandle({data: data, div: "chart_project_candle", title: title});
    }
	});
	
	$('#reset-bar').click(function () {
	  currViewBar = [{name: projectTitle, data: project}];
	  var title = currViewBar[0].name + " breakdown";
    drawChart.drawBar({data: project, div: "chart_project_bar", title: title});
	});
	
	$('#reset-candle').click(function () {
	  currViewCandle = [{name: projectTitle, data: project}];
	  var title = currViewBar[0].name + " breakdown";
    drawChart.drawCandle({data: project, div: "chart_project_candle", title: title});
	});
});