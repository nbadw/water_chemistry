Event.observe(window, 'load', function() {
    console.log('apply fix for two open create forms on the water chemistry sampling page');
    var site_measurements  = $('site_measurements-active-scaffold');
    var water_measurements = $('water_measurements-active-scaffold');

    site_measurements.down('a.new.action').observe('click', function(evt) {
        maybeRemoveInlineCreateForm(water_measurements);
    });

    water_measurements.down('a.new.action').observe('click', function(evt) {
        maybeRemoveInlineCreateForm(site_measurements);
    });
});

function maybeRemoveInlineCreateForm(elm) {
    var create_form = $(elm).down('table tr.inline-adapter form');
    if(create_form) {
        $(elm).down('table tr.inline-adapter').remove();
        $(elm).down('a.new.action').removeClassName('disabled');
    }
}