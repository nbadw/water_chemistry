TaskStore = function() {
    console.debug("creating task store");
    
    TaskStore.superclass.constructor.call(this, {
        reader: new Ext.data.JsonReader({
            totalProperty: 'results',
            root: 'tasks',
            id: 'id'
        }, Task)
    });
};

Ext.extend(TaskStore, Ext.data.Store, {
    
});