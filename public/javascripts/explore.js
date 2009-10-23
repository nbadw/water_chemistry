var explore_map;
var site2marker = {};
var legacy_icon_image = "./images/iconr.png";
var normal_icon_image = "./images/iconb.png";

function init() {
    console.log('init');
    displayMap();
    maximizeMap();
    configureMarkers();
    Event.observe(window, 'resize', maximizeMap);
}

function displayMap() {
    if (GBrowserIsCompatible()) {
        Event.observe(window, 'unload', function(evt) { 
            GUnload(); 
        });    
        explore_map = new GMap2(document.getElementById("map_canvas"));
        explore_map.setMapType(G_HYBRID_MAP);
        explore_map.setCenter(new GLatLng(45.19194, -67.925025), 7);  
        explore_map.addControl(new GLargeMapControl());
        explore_map.addControl(new GOverviewMapControl());
        explore_map.enableDoubleClickZoom();
        explore_map.enableContinuousZoom();
        explore_map.enableScrollWheelZoom();
        new GKeyboardHandler(explore_map);  

        var normalSiteCount = 0;
        var legacySiteCount = 0;
        for(var i=0, len=site_markers.length; i < len; i++) {        
          var site = site_markers[i];
          if(site.legacy) {
              legacySiteCount++;
          } else {
              normalSiteCount++;
          }
        }
        explore_map.addControl(new ExploreLegendControl(explore_legend_data));
    }     
}

function maximizeMap() {
    var full_height = document.viewport.getDimensions().height;   
    var top_height = $('header').getHeight() + $('navigation').getHeight();
    var map_height = full_height - top_height - 40;      
    $('map_canvas').setStyle({
        height: map_height + 'px' 
    });
    explore_map.checkResize();
}

    
function configureMarkers() {        
    var bounds = new GLatLngBounds();
    for(var i=0, len=site_markers.length; i < len; i++) {        
        var site = site_markers[i];
        var coord = new GLatLng(site.latitude, site.longitude);
        var icon = new GIcon(G_DEFAULT_ICON);
        icon.image = site.legacy ? legacy_icon_image : normal_icon_image;      
        var marker = new GMarker(coord, { icon: icon });  
        var maxContentDiv = document.createElement('div'); 
                        
        maxContentDiv.innerHTML = loading_text;
        maxContentDiv.className = 'info-window';
        marker.id = site.id;          
        marker.maxContent = maxContentDiv;
        marker.bindInfoWindowHtml(site.info, {
            maxContent: marker.maxContent, 
            maxTitle: max_window_title
        });           
        GEvent.addListener(marker, 'click', handleMarkerClick);
        
        explore_map.addOverlay(marker);
        site2marker[site.id] = marker;
        bounds.extend(coord);
    }
    explore_map.setCenter(bounds.getCenter(), explore_map.getBoundsZoomLevel(bounds));
}
    
function handleMarkerClick(evt) {                
    var marker = this;
    var iw = explore_map.getInfoWindow();
    
    if(marker.maxContent.innerHTML == loading_text) {
        GEvent.addListener(iw, "maximizeclick", function() {
            GDownloadUrl("./data_collection_sites/gmap_max_content/" + marker.id, function(data) {
                marker.maxContent.innerHTML = data;
            });
        }); 
    } else {        
        GEvent.clearListeners(iw, "maximizeclick");
    }
}

Event.observe(window, 'load', init);


/*
 * CUSTOM MAP LEGEND
 */
// We define the function first
function ExploreLegendControl(explore_legend_data) {
    this.title = explore_legend_data.title;
    this.data_available = explore_legend_data.data_available
    this.legacy_data_available = explore_legend_data.legacy_data_available;
}

// To "subclass" the GControl, we set the prototype object to
// an instance of the GControl object
ExploreLegendControl.prototype = new GControl();

// Creates a one DIV for each of the buttons and places them in a container
// DIV which is returned as our control element. We add the control to
// to the map container and return the element for the map class to
// position properly.
ExploreLegendControl.prototype.initialize = function(map) {
  var container = document.createElement("div");  
  var legend = document.createElement("div");
  var normalIconDiv = document.createElement("div");
  var legacyIconDiv = document.createElement("div");
  
  legend.id = 'gmap-control-explore-legend';
  legend.innerHTML = '<h3>' + this.title + '</h3>';
  normalIconDiv.className = 'normal';
  normalIconDiv.innerHTML = '<img src="' + normal_icon_image + '" />' + 
      this.data_available.label + ' (' + this.data_available.count + ')';
  legend.appendChild(normalIconDiv);  
  legacyIconDiv.className = 'legacy';
  legacyIconDiv.innerHTML = '<img src="' + legacy_icon_image + '" />' +
      this.legacy_data_available.label + ' (' + this.legacy_data_available.count + ')';
  legend.appendChild(legacyIconDiv);
  
  container.appendChild(legend);

  map.getContainer().appendChild(container);
  return container;
}

// By default, the control will appear in the top left corner of the
// map with 7 pixels of padding.
ExploreLegendControl.prototype.getDefaultPosition = function() {
  return new GControlPosition(G_ANCHOR_TOP_RIGHT, new GSize(7, 7));
}