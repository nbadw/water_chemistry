Observations = {
    data: [],
    
    loadData: function(observations) {
        this.data = observations;
    },
    
    setGroup: function(group) {
        if(group != null && group != '')
            this.displayObservationGroup(group);
        else
            this.displayAllObservations();
    },

    displayObservationGroup: function(group) {
        console.log('display only ' + group + ' observations');
    },
    
    displayAllObservations: function() {
        
    }
}

Event.addBehavior({
    'select#observation-group:change': function(e) {
        var observation_group_select = $('observation-group');        
        var selected_group = observation_group_select.options[observation_group_select.selectedIndex].value;
        Observations.setGroup(selected_group);
    }
});

