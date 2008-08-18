#--
# Copyright (c) 2007 The World in General
# Created by Luc Boudreau ( lucboudreau at gmail )
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

For details about use and stuff, refer to the API or the wiki at http://actionflow.devdonkey.org

To install, download from

  http://rubyforge.org/frs/?group_id=2769

Just drop the action_flow folder into RAILS_ROOT/vendor/plugins then create controllers and change their superclass to ActionFlow::Base. 



To install the latest version right from SVN head, go to your app's root
and type 

  script/plugin install svn://rubyforge.org/var/svn/actionflow/trunk/action_flow
  

Then create controllers and make them inherit the ActionFlow::Base class
instead of ActionController::Base.

  



/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*
/*/*/*/*/*/*/    Environment variables don't work /*/*/*/*/*/*/*/*/*
/*/*/*/*/*/*/    for now. If you can fix it, send /*/*/*/*/*/*/*/*/*
/*/*/*/*/*/*/    the patch at the email above.    /*/*/*/*/*/*/*/*/*
/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*
You can also modify some parameters from the environment files. The available modifications are :

 - ActionFlow::Base.event_prefix
     This is a prefix added to the event names.
     Default : _event_
     
 - ActionFlow::Base.event_input_name_prefix
     This is a prefix added to the submit button used to return a form to the controller.
     Default : _submit_
     

 - ActionFlow::Base.flow_execution_key_id
     This is the name of the input which will retun a flow id vrom a view.
     Default : flow_exec_key


 - ActionFlow::Base.session_data_prefix
     This is a prefix added to the session variables which hold the flow data. It is appended 8 characters which identify the flow.
     Default : flow_data-


 - ActionFlow::Base.session_timestamp_placeholder
     This is the key used to store the last update timestamp inside a flow data hash
     Default : updated_at


 - ActionFlow::Base.session_ttl
     Time for which flow data is held inside a session.
     Default : 1.hour
     
  - ActionFlow::Base.last_step_placeholder
     This is the key used to store the name of the last executed step in a state data hash.
     Default : last_step_name
