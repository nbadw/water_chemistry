var NBADW = {};
NBADW.Help = function () {
    // "private" variables:
    // var myPrivateVar = "I can be accessed only from within Help.";
    var current_url       = null;
    var help_contents     = null;
    var help_action       = null;
    var close_action      = null;
    var loading_indicator = null;
    var content           = null;
    var error_msg         = "We're sorry, an error occurred.  Please try again later.";
    
    var opened = function() {
        return help_contents.visible();  
    };
    
    var setContents = function(text) {
        content.innerHTML = text;
    };
    
    var attachHelpSectionListeners = function() {        
        help_contents.select('.help-section a').each(function(help_section) {
            console.log('listening to events on help section "' + help_section.innerHTML + '"');
            help_section.observe('click', toggleHelpSection);
        });
    }
    
    var toggleHelpSection = function(evt) {        
        Event.stop(evt);
        console.log('toggling help section "' + this.innerHTML + '"');
        var section_content = this.up().next();        
        if(section_content.visible()) {
            section_content.hide();       
            this.previous().innerHTML = '+';
            this.removeClassName('expanded');
        } else {
            section_content.show();        
            this.previous().innerHTML = '-';
            this.addClassName('expanded');
        }     
    }
    
    var displayHelp = function(help_url) {
        new Ajax.Request(help_url, {
            onCreate: function() {
                console.log('loading help...');
                close_action.hide();
                content.hide();
                loading_indicator.show();
            },
            onSuccess: function(transport) {                
                setContents(transport.responseText);
                attachHelpSectionListeners();
                current_url = help_url;
            },
            onFailure: function() {
                setContents(error_msg);
                current_url = null;
            },
            onComplete: function() {
                console.log('...loading help complete');
                loading_indicator.hide();
                close_action.show();
                content.show();
            } 
        });
    };

    //"private" method:
    // var myPrivateMethod = function () {
    //   YAHOO.log("I can be accessed only from within Help");
    // }

    return  {
        //        myPublicProperty: "I'm accessible as Help.myPublicProperty.",
        //        myPublicMethod: function () {
        //            YAHOO.log("I'm accessible as Help.myPublicMethod.");
        //            //Within myProject, I can access "private" vars and methods:
        //            YAHOO.log(myPrivateVar);
        //            YAHOO.log(myPrivateMethod());
        //            //The native scope of myPublicMethod is myProject; we can
        //            //access public members using "this":
        //            YAHOO.log(this.myPublicProperty);
        //        }
        init: function() {
            console.log('initializing help functionality');
            help_contents     = $('help-contents');
            help_action       = $('help');
            close_action      = $$('#help-contents .close').first();
            loading_indicator = $$('#help-contents .loading').first();
            content           = $$('#help-contents .text').first();
            
            if(!help_contents || !help_action || !close_action || !loading_indicator || !content) {
                if(!help_contents)     console.log('could not find required element #help-contents');                
                if(!help_action)       console.log('could not find required element #help');
                if(!close_action)      console.log('could not find required element #help-contents .close');
                if(!loading_indicator) console.log('could not find required element #help-contents .loading');
                if(!content)           console.log('could not find required element #help-contents .text');
                console.log('aborting help initialization');
                return;
            }
            
            Event.observe(help_action, 'click', function(evt) {
                console.log('help action clicked');
                Event.stop(evt); 
                NBADW.Help.view(this.href);
            });
            
            Event.observe(close_action, 'click', function(evt) {
                console.log('close action clicked');
                Event.stop(evt);
                NBADW.Help.close();
            })
        },
    
        view: function(help_url) {
            console.log('viewing help at ' + help_url); 
            if(!opened()) {
                this.open();
            }
            if(current_url != help_url) {
                displayHelp(help_url);
            }
        },
      
        open: function() {
            console.log('opening help');
            help_action.addClassName('open');
            help_contents.show();
        },
      
        close: function() {
            console.log('closing help');
            help_action.removeClassName('open');
            help_contents.hide();
        }
    };
}();

Event.observe(window, 'load', NBADW.Help.init);