var explore_map;
var site2marker = {};
var site_markers = [];

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
        ////new GMapCacheAdapter(
        //    "/map_cache/aquatic sites/conf.xml", 
        //    map, { 
        //        name: "Sites" 
        //    }  
    }     
}

function maximizeMap() {
    var full_height = document.viewport.getDimensions().height;   
    var top_height = $('explore-top').getHeight();      
    var map_height = full_height - top_height - 50;
      
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
        var marker = new GMarker(coord);  
        var maxContentDiv = document.createElement('div');                
        
        maxContentDiv.innerHTML = 'Loading...';
        maxContentDiv.className = 'info-window';
        marker.id = site.id;          
        marker.maxContent = maxContentDiv;
        marker.bindInfoWindowHtml(site.info, {
            maxContent: marker.maxContent, 
            maxTitle: "Aquatic Site Details"
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
    
    if(marker.maxContent.innerHTML == 'Loading...') {
        GEvent.addListener(iw, "maximizeclick", function() {
            GDownloadUrl("/data_collection_sites/gmap_max_content/" + marker.id, function(data) {
                marker.maxContent.innerHTML = data;
            });
        }); 
    } else {        
        GEvent.clearListeners(iw, "maximizeclick");
    }
}

Event.observe(window, 'load', init);


//
//
//var map = null;
//var site2marker = {};
//    
//function updateMap(siteMarkers) {
//    map.clearOverlays();
//        
//    var bounds = new GLatLngBounds();
//    for(var i=0, len=siteMarkers.length; i < len; i++) {
//        var site = siteMarkers[i];
//        var coord = new GLatLng(site.latitude, site.longitude);
//        var marker = new GMarker(coord);  
//        var maxContentDiv = document.createElement('div');                
//        
//        maxContentDiv.innerHTML = 'Loading...';
//        maxContentDiv.className = 'info-window';
//        marker.id = site.id;          
//        marker.maxContent = maxContentDiv;
//        marker.bindInfoWindowHtml(site.info, {
//            maxContent: marker.maxContent, 
//            maxTitle: "Aquatic Site Details"
//        });           
//        GEvent.addListener(marker, 'click', handleMarkerClick);
//        
//        map.addOverlay(marker);
//        site2marker[site.id] = marker;
//        bounds.extend(coord);
//    }
//    map.setCenter(bounds.getCenter(), map.getBoundsZoomLevel(bounds));
//}
//    
//function handleMarkerClick(evt) {                
//    var marker = this;
//    $('aquatic-sites').select('li.aquatic-site').each(function(li) { 
//        li.removeClassName('selected') 
//    });            
//    Element.up('aquatic-site-' + marker.id, 'li.aquatic-site').addClassName('selected');
//
//    var iw = map.getInfoWindow();
//    
//    if(marker.maxContent.innerHTML == 'Loading...') {
//        GEvent.addListener(iw, "maximizeclick", function() {
//            GDownloadUrl("/aquatic_site/gmap_max_content/" + marker.id, function(data) {
//                marker.maxContent.innerHTML = data;
//            });
//        }); 
//    } else {        
//        GEvent.clearListeners(iw, "maximizeclick");
//    }
//}
//    
//function handleAquaticSiteClick(evt) {
//    Event.stop(evt);
//    $('aquatic-sites').select('li.aquatic-site').each(function(li) { li.removeClassName('selected') });
//    Element.up(this, 'li.aquatic-site').addClassName('selected');
//    var site_id = parseInt(this.id.sub('aquatic-site-', ''));
//    if(site2marker[site_id]) {
//        GEvent.trigger(site2marker[site_id], 'click');
//    }
//}