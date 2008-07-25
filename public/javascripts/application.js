function include_javascript(src) {
    if (document.createElement && document.getElementsByTagName) {
        var head = document.getElementsByTagName('head')[0];
        var script = document.createElement('script');
        script.setAttribute('type', 'text/javascript');
        script.setAttribute('src', src);
        head.appendChild(script);
    }
}

function include_gmap_scripts(gmap_header) {
    console.log(gmap_header);
}

var map = null;
var site2marker = {};
        
function enhanceAquaticSites() {
    $('aquatic-sites').select('li.aquatic-site').each(function(li) {
        Event.observe(li, 'mouseover', function(evt) {
            this.addClassName('over');
        });
        Event.observe(li, 'mouseout', function(evt) {
            this.removeClassName('over');
        });
    });
        
    $('aquatic-sites').select('li.aquatic-site a').each(function(link) {
        Event.observe(link, 'click', handleAquaticSiteClick);
    });
        
    $('aquatic-sites').select('div.pagination a').each(function(link) {
        Event.observe(link, 'click', function(evt) {
            Event.stop(evt); // prevent the default action
            var url    = this.href.split('?')[0]
            var params = this.href.toQueryParams();
            params['format'] = 'js'
                
            new Ajax.Request(url, { 
                method: 'get',
                parameters: params,
                onComplete: function(response) {
                    enhanceAquaticSites();
                }
            });
        });    
    });
}
    
function updateMap(siteMarkers) {
    map.clearOverlays();
        
    var bounds = new GLatLngBounds();
    for(var i=0, len=siteMarkers.length; i < len; i++) {
        var site = siteMarkers[i];
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
        
        map.addOverlay(marker);
        site2marker[site.id] = marker;
        bounds.extend(coord);
    }
    map.setCenter(bounds.getCenter(), map.getBoundsZoomLevel(bounds));
}
    
function handleMarkerClick(evt) {                
    var marker = this;
    $('aquatic-sites').select('li.aquatic-site').each(function(li) { 
        li.removeClassName('selected') 
    });            
    Element.up('aquatic-site-' + marker.id, 'li.aquatic-site').addClassName('selected');

    var iw = map.getInfoWindow();
    
    if(marker.maxContent.innerHTML == 'Loading...') {
        GEvent.addListener(iw, "maximizeclick", function() {
            GDownloadUrl("/aquatic_site/gmap_max_content/" + marker.id, function(data) {
                marker.maxContent.innerHTML = data;
            });
        }); 
    } else {        
        GEvent.clearListeners(iw, "maximizeclick");
    }
}
    
function handleAquaticSiteClick(evt) {
    Event.stop(evt);
    $('aquatic-sites').select('li.aquatic-site').each(function(li) { li.removeClassName('selected') });
    Element.up(this, 'li.aquatic-site').addClassName('selected');
    var site_id = parseInt(this.id.sub('aquatic-site-', ''));
    if(site2marker[site_id]) {
        GEvent.trigger(site2marker[site_id], 'click');
    }
}