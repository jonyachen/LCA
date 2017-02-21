/* global Plotly */

var data = [
    {
       "name": "manufacturing",
       "value": 20,
       "uncertain_lower": 5,
       "uncertain_upper": 2,
       "children": [
            {
              "name": "steel production, electric, chromium steel 18/8", "value": 15, "uncertain_lower": 4, "uncertain_upper": 7,
              "children": [
                    {"name": "sheet rolling, steel", "value": 10, "uncertain_lower": 4, "uncertain_upper": 7}
            ]
            },{"name": "iron-nickel-chromium alloy production", "value": 5, "uncertain_lower": 4, "uncertain_upper": 7},
       ]
    },{
       "name": "transport",
       "value": 30,
       "uncertain_lower": 5,
       "uncertain_upper": 2,
       "children": [
            {"name": "transport, freight, sea, transoceanic ship", "value": 30, "uncertain_lower": 4, "uncertain_upper": 7},
            {"name": "transport, freight train", "value": 20, "uncertain_lower": 4, "uncertain_upper": 7},
            {"name": "transport, freight, lorry, all sizes, EURO5 to generic market for transport, freight, lorry, unspecified", "value": 10, "uncertain_lower": 4, "uncertain_upper": 7},
       ]
    },{
        "name": "use",
        "value": 100,
       "uncertain_lower": 50,
       "uncertain_upper": 20,
        "children": [
            {"name": "electricity production, oil", "value": 20, "uncertain_lower": 4, "uncertain_upper": 7},
        ]
    },{
        "name": "end of life",
        "value": 80,
       "uncertain_lower": 5,
       "uncertain_upper": 2,
        "children": [
            {"name": "treatment of municipal solid waste, sanitary landfill", "value": 10, "uncertain_lower": 4, "uncertain_upper": 7},
        ]
    }   
]

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

var project = flattenChildValues(data);

root = d3.hierarchy(data);
manu_node = root.data[0];
transport_node = root.data[1];
use_node = root.data[2];
disposal_node = root.data[3];

manu_children_flat = flattenChildValues([manu_node]);
transport_children_flat = flattenChildValues([transport_node]);
use_children_flat = flattenChildValues([use_node]);
disposal_children_flat = flattenChildValues([disposal_node]);


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

renderChart({
  data: data,
  error: true
});
