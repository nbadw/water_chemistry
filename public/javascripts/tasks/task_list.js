TaskListPanel = function(taskStore) {
    console.debug('creating task list panel');
        
    this.taskStore = taskStore;
    this.listView  = new Ext.DataView({
        store: this.taskStore,
        tpl: new Ext.XTemplate(
            '<tpl for=".">', 
                '<div class="task-item">',
                    '<h3>{position}. {title}</h3>',
                '</div>',
            '</tpl>'
        ),
        singleSelect: true,
        itemSelector: 'div.task-item',
        overClass: 'x-task-view-over',
        emptyText: 'No tasks have been configured for this activity'
    });
    
    TaskListPanel.superclass.constructor.call(this, {
        region: 'west',
        width: 180,
        items: this.listView,
        split: true,
        border: false
    });  

    this.listView.on('selectionchange', function(listView, selections) {
        var selection = selections[0];
        if(!selection)
            return;
        
        console.debug('item selected');
        var task = this.taskStore.data.items[selection.viewIndex].data;        
        this.fireEvent('taskchange', task);
    }, this);
};

Ext.extend(TaskListPanel, Ext.Panel);