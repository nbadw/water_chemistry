AquaticSitesPanel = function(config) {      
    // TODO: write code to configure the following:
    //   - tabbedInfoWindowProvider
    //   - etc.
    
    this.store = config.store || new Ext.data.Store({ 
        data: config.data || {
            'results': 0,
            'sites': []              
        }, 
        reader: new Ext.data.JsonReader({
            totalProperty: 'results',
            root: 'sites',
            id: 'id',
            fields: ['id', 'name', 'lat', 'lng']
        }) 
    });
    Ext.apply(this, config);
    
    console.debug('creating site filtering textbox');
    this.filter = new Ext.form.TextField({
        emptyText: 'type to filter sites',
        cls: 'filter'
    }); 
       
    console.debug('creating list view component');
    this.list = new Ext.DataView({
        store: this.store,
        overClass: 'x-site-view-over',
        itemSelector: 'div.site-item',
        emptyText: 'No sites to display',
        singleSelect: true,
        tpl: new Ext.XTemplate(
            '<tpl for=".">', 
            '<div class="site-item">',
            '<h3>{name}</h3>',
            '<p>{short_description}</p>',
            '</div>',
            '</tpl>'
        ),
        prepareData: function(data) {
            data.name = data.name || 'Unnamed Site';
            var description = data.description || 'No Description';
            data.short_description = description.length >= 100 ?
                description.substring(0, 97) + '...' :
                description;                
            return data;
        }
    });    
    
    console.debug('creating aquatic site list panel');
    var aquatic_site_list_panel = new Ext.Panel({        
        store: this.store,
        title: 'Aquatic Sites',
        region: 'east',
        split: true,
        minWidth: 215,
        width: 215,
        autoScroll: true,
        collapsible: true,
        items: [this.filter, this.list],
        tbar: [{
            text: 'Add',
            handler: this.addSite,
            scope: this
        }, {
            text: 'Delete',
            handler: function() { console.log('delete site clicked'); },
            scope: this
        }, {
            text: 'Edit',
            handler: this.editSite,
            scope: this
        }],
        bbar: new Ext.PagingToolbar({ 
            store: this.store
        })
    });
    
    this.map_panel = new AquaticSitesMap({ store: this.store });
    
    console.info('creating aquatic sites panel');
    AquaticSitesPanel.superclass.constructor.call(this, {
        layout: 'border',
        items: [
            aquatic_site_list_panel,
            this.map_panel
        ]
    });
};
Ext.extend(AquaticSitesPanel, Ext.Panel, {
    initComponent: function() {
        console.log('init component ' + this);
        AquaticSitesPanel.superclass.initComponent.call(this);
        this.filter.on('specialkey', function(field, evt) {
            if(evt.getCharCode() == Ext.EventObject.ENTER) {
                this.store.setFilter(field.getValue());
            }
        }, this);  
    },
    
    addSite: function() {
        console.log('add new site clicked');
        var map = this.map_panel.map;
        if(!this.editWindow) {
            this.editWindow = new Ext.Window({ 
                title: 'New Site',
                layout: 'fit',
                html: 'add new site',
                modal: true,
                closeAction: 'hide',
                width: 400,
                buttons: [{
                    text: 'Create',
                    disabled: true
                }, {
                    text: 'Cancel',
                    handler: function() {
                        this.editWindow.hide();
                    },
                    scope: this
                }]
            });
        }
        this.editWindow.show();
        this.editWindow.body.load({
            url: '/aquatic_sites/new.js?_method=get&adapter=_list_inline_adapter',
            text: 'Loading...'
        });
    },
    
    editSite: function() {
        console.log('edit site clicked');
        var map = this.map_panel.map;
        if(!this.editWindow) {
            this.editWindow = new Ext.Window({ 
                title: 'New Site',
                layout: 'fit',
                html: 'add new site',
                modal: true,
                closeAction: 'hide',
                width: 400,
                buttons: [{
                    text: 'Create',
                    disabled: true
                }, {
                    text: 'Cancel',
                    handler: function() {
                        this.editWindow.hide();
                    },
                    scope: this
                }]
            });
        }
        this.editWindow.show();
        this.editWindow.body.load({
            url: '/aquatic_sites/new?_method=get&adapter=_list_inline_adapter',
            text: 'Loading...'
        });
    }
});

