// for those w/o console... sad.
if (typeof(console) == 'undefined') {
  console = {
    log: function() {}
  }
}

function closeOpenNestedViews(record_id) {
  var open_nested_views = $$('div.open-nested-view');
  var elm_id = 'open-nested-view-' + record_id;
  open_nested_views.each(function(open_nested_view) {
    // close any other open views
    //console.log('inspecting ' + open_nested_view.id);
    if(open_nested_view.id != elm_id) {
      inline_table_row = open_nested_view.up('tr.inline-adapter');
      //console.log('re-enabling action links');
      inline_table_row.previous('tr.record').select('a.action.disabled').each(function(disabled_action) {
        //console.log('enabling ' + disabled_action.id);
        disabled_action.removeClassName('disabled');
      });
      //console.log('closing view');
      inline_table_row.remove();
    }
  });
}

function showLocationOnMap(options, event) {
  toggleTooltip(event, $('coordinate-preview-dialog'));
  if(!$('coordinate-preview-dialog').visible()) {
    return;
  }
    
  // remove previous iframe
  $('coordinate-preview-result').innerHTML = '';
    
  var loading_img = $(options['loadingImage']);
  var form = $(options['form']);
  var url = options['url'];
  //var error_msg = "Sorry, an error occurred.  Please try again later.";
  var params = [];
  for(var i=0; i < options['fields'].length; i++) {
    var field_name = options['fields'][i];
    params.push( form[field_name] );
  }
  var query = Form.serializeElements(params);
  var request = url + '?' + query;
    
  var iframe = document.createElement('iframe');
  iframe.src = request;
  Element.extend(iframe);
    
  // active the request
  $('coordinate-preview-result').appendChild(iframe);
}

var delay = 500;
var executionTimer;
var preview_map;
function update_preview_marker() {
  var system = $('record_coordinate_system').value;
  var x = $('record_x_coordinate').value;
  var y = $('record_y_coordinate').value;
  if(x === '' || y === '' || system === '') {
    if (executionTimer) {
        clearTimeout(executionTimer);
      }
      show_preview_message('A site marker will appear when a valid coordinate pair is entered.');
    return;
  }

  var worker = function() {
    return function() {
      if (executionTimer) {
        clearTimeout(executionTimer);
      }
      executionTimer = setTimeout(function() {
        var url = './data_collection_sites/on_preview_location';
        new Ajax.Request(url, {
          parameters: {
            x: $('record_x_coordinate').value,
            y: $('record_y_coordinate').value,
            epsg: $('record_coordinate_system').value
          },
          onCreate: function() {
            var loading_msg = '<img src="./images/active_scaffold/default/indicator.gif"/>Loading preview...';
            show_preview_message(loading_msg);
          },
          onFailure: function() {
            show_preview_message('An unexpected error occurred!');
          },
          onException: function() {
            show_preview_message('An unexpected error occurred!');
          }
        });
      }, delay);
    };
  }();  
  worker.call();
}

function show_preview_marker(x, y) {
  if($("preview-map") && preview_map) {
    $('record_gmap_x').value = x;
    $('record_gmap_y').value = y;

    preview_map.clearOverlays();
    var latlng = new GLatLng(y, x);
    preview_map.addOverlay(new GMarker(latlng));
    preview_map.panTo(latlng);
    $("preview-msg").hide();
  }
}

function show_preview_message(message) {
  if($("preview-map") && preview_map) {
    preview_map.clearOverlays();
    $("preview-msg-body").innerHTML = message;
    $("preview-msg").show();
  }
}

function create_preview_map() {
  if (GBrowserIsCompatible()) {
    preview_map = new GMap2($("preview-map"));
    preview_map.setCenter(new GLatLng(46.505954,-66.335449),6);
    preview_map.setMapType(G_HYBRID_MAP);
    preview_map.addControl(new GSmallZoomControl());
  }
}

function doToggleAreaOfInterest(url, update, error, loader) {
  new Ajax.Updater(update, url, {
    asynchronous: true,
    evalScripts: true,
    method: 'post',
    onComplete: function(request) {
      $(loader).style.visibility = 'hidden';
    },
    onFailure: function(request) {
      ActiveScaffold.report_500_response(error);
    }
  });
  $(loader).style.visibility = 'visible';
  return false;
}

function initDescriptions() {
  $$('.tooltip-box').each(function(tooltip_box) {
    var prev = tooltip_box.previous('input');
    if(!prev) {
      prev = tooltip_box.previous('select');
    }
    if(prev) {
      prev.observe('mouseover', function(evt) {
        this.next('.tooltip-box').show();
      });
      prev.observe('mouseout', function(evt) {
        this.next('.tooltip-box').hide();
      });
    }
  });
}

Ajax.Responders.register({
  onComplete: function() {
    initDescriptions();
  }
});

document.observe("dom:loaded", function() {
  initDescriptions();
});

