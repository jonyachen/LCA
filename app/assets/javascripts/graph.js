/* global Plotly, gon */

var flattenChildValues = function(data){
  // Accepts data array containing objects.
  // Flattens by remapping children name and value to same tier as parent category and uncertainty.
    var flattened = _.chain(data)
          .map(function(parent, index){
          return _.map(parent.children, function(children){
            return {
              'category' : parent.name,
              'uncertainty': parent.uncertainty,
              'name' : children.name,
              'value' : children.value,
            };
          });
        })
        .flatten()
        .value();
    return flattened;
}

function renderChart(options){
  options.error = options.error || null;
  var xLabels = _.pluck(options.data, 'name');
  var yValues = _.pluck(options.data, 'value');
  if (options.error){
    var errorUpper = _.pluck(options.data, 'uncertain_upper');
    var errorLower = _.pluck(options.data, 'uncertain_lower');
    options.error = {
      type: 'data',
      symmetric: false,
      array: errorUpper,
      arrayminus: errorLower,
      visible: true
    };
  };

  var trace1 = {
    x: xLabels,
    y: yValues,
    marker:{
      color: ['rgba(0,0,255,0.6)', 'rgba(0,0,255,0.6)', 'rgba(0,0,255,0.6)', 'rgba(0,0,255,0.6)', 'rgba(0,0,255,0.6)']
    },
    error_y: options.error,
    type: 'bar'
  };
 
  var data = [trace1];
  Plotly.newPlot('myDiv', data);
}


/*
renderChart({
  data: JSON.parse(gon.data),
  error: true
});
*/