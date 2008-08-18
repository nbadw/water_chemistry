#--
# Copyright (c) 2007 The World in General
#
# Released under the Creative Commons Attribution-Share Alike 3.0 License.
# Licence details available at : http://creativecommons.org/licenses/by-sa/3.0/
#
# Created by Luc Boudreau ( lucboudreau at gmail )
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



module ActionFlow
  
  
  
  
  
  # The ActionFlow framework turns an ActionController into a flow capable
  # controller. It can handle event trigerring, the back button and any
  # user defined step. Here are the main concepts.
  #
  # == Concepts
  # 
  # === Flow
  # 
  # A flow is a logical procedure which defines how to handle different
  # steps and guide the user through them.
  # 
  # === Step
  # 
  # A step is a single unit of processing included inside a flow. All steps
  # have to inherit from ActionFlow::FlowStep. They can be used to define one
  # of the following :
  # 
  # - ViewStep : displays a view and then relays the execution to methods or steps according to the trigered event.
  #               
  # - ActionStep : calls a method of an ActionFlow controller and then relays the execution to methods or steps according to the trigered event.
  # 
  # More step types can be created to extend the ActionFlow framework.
  # 
  # === Event
  # 
  # An event is nothing more than a symbol which triggers the execution of methods
  # or steps, depending on the mapping. There are reserved events which cannot be
  # mapped by a user inside of a subclass of ActionFlow::Base controllers. To ask 
  # the controller if an event name has been reserved for internal purposes, use :
  #
  #  ActionFlow::Base.reserved_event? :event_name_to_verify
  #
  # == Creating a mapping
  #
  # The mapping is where you tell your controller how to connect the different steps.
  # 
  # To declare a controller mapping, you must do it in the object's <tt>initialize</tt>
  # method. This method will be automatically called upon the instanciation of your
  # controller.
  #
  # === Simple mapping example
  #
  #  class MyController < ActionFlow::Base
  #  
  #    def initialize
  #
  #      start_with             :step_1
  #      end_with               :end_my_flow
  #      redirect_invalid_flows :step_1
  #    
  #      upon :StandardError => :end_my_flow
  #   
  #      action_step :step_1 do
  #        method :start_my_flow
  #        on     :success => :step_2
  #      end
  #   
  #      view_step :step_2 do
  #        on :finish => end_my_flow
  #      end
  #
  #      view_step :end_my_flow
  #    
  #    end
  #   
  #    def start_my_flow
  #      # Nothing to be done
  #      event :success
  #    end
  #  
  #  end
  #
  # Let's decompose what we just did in this very minimalist controller.
  #
  # * The flow starts with the step named <tt>step_1</tt>.
  # * The flow data will be destroyed once we reach the <tt>end_my_flow</tt> step.
  # * If the user sends an invalid key or his flow data is expired, we redirect the flow to the <tt>step_1</tt> step.
  # * If an error of class StandardError or any subclass of it is raised and not handled by the steps, the controller will route the flow to the <tt>end_my_flow</tt> step.
  # * We declared a step named <tt>step_1</tt>. The step is implemented via the method named <tt>start_my_flow</tt>. If the <tt>success</tt> event is returned, we route the flow to the step named <tt>step_2</tt>.
  # * We declared a step named <tt>step_2</tt>. If the <tt>finish</tt> event is returned, the step named <tt>end_my_flow</tt> will be called.
  #
  # There are many other config options which can be used. I strongly suggest reading
  # the whole API documentation. 
  # 
  # == Reserved events
  # 
  # The ActionFlow::Base controller reserves the following event names for 
  # itself.
  # 
  #  - render : Tells the framework that we must return the control to the view
  #             parser, since one of the 'render' method has been called and we
  #             are now ready to display something.
  # 
  # == About Plugins
  # 
  # The ActionFlow framework has a plugin system, but is unstable and 
  # incomplete. Don't bother using it for now, unless you want to contribute
  # of course. This class is stable and ready for plugin registrarion though. 
  # The Plugin class is not. To activate the plugins system, go to the 
  # #{ACTIONFLOW_ROOT}/action_flow/action_flow.rb file and uncomment the
  # plugins initialisation code.
  # 
  class Base < ActionController::Base

    
    # Defines the symbols name prefix which are used to identify the next events.
    # As an example, in a view_state, the button used to trigger the save event 
    # would be named '_event_save'. If we were in an action_state, to trigger the
    # success event, we would 'return :_event_success'
    @@event_prefix = '_event_'
    cattr_accessor :event_prefix
    
    
    
    # Defines the name of the parameter submitted which contains the next event name.
    @@event_input_name_prefix = '_submit_'
    cattr_accessor :event_input_name_prefix
    
    
    
    # Defines the regex used to validate the proper format of a submitted
    # event name.
    Event_input_name_regex = /^#{event_input_name_prefix}#{event_prefix}([a-zA-Z0-9_]*)$/
    
    
    
    # Defines the name of the variable which holds the flow unique state id.
    # As an example, a view_state would add a hidden field named 'flow_exec_key',
    # which would contain the key used to store a state in the session.
    # 
    # We could then restore the state by accessing it with :
    # session[:flow_data-1234abcd].fetch( params[:flow_exec_key] )
    #
    # See the SessionHandler for more details
    @@flow_execution_key_id = 'flow_exec_key'
    cattr_accessor :flow_execution_key_id
    
    
    
    
    # Aliasses the 'render' method to intercept it and cache it's execution results.
    # Doing this allows to delay the calls to the render method until the end of the
    # current step chain so that if a plugin wishes to interrupt the chain and render
    # some other content, there won't be any conflict between previous calls to the
    # render method.
    alias_method :old_render, :render
    
    
    
    
    # Aliasses the 'redirect_to' method to intercept it and cache it's execution results.
    # Doing this allows to delay the calls to the redirect_to method until the end of the
    # current step chain so that if a plugin wishes to interrupt the chain and redirect
    # the request, there won't be any conflict between previous calls to the
    # redirect_to method.
    alias_method :old_redirect_to, :redirect_to

    
    
    
    # Class method to tell the ActionFlow framework to prevent users from mapping certain
    # event names. Use it as :
    #
    #  ActionFlow::Base.reserve_event :some_event_name
    # 
    def self::reserve_event(event_name)
    
      # Reserve the event passed as a parameter
      reserved_events.push( event_name.to_s )
      
      # Remove duplicates
      reserved_events.uniq!
    
    end
    
    
    
    
    
    # Class method to tell the ActionFlow framework to notify a plugin upon
    # a certain internal event happening. Use it in a plugin class as follows :
    #
    #  ActionFlow::Base.listen :some_event, self
    # 
    def self::listen(internal_event_name, plugin)
    
      # Reserve the event passed as a parameter but first validate
      # that it's a subclass of ActionFlow::Plugin
      #plugin.kind_of?(ActionFlow::Plugin) ? filters.fetch(internal_event_name.to_s).push(plugin) : raise(ActionFlowError.new, "One of your plugins tried to register itself as a listener and is not a subclass of ActionFlow::Plugin. The culprit is : " + plugin.inspect )
      
      filters.fetch(internal_event_name.to_s).push(plugin)

    end
    
    
    
    
    
    # Class method to ask the ActionFlow framework if a given event name has been reserved
    # and can't therefor be mapped by users.
    #
    #  ActionFlow::Base.reserved_event? :some_event_name
    # 
    def self::reserved_event?(event_name)
        
      reserved_events.include? event_name.to_s
        
    end
    
    
    
    
    
    
    # Default method to handle the requests. All the dispatching is done here.
    def index
    
      # Holds the calls to the render method to delay their execution
      @renders = Array.new
            
      # Holds the calls to the redirect method to delay it's execution
      @redirects = Array.new
      
      
      begin
      
        # Notify the plugins we got here
        notify :request_entry
    
        # Tells which was the last state
        @flow_id = params[flow_execution_key_id]
      
        # Flag used to know if we reached the end_step
        @end_step_reached = false
         
        # Check if the flow has already started
        unless @flow_id
      
          # Notify plugins we've just started a new flow
          notify :before_new_flow
          
          # Make sure there's a start_step defined
	  raise (ActionFlowError.new, "Your controller must declare a start step name. Use 'start_with :step_name' and define this step in the mapping.") if start_step.nil?
	              
	  # Make sure there's an end_step defined
          raise (ActionFlowError.new, "Your controller must declare an end step name. Use 'end_with :step_name' and define this step in the mapping. I suggest using a view step which could redirect if you don't want to create a 'thank you' screen.") if end_step.nil?
        
          # Start a new flow session storage
          start_new_flow_session_storage
        
          # Notify plugins
          notify :before_step_execution_chain
        
          # Execute the start_step
          execute_step start_step
      
        else # We have to resume a flow with a given id
       
          # Notify plugins we've just started a new flow
          notify :before_flow_resume
        
          # Get the event name
	  raise(ActionFlowError.new, "Your view did not submit properly an event name.") unless event_name = url_event_value(params)
	
	  # Make sure there's data associated to this flow
          return nil if redirect_invalid_flow!
        
          # We need to know where we came from
          last_step = fetch_last_step_name
        
          # Make sure that the step has an outcome defined for this event
          raise (ActionFlowError.new, "No outcome has been defined for the event '#{event_name}' on the step named '#{last_step}' as specified in the submitted data. Use the 'on' method on your mapped step or make sure that you are submitting valid data.") unless step_registry.fetch(last_step).has_an_outcome_for?(event_name)
          
          # Before doing anything, we create a new state so we can restore the previous one with
          # the back button.
          serialize
        
          # Call the resulting step associated to this event
          execute_step step_registry.fetch(last_step).outcome(event_name)
        
        end
      
        # Notify plugins
        notify :after_step_execution_chain
      
        # Cleanup the flows which have been hanging too long in the session placeholder
        cleanup
      
      
        # Check if we continue
        terminate if @end_step_reached
        
        # Execute all the cached render calls
        render!
        
        # Execute all the cached redirect calls
        redirect!
        
      # Rescue interruptions thrown by the plugins
      rescue PluginInterruptionError => error
      
        # We execute the interruption block
        instance_eval &error.block
      
      end
      
    
    end
    
    
    
    protected
    

      
      
      
      
      
      # Overrives the calls to the 'render' method so that renders are delayed
      # until the end of the execution chain.
      #
      # Prevents conflicts between regular rendering and subsequent plugin interruptions.
      #
      def render(options = nil, deprecated_status = nil, &block)
      
        # Cache the parameters
        @renders.push ( :options => options, :deprecated_status => deprecated_status, :block => block )
        
      end
      
      
      
      # Executes the 'render' method calls intercepted while executing the
      # step execution chain.
      def render!
      
        @renders.each do |parameters|
        
          old_render parameters[:options], parameters[:deprecated_status] do parameters[:block].call end
        
        end
      
      end
      
      
      
      
      
      
      # Overrives the calls to the 'redirect_to' method so that redirects are delayed
      # until the end of the execution chain.
      #
      # Prevents conflicts between regular redirection and subsequent plugin interruptions.
      #
      def redirect_to(options = {}, *parameters_for_method_reference)
      
        # Cache the parameters
        @redirects.push ( :options => options, :parameters_for_method_reference => parameters_for_method_reference )
      
      end
      
      
      
      
      
      
      # Executes the 'render' method calls intercepted while executing the
      # step execution chain.
      def redirect!
            
        @redirects.each do |parameters|
              
          old_redirect_to parameters[:options], parameters[:deprecated_status]
              
        end
            
      end
      
      
      
      
      
      
      # Adds a step name to the registry and associates it to an object
      # which will be used to handle a given step when necessary.
      def register(step_name, step)
      	step_registry.store(step_name.to_s, step)
      end
      
      
      
      
      
      # Called in a mapping to define the end point of the flow. Once this
      # step finishes it's execution, the flow data is deleted.
      # Pass it a symbol which bears the same name as a defined step.
      # ie.
      #   
      #   end_with :defined_step_name
      #   
      # would point to the definition :
      # 
      #   view_state :defined_step_name do
      #     (...)
      #   end
      #   
      def end_with(step_name)
        @_end_step = step_name.to_s
      end
      
      
      # Called in a mapping to define the starting point of the flow.
      # Pass it a symbol which bears the same name as a defined step.
      # ie.
      #   
      #   start_with :defined_step_name
      #   
      # would point to the definition :
      # 
      #   view_state :defined_step_name do
      #     (...)
      #   end
      #   
      def start_with(step_name)
        @_start_step = step_name.to_s
      end
      
    
    
    
    
    
    
    
      # Called in a mapping to define which method should be called
      # if the user submits an invalid flow id. Use it as :
      #
      #  redirect_invalid_flows :url => { :controller => :my_controller, :action => :index }
      # 
      def redirect_invalid_flows( url={:action=>:index} )
        @_no_flow_url = url
      end
      
      
      
    
    
    
      # Allows the controller to handle errors which were not handled by
      # the steps themselves.
      # 
      #  class MyController < ActionFlow::Base
      #    def initialize
      #      (...)
      #      upon :ActionFlowError => :step_name
      #    end
      #    (...)
      #  end
      # 
      # This is also possible :
      # 
      #  class MyController < ActionFlow::Base
      #    def initialize
      #      (...)
      #      upon { :ActionFlowError => :step_name,
      #             :WhateverError =>   :step_name  }
      #    end
      #    (...)
      #  end
      #
      # Only subclasses of StandardError will be rescued. This means that RuntimeError
      # cannot be handeled.
      # 
      def upon ( hash )
              
        # Make sure we received a hash
        raise(ActionFlowError.new, "The 'upon' method takes a Hash object as a parameter. Go back to the API documents since you've obviously didn't read them well enough...") unless hash.kind_of?(Hash)
              
        # Make sure the key is not used twice in a definition
        # to enforce coherence of the mapping.
        hash.each_key do |key|
          raise (ActionFlowError.new, "An error of the class '#{key}' is already mapped. They must be unique within a controller scope.") if handlers.has_key?(key.to_s)
        end
              
        # Store the values in the handlers hash
        hash.each { |key,value| handlers.store key.to_s, value.to_s }
              
      end
    
    
    
    
    
    
    
    
      
      
      # Suger method called from suclasses to return events.
      # 
      # Use it as :
      #
      #  def my_action
      #  
      #   # Do something
      #   
      #   # Now return an event
      #   event :success
      #   
      #  end
      #
      def event(name)
        ActionFlow::Event.new(name.to_s)
      end
      
      
      
      
      
      
      
      
      

    private
    
    
    
    # Launches the execution of a given step name. Encountered errors  and events
    # will be managed as defined in the mapping.
    #
    # If a step returns one of the reserved event names defined in the class variable,
    # the execution chain will be stoped and the event will be returned to the 
    # caller of the execute_step method.
    #
    def execute_step(step_name)

      # Notify plugins we've just started a new flow
      notify :before_any_step_execution

      @step_name = step_name = step_name.to_s

      # Make sure that this step is registered
      raise (ActionFlowError.new, "The desired step ( #{step_name} ) is not present in the mapping.") unless step_registry.has_key? step_name

      # Validate that the controller will answer to the message
      raise (ActionFlowError.new, "Your controller doesn't have a method called '#{step_name}' as defined in your mapping.") if !respond_to?(step_name) && step_registry.fetch(step_name).definition_required?

      # Everything is ready for execution, we just have to memorize that this step
      # was caled.
      persist_last_step_name step_name

      # Encapsulate the execution in a begin block to manage
      # the errors. Runtime errors are not managed. Only subclasses
      # of StandardError will be.
      begin

	# Execute the step and keep the returned value
	return_value = step_registry.fetch(step_name).send :execute, self

	# Notify plugins we've just started a new flow
	notify :after_any_step_execution

	# Check if this was the end step, if so, cut the execution short
	if end_step.to_s == fetch_last_step_name

	  # Raise that flag
	  @end_step_reached = true

	  #Notify plugins
	  notify :after_end_step

	  # Terminate execution chain
	  return
	end

	# Make sure that the step returned an event object
	raise (ActionFlowError.new, "Your step definition named '#{step_name}' didn't return an ActionFlow::Event object. All steps must return either events or errors.") unless return_value.kind_of? ActionFlow::Event

	# If the event name was reserved in the class registry by someone, ignore the
	# event and return the event to the caller
	if self.class.reserved_event? return_value.name

	  return return_value

	else

	  # This event name wasn't reserved, so let's call the outcome.

	  # Make sure that the step has an outcome defined for this event
	  raise (ActionFlowError.new, "No outcome has been defined for the event '#{return_value.name}'. Use the 'on' method on your mapped step.") unless step_registry.fetch(step_name).has_an_outcome_for?(return_value.name.to_s)

	  # Call recursively the step mapped to the returned event
	  value = execute_step step_registry.fetch(step_name).outcome(return_value.name)

	  return value

	end

      # Rescue any subclass of StandardError
      rescue StandardError => error

	# Ask the step if he handles this error
	if step_registry.fetch(step_name).handles? error.class.to_s

	  # Notify plugins
	  notify :upon_handled_error

	  # Get the handler step name
	  handler_name = step_registry.fetch(step_name).handler(error.class.to_s)

	  # Make sure this handler is in the registry
	  raise (ActionFlowError.new, "The error handling step ( #{handler_name} ) is not present in the mapping.") unless step_registry.has_key? handler_name

	  # Execute the error handling step recursively
	  execute_step handler_name

	# Check if the controller has something to say about it.
	elsif handlers.has_key? error.class.to_s

	  # Notify plugins
	  notify :upon_handled_error

	  # Get the handler step name
	  handler_name = handlers.fetch error.class.to_s

	  # Make sure this handler is in the registry
	  # Execute the error handling step recursively if present
	  step_registry.has_key?(handler_name) ? execute_step(handler_name) : raise (ActionFlowError.new, "The error handling step ( #{handler_name} ) is not present in the mapping.") 


	# Nobody to route to
	else

	  # Notify plugins
	  notify :upon_unhandled_error

	  # Well, we've tried. It's now an official 'Someone Else Problem'
	  raise error



	end

      end

      # Notify plugins
      notify :after_any_step_execution
            
    end
    
    
    
    
    
    
      # Called in a mapping to define which method should be called
      # if the user submits an invalid flow id
      def redirect_invalid_flow!
              
        unless validate_flow_existence
              
          unless @_no_flow_url ||= nil
                  
            raise (ActionFlowError.new, "No flow data could be found for the given flow key. Your session doesn't exist.") 
              
          else 
                
            redirect_to @_no_flow_url
                  
            return true
                  
          end
                
        end
              
        return false
                
      end
    
    
    
      # Makes the step_registry available and instanciates it
      # if necessary.
      def step_registry
        @_step_registry ||= {}
      end
            
      # Makes the step_registry available and instanciates it
      # if necessary.
      def handlers
        @_handlers ||= {}
      end
    
    
    
      # Makes the start_step available and instanciates it
      # if necessary.
      def start_step
        @_start_step ||= nil
      end
            
      # Makes the end_step available and instanciates it
      # if necessary.
      def end_step
        @_end_step ||= nil
      end
    
    
      # Returns the array of event names which cannot be mapped by users.
      # These names are class level, so they are shared by all the instances
      # of ActionFlow::Base.
      def self::reserved_events
      
        # Holds the reserved event names that cannot be mapped by users.
        @@_reserved_events ||= Array.new
        
      end
      
      
      # This method returns a basic set of internal filter handles on which the plugin
      # system can tap into. When developing a plugin, we can call the ActionFlow::Base.listen
      # class method to get called upon the encounter of a given internal event.
      def self::filters
      
      	@@_filters ||= { 'request_entry' => Array.new,
      	                'before_new_flow' => Array.new,
      	                'before_flow_resume' => Array.new,
      	                'before_any_step_execution' => Array.new,
      	                'after_any_step_execution' => Array.new,
      	                'before_step_execution_chain' => Array.new,
      	                'after_step_execution_chain' => Array.new,
      	                'upon_handled_error' => Array.new,
      	                'upon_unhandled_error' => Array.new,
      	                'after_end_step' => Array.new
      	              }
      
      end
      
      
      
      
      
      # Internal method used to notify all the listeners of a given event that
      # we just reached one of the internal events
      def notify(internal_event_name)
        
        # Get the array of listeners for a given event
        ActionFlow::Base.filters.has_key?(internal_event_name.to_s) ? listeners = ActionFlow::Base.filters.fetch(internal_event_name.to_s) : raise(ActionFlowError.new, "Internal programming error...")
        
        # Iterate over the listeners
        listeners.each do |plugin|
        
          # Notify each one of the event
          plugin.send :notify, ActionFlow::SystemEvent.new(internal_event_name.to_s, self, current_flow_data, request, response, session)
        
        end
        
      end
      
      
      
      
      # Searches the parameters for the event name passed from the view.
      # Returns nil if it can't be found.
      def url_event_value(param_hash)
      
        # Iterate over the parametres received
        param_hash.each do |key,value|
        
          # Return regex group 1 if we have a match
      	  return $1 if key.to_s =~ Event_input_name_regex
        
        end
        
        # We didn't find any event name, return nil as the contract says.
        return nil
      
      end
      
      
      
  end

  
end
