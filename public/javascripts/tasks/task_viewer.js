TaskView = function(taskStore) {
    console.debug("creating task view");
    
    this.taskStore = taskStore;    
    this.stack = new Ext.Panel({
        region: 'center', 
        border: false       
    });
    this.navigation = new Ext.Panel({
        region: 'south',
        contentEl: 'navigation',
        border: false
    });
    this.currentTask = null;
    
    TaskView.superclass.constructor.call(this, {
        region: 'center',
        layout: 'border',
        border: false,
        items: [this.stack, this.navigation]
    });  
};

Ext.extend(TaskView, Ext.Panel, {
    show: function(task) {
        console.debug('showing task ' + task.title);
        this.loadUI(task);            
    },
    
    loadUI: function(task) {
        if(!task.ui) {
            console.debug('loading task ui for ' + task.title);
            var iframe = document.createElement('iframe');
            iframe.id = 'task-ui-' + task.id;
            iframe.src = task.url;
            iframe.style.width  = '100%';
            iframe.style.height = '100%';
            iframe.style.display = 'none';
            this.stack.body.dom.appendChild(iframe);
            task.ui = iframe.id;
        }
        this.uiLoaded(task);
    },
    
    uiLoaded: function(task) {
        console.debug('displaying task ui for ' + task.title);
        if(this.currentTask)
            Ext.getDom(this.currentTask.ui).style.display = 'none';
        
        Ext.getDom(task.ui).style.display = 'block';
        this.currentTask = task;
    }
});