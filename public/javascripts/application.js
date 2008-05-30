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
    site2marker = {};
        
    var bounds = new GLatLngBounds();
    for(var i=0, len=siteMarkers.length; i < len; i++) {
        var site = siteMarkers[i];
        var coord = new GLatLng(site.latitude, site.longitude);
        var marker = new GMarker(coord);
        var maxContentDiv = document.createElement('div');
        maxContentDiv.innerHTML = 'Loading...'
        marker.bindInfoWindowHtml(site.info, {
            maxContent: maxContentDiv, 
            maxTitle: "More Info"
        });
        GEvent.addListener(marker, 'click', handleMarkerClick);
        map.addOverlay(marker);
        site2marker[site.id] = marker;
        bounds.extend(coord);
    }
    map.setCenter(bounds.getCenter(), map.getBoundsZoomLevel(bounds));
}
    
function handleMarkerClick(evt) {
    for(var site_id in site2marker) {
        if(this == site2marker[site_id]) {  
            $('aquatic-sites').select('li.aquatic-site').each(function(li) { li.removeClassName('selected') });
            Element.up('aquatic-site-' + site_id, 'li.aquatic-site').addClassName('selected');
        }                
    }       

    var iw = map.getInfoWindow();
    GEvent.addListener(iw, "maximizeclick", function() {
        GDownloadUrl("ajax_content.html", function(data) {
            maxContentDiv.innerHTML = data;
        });
    });
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