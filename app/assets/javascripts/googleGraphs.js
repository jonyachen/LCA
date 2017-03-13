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
            };
          });
        })
        .flatten()
        .value();
    return flattened;
}

var project = JSON.parse(gon.data);
var root = d3.hierarchy(project);
var manu_node = root.data[0];
var transport_node = root.data[1];
var use_node = root.data[2];
var disposal_node = root.data[3];

var manu_children_flat = flattenChildValues([manu_node]);
var transport_children_flat = flattenChildValues([transport_node]);
var use_children_flat = flattenChildValues([use_node]);
var disposal_children_flat = flattenChildValues([disposal_node]);


function drawChart(params){
// Load the Visualization API and the corechart package.
      google.charts.load('current', {'packages':['corechart']});

      // Set a callback to run when the Google Visualization API is loaded.
      google.charts.setOnLoadCallback(drawChart);

      // Callback that creates and populates a data table,
      // instantiates the pie chart, passes in the data and
      // draws it.
      function drawChart() {

        // Set chart parameters
        var chartType = params.type;
        var dataset = params.data;
        var divId = params.div;
        var threshold_lo = 0.1;
        var threshold_hi = 0.2; 
        var errorColor;
        var totalImpact = 0;

        // Calculate total impact for error bars
        for (i = 0; i < dataset.length; i++){
          console.log(dataset[i]);
          totalImpact += dataset[i].value;
        }
        // Create the data table.
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Item');
        
        if (chartType == "candle"){
          data.addColumn('number', 'Lower Whisker');
          data.addColumn('number', 'Lower Box');
          data.addColumn('number', 'Upper Box');
          data.addColumn('number', 'Upper Whisker');
        }

        if (chartType == "bar"){
          data.addColumn('number', 'Value');
          data.addColumn({id:'i0', type:'number', role:'interval'});
          data.addColumn({id:'i0', type:'number', role:'interval'});
        }

        data.addColumn({type:'string', role:'style'});
        
        var rows = []
        for (i = 0; i < dataset.length; i++){
          // Set percent error of total impact value
          dataset[i]["percent_error"] = 1.0 * (dataset[i]["uncertain_lower"] + dataset[i]["uncertain_upper"]) / totalImpact
           
          // Set colors for thresholds
          if (dataset[i].percent_error < threshold_lo){
            var error_color = "#eee8d2"
          } else if (dataset[i].percent_error > threshold_hi){
            var error_color = "#cc0000"
          } else {
            var error_color = "#ffab94"
          }
          var row = [];
          row.push(dataset[i].name);
          if (chartType == "candle"){ // Averaging error bounds with value for the box.
            row.push(dataset[i].value - dataset[i].uncertain_lower);
            row.push(( 2 * dataset[i].value - dataset[i].uncertain_lower ) / 2 );
            row.push(( 2 * dataset[i].value + dataset[i].uncertain_upper ) / 2 );
            row.push(dataset[i].value + dataset[i].uncertain_upper);
            row.push("bar{ color: " + error_color + "}");
          }

          if (chartType == "bar"){
            console.log(dataset[i].percent_error);
            row.push(dataset[i].value);
            row.push(dataset[i].value - dataset[i].uncertain_lower);
            row.push(dataset[i].value + dataset[i].uncertain_upper);
            row.push("bar{ color: " + error_color + "}");
          }
          
          
          rows.push(row);
        }
        data.addRows(rows);


        
        if (chartType == "bar"){
          // Instantiate and draw our chart, passing in some options.
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
        }
        if (chartType == "candle"){
          var chart = new google.visualization.CandlestickChart(document.getElementById(divId));
          var options = {
                      legend: 'none',
                      width:600,
                      strokeWidth: 5,
                      strokewidth: 5,
                      series: [{'color': '#998285', 'linewidth': 5}], //color of bars
                      height:300
                     };
        }
        chart.draw(data, options);
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

drawChart({
  data: manu_children_flat,
  type: "bar",
  div: "chart_manu_bar"
});

drawChart({
  data: manu_children_flat,
  type: "candle",
  div: "chart_manu_candle"
});

