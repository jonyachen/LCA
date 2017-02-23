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
          var row = [];
          row.push(dataset[i].name);
          if (chartType == "candle"){ // Averaging error bounds with value for the box.
            row.push(dataset[i].value - dataset[i].uncertain_lower);
            row.push(( 2 * dataset[i].value - dataset[i].uncertain_lower ) / 2 );
            row.push(( 2 * dataset[i].value + dataset[i].uncertain_upper ) / 2 );
            row.push(dataset[i].value + dataset[i].uncertain_upper);
          }

          if (chartType == "bar"){
            row.push(dataset[i].value);
            row.push(dataset[i].value - dataset[i].uncertain_lower);
            row.push(dataset[i].value + dataset[i].uncertain_upper);
          }
          
          row.push("bar{ color: light blue}");
          rows.push(row);
        }
        data.addRows(rows);

        // Set chart options
        var options = {
                      width:600,
                      height:300,
                      //intervals: { style: 'bars' },
                      legend: 'none',
                     
                     };

        if (chartType == "bar"){
          // Instantiate and draw our chart, passing in some options.
          var chart = new google.visualization.ColumnChart(document.getElementById(divId));
          chart.draw(data, options);
        }
        if (chartType == "candle"){
          var chart = new google.visualization.CandlestickChart(document.getElementById(divId));
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

