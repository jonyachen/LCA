/* global _, data, gon, d3 */

var flattenChildValues = function(data){
  // Accepts data array containing objects.
  // Flattens by remapping children name and value to same tier as parent category and uncertainty.
    var flattened = _.chain(data)
          .map(function(parent, index){
          return _.map(parent.children, function(children){
            return {
              'category' : parent.name,
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

var project = JSON.parse(gon.data);

function drawChart(params){
  // Set chart parameters
  var chartType = params.type;
  var prev_dataset = params.data;
  var divId = params.div;
  var threshold_lo = 0.1;
  var threshold_hi = 0.2; 
  var errorColor;
  var totalImpact = 0;
      
  // Load the Visualization API and the corechart package.
  google.charts.load('current', {'packages':['corechart']});

  // Set a callback to run when the Google Visualization API is loaded.
  if (chartType == "bar"){
    google.charts.setOnLoadCallback(function() { drawBar(params.data) });
  } else if (chartType == "candle") {
    google.charts.setOnLoadCallback(function() { drawCandle(params.data) });
  }

  // Callbacks that creates and populates a data table,
  // instantiates the charts, passes in the data and
  // draws it.
  function drawBar(dataset) {
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
      if (dataset[i].percent_error < threshold_lo){
        var error_color = "#e1bea8"
      } else if (dataset[i].percent_error > threshold_hi){
        var error_color = "#ff3d3d"
      } else {
        var error_color = "#ff8080"
      }
      
      var row = [];
      row.push(dataset[i].name);
      row.push(dataset[i].value);
      row.push(dataset[i].value - dataset[i].uncertain_lower);
      row.push(dataset[i].value + dataset[i].uncertain_upper);
      row.push("bar{ color: " + error_color + "}");
      rows.push(row);
    }
    data.addRows(rows);
    
    // Chart instantiation and draw
    var chart = new google.visualization.ColumnChart(document.getElementById(divId));
    var options = {
                    legend: 'none',
                    width:600,
                    intervals: {
                      barWidth: 0.7,
                      lineWidth: 2,
                      color: '#998285',
                    },
                    height:300,
                    linewidth: 10,
                  };
    chart.draw(data, options);
    google.visualization.events.addListener(chart, 'select', selectHandler);
    
    // Redraws chart with selected column if it has children
    function selectHandler() {
      var selection = chart.getSelection()
      if (selection.length != 0){
        selection = dataset[chart.getSelection()[0].row];
      }
      if (selection.children != null){
        var child_tier = flattenChildValues([selection]);
        drawBar(child_tier);
      }
    }
    
  this.prototype.onclick = function(rowIndex) {
      alert("hello")
      // Trigger a select event.
      //google.visualization.events.trigger(this, 'select', null);
    }
  }
  
  function drawCandle(dataset){
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
                    legend: 'none',
                    width:600,
                    strokeWidth: 5,
                    strokewidth: 5,
                    series: [{'color': '#998285', 'linewidth': 5}], //color of bars
                    height:300
                  };
    chart.draw(data, options);  
    google.visualization.events.addListener(chart, 'select', selectHandler);
    
    // Redraws chart with selected column if it has children
    function selectHandler() {
      var selection = chart.getSelection()
      if (selection.length != 0){
        selection = dataset[chart.getSelection()[0].row];
      }
      if (selection.children != null){
        var child_tier = flattenChildValues([selection]);
        prev_dataset = dataset;
        dataset = child_tier;
        drawCandle(dataset);
      }
      else {
        //drawCandle(prev_dataset);
      }
    }
  }
  
}

drawChart({
  data: project,
  type: "bar",
  div: "chart_project_bar"
});

drawChart({
  data: project,
  type: "candle",
  div: "chart_project_candle"
});
