// for those w/o console... sad.
if (typeof(console) == 'undefined') {
    console = { 
        log: function() {}
    }
}

function closeOpenNestedViews(record_id) {
    var open_nested_views = $$('div.open-nested-view');
    var elm_id = 'open-nested-view-' + record_id;
    open_nested_views.each(function(open_nested_view) {
        // close any other open views
        //console.log('inspecting ' + open_nested_view.id);
        if(open_nested_view.id != elm_id) {
            inline_table_row = open_nested_view.up('tr.inline-adapter');
            //console.log('re-enabling action links');
            inline_table_row.previous('tr.record').select('a.action.disabled').each(function(disabled_action) {
                //console.log('enabling ' + disabled_action.id);
                disabled_action.removeClassName('disabled');
            });
            //console.log('closing view');
            inline_table_row.remove();
        } 
    });
}

function showLocationOnMap(options, event) {
    toggleTooltip(event, $('coordinate-preview-dialog'));    
    if(!$('coordinate-preview-dialog').visible()) { 
        return;
    }
    
    // remove previous iframe
    $('coordinate-preview-result').innerHTML = '';
    
    var loading_img = $(options['loadingImage']);
    var form = $(options['form']);
    var url = options['url'];                  
    //var error_msg = "Sorry, an error occurred.  Please try again later.";
    var params = [];
    for(var i=0; i < options['fields'].length; i++) {
        var field_name = options['fields'][i];
        params.push( form[field_name] );
    }
    var query = Form.serializeElements(params);
    var request = url + '?' + query;
    
    var iframe = document.createElement('iframe');
    iframe.src = request;
    Element.extend(iframe);
    //    iframe.observe('load', function(event) {
    //        // hide the loading message
    //        $(loading_img).setStyle({ visibility: 'hidden' });
    //        $('coordinate-preview-loading').hide();                  
    //        $('coordinate-preview-result').show();
    //    });
    //    
    //    // show the loading message
    //    $('coordinate-preview-result').hide();
    //    $(loading_img).setStyle({ visibility: 'visible' });
    //    $('coordinate-preview-loading').show();
    
    // active the request
    $('coordinate-preview-result').appendChild(iframe);
}

function doToggleAreaOfInterest(url, update, error, loader) {
    new Ajax.Updater(update, url, {
        asynchronous: true, 
        evalScripts: true, 
        method: 'post', 
        onComplete: function(request) {
            $(loader).style.visibility = 'hidden';
        }, 
        onFailure: function(request) {
            ActiveScaffold.report_500_response(error);
        }
    }); 
    $(loader).style.visibility = 'visible';
    return false;
}

function initDescriptions() {
    $$('.tooltip-box').each(function(tooltip_box) {
        var prev = tooltip_box.previous('input');
        if(!prev) {
            prev = tooltip_box.previous('select');
        }
        if(prev) {
            console.log('attaching tooltip listeners to ' + prev);
            prev.observe('mouseover', function(evt) {
                this.next('.tooltip-box').show();
            });
            prev.observe('mouseout', function(evt) {
                this.next('.tooltip-box').hide();
            });
        }
    });
}

Event.observe(window, 'load', initDescriptions);
Ajax.Responders.register({
    onComplete: function() {
        initDescriptions();
    }
});