AquaticSitesMap = function(config) {    
    console.info('new aquatic sites map');
        
    this.store = config.store;
    this.map = null;
    this.overlays = {};
    this.infoTpl = new Ext.XTemplate(
        '<tpl for=".">', 
        '<div class="site-item">',
        '<h3>{name}</h3>',
        '<p>ID: {id}</p>',
        '<ul><li>Latitude: {lat}</li><li>Longitude: {lng}</li></ul>',
        '<p>{full_description}</p>',
        '</div>',
        '</tpl>'
    );
    
    AquaticSitesMap.superclass.constructor.call(this, {
        region: 'center'
    });
    
    this.store.on('datachanged', function(store) {
        console.debug('datastore changed, refreshing map');
        this.updateMap();
    }, this);
    
    this.on('resize', function(comp) { 
        console.debug('panel being resized');
        this.map.checkResize(); 
        this.updateMap();
    }, this);
    
    if(GBrowserIsCompatible()) {  
        this.on('render', function(comp) {            
            this.map = new GMap2(comp.body.dom);
            var map = this.map;
            new GKeyboardHandler(map);
            map.addControl(new GLargeMapControl());
            map.addControl(new GScaleControl());
            map.addControl(new GOverviewMapControl());
            map.addControl(new GMapTypeControl());
            map.enableDoubleClickZoom();
            map.enableContinuousZoom();
            map.enableScrollWheelZoom();
            map.setCenter(new GLatLng(45.19194, -67.925025), 10);
            map.checkResize();            
            
            //var bounds = <%= create_bounds(@extent) %>;
            //var center = bounds.getCenter();
            //this.map.setCenter(center);        
            //console.debug("centering map to " + center.lat() + ", " + center.lng());
            //this.map.setZoom(this.map.getBoundsZoomLevel(bounds));
            //console.debug("zooming to level " + this.map.getBoundsZoomLevel(bounds));
            
            //console.info("loading map cache adapter");
            //new GMapCacheAdapter(
            //    "/map_cache/aquatic sites/conf.xml", 
            //    map, { 
            //        name: "Sites" 
            //    }
            //); 
        });        
    }
};
Ext.extend(AquaticSitesMap, Ext.Panel, {
    updateMap: function() {
        this.map.clearOverlays();
        this.site2marker = {};
        
        var sites = this.store.data.items;
        var bounds = new GLatLngBounds();         
        
        for(var i=0, len=sites.length; i < len; i++) {
            var site = sites[i].data;
            var point = new GLatLng(site.lat, site.lng);
            var marker = new GMarker(point);
            var html = this.infoTpl.apply(this.prepareData(site));
            this.overlays[site.id] = { marker: marker, html: html };
            //marker.bindInfoWindowHtml(html);            
            this.map.addOverlay(marker);
            bounds.extend(point);
            console.debug("marker added at " + point.lat() + ", " + point.lng());
        }
        
        var center = bounds.getCenter();
        this.map.setCenter(center);        
        console.debug("centering map to " + center.lat() + ", " + center.lng());
        this.map.setZoom(this.map.getBoundsZoomLevel(bounds));
        console.debug("zooming to level " + this.map.getBoundsZoomLevel(bounds));
    },
    
    showMarker: function(site) {          
        var overlay = this.overlays[site.id];
        var tabs = [
            new GInfoWindowTab('Site Details', overlay.html),
            new GInfoWindowTab('Edit', '<ul><li><a href="#">Edit Site Details</a></li><li><a href="#">Add/Edit Water Temperature Data</a></li><li><a href="#">Etc.</a></li></ul>'),
            new GInfoWindowTab('Delete', '<p>Really Delete?</p><center><a href="#">Yes</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#">No</a></center>')
        ];
        
        overlay.marker.openInfoWindowTabsHtml(tabs, { maxContent: '<iframe style="width: 100%; height: 100%;" src="/temperature_loggers/temperature_data/show"></iframe>', maxTitle: "Temperature Data" });
    },
    
    prepareData: function(site) {
        site.name = site.name || 'Unnamed Site';
        site.full_description = site.description || 'No Description';        
        return site;
    }
});