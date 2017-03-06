/* global data, gon */
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
        var threshold_lo = 0.2;
        var threshold_hi = 0.5; 
        var errorColor;
        
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
        var colorSeries = []
        for (i = 0; i < dataset.length; i++){
          // Set colors for thresholds
          if (dataset[i].percent_error < threshold_lo){
            var error_color = "#F4E3B2"
          } else if (dataset[i].percent_error > threshold_hi){
            var error_color = "#CF5C36"
          } else {
            var error_color = "#EFC88B"
          }
          colorSeries.push("{color: " + errorColor + "}");
          var row = [];
          row.push(dataset[i].name);
          if (chartType == "candle"){ // Averaging error bounds with value for the box.
            row.push(dataset[i].value - dataset[i].uncertain_lower);
            row.push(( 2 * dataset[i].value - dataset[i].uncertain_lower ) / 2 );
            row.push(( 2 * dataset[i].value + dataset[i].uncertain_upper ) / 2 );
            row.push(dataset[i].value + dataset[i].uncertain_upper);
            row.push("bar{ color: light blue }");
          }

          if (chartType == "bar"){
            console.log(dataset[i].percent_error);
            row.push(dataset[i].value);
            row.push(dataset[i].value - dataset[i].uncertain_lower);
            row.push(dataset[i].value + dataset[i].uncertain_upper);
            console.log(error_color);
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
                        style: 'bar',
                        color: ['#ff3232', '#00ff00', '#00ff00', '#ff0000']
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
                      //series: [{'color': '#1A8763'}], //color of bars
                      height:300,
                      candlestick: {
                        fallingColor: { strokeWidth: 0, fill: '#a52714' }, // red
                        risingColor: { strokeWidth: 2, fill: '#0f9d58' }   // green
                      }
                     };
        }
        chart.draw(data, options);
      }
}




drawChart({
  data: JSON.parse(gon.data),
  type: "candle",
  div: "chart_div"
});

drawChart({
  data: JSON.parse(gon.data),
  type: "bar",
  div: "chart_div2"
});

