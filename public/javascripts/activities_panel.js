ActivitiesPanel = Ext.extend(Ext.DataView, {
    autoHeight: true,
    frame:true,
    cls: 'activities',
    itemSelector: 'dd',
    overClass: 'over',
    
    tpl : new Ext.XTemplate(
    '<div id="activities-ct">',
    '<tpl for=".">',
    '<div><a name="activity-{id}"></a><h2><div>{title}</div></h2>',
    '<dl>',
    '<tpl for="activities">',
    '<dd ext:url="{url}">',
    '<div><h4>{text}</h4><p>{desc}</p></div>',
    '</dd>',
    '</tpl>',
    '<div style="clear:left"></div></dl></div>',
    '</tpl>',
    '</div>'
),

    onClick : function(e) {
        var group = e.getTarget('h2', 3, true);
        if(group) {
            group.up('div').toggleClass('collapsed');
            console.log('toggle group');
        } else {
            var t = e.getTarget('dd', 5, true);
            if(t && !e.getTarget('a', 2)) {
                var url = t.getAttributeNS('ext', 'url');
                console.log('opening ' + url);
                window.location = url;
            }
        }
        return ActivitiesPanel.superclass.onClick.apply(this, arguments);
    }
});

Ext.EventManager.on(window, 'load', function() {      
    var store = new Ext.data.JsonStore({
        idProperty: 'id',
        fields: ['id', 'name', 'category', 'desc'],
        data: [] //<%= @activities.to_json  %>
    });

    new Ext.Panel({
        items: new ActivitiesPanel({
            store: store
        })
    }).render('content');
});