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

#require 'event'
#require 'base'

module ActionFlow

  # The FlowStep is a superclass from which every step type inherits.
  # It's methods are therefore available to any step type present in the
  # ActionFlow framework.
  #
  # == Mapping instructions
  #
  # The mapping instructions common to every step type are the following.
  #
  # === on
  #
  # The <tt>on</tt> instruction is used to map a returned event name to a
  # subsequent step. Here's a simple example of it's usage.
  #
  #  action_step :example_step do
  #  
  #    (...)
  #  
  #    on :success => :next_step_name
  #  
  #    on :back => :previous_step_name
  #  
  #  end
  #
  # In the previous example, the example step will route the flow to the 
  # step named <tt>next_step_name</tt> if the step definition returns an
  # event which is named <tt>success</tt>. If the step definition
  # returns a <tt>back</tt> event, the flow will then call the 
  # <tt>previous_step_name</tt> step.
  #
  # === upon
  #
  # The <tt>upon</tt> instruction is used to map a raised error class to a
  # subsequent step. Here's a simple example of it's usage.
  #
  #  action_step :example_step do
  #  
  #    (...)
  #  
  #    upon :StandardError => :next_step_name
  #  
  #  end
  #
  # In the previous example, the example step will route the flow to the 
  # step named <tt>next_step_name</tt> if the step definition raises an
  # error which is a kind of <tt>StandardError</tt>. If the upon instruction
  # is used more than once, the first declaration has priority. Also note
  # that the <tt>kind_of?</tt> method is used to validate the correspondance,
  # so subclasses of mapped error classes will be included as well.
  #
  # === method
  #
  # The <tt>method</tt> instruction is meant to override the default step
  # definition name. By default, the definition of a given step has to be declared
  # with the same name as the step name in the mapping. If a step is named 
  # <tt>my_jolly_step</tt>, the controller has to implement the step logic
  # with a <tt>def</tt> block which is named <tt>my_jolly_step</tt>.
  #
  # The <tt>method</tt> instruction will tell the ActionFlow framework to look for
  # a definition of the given value instead of looking for the same name.
  # This allows to reuse business logic and decouple the mapping from the
  # step implementation. One could then do something like :
  #
  #  class MyController < ActionFlow::Base
  #  
  #    def initialize
  #    
  #      (...)
  #   
  #      action_step :step_1 do
  #        method :shared_implementation
  #        (...)
  #      end
  #   
  #      action_step :step_2 do
  #        method :shared_implementation
  #        (...)
  #      end
  #    end
  #   
  #    def shared_implementation
  #      (...)
  #    end
  #  
  #  end
  #
  #
  # == Developper infos
  #
  # This class defines a basic skeletton for different step types
  # used by the ActionFlow framework. All new step types must inherit
  # of this superclass to be usable in the ActionFlow controller.
  #
  # It is also the responsability of any subclass to add it's declaration
  # method in the ActionFlow::Base class. See view_step.rb for an example.
  # 
  # Also, subclasses can change the @definition_required instance variable value
  # to tell the ActionFlow framework that it can handle the execution
  # without the user controller defining explicitely a step implementation.
  # See view_step.rb(initialize) for an example.
  #
  # Event outcomes are defined in the @outcomes instance variable while
  # the error handlers are defined in the @handlers instance variable.
  # Those variables are protected, so any subclasses of FlowStep can access
  # them and hack the mechanism if required.
  #
  class FlowStep    
    
    
    # Method signature to override in implementing classes.
    # Does the 'dirty job' once it is required.
    # 
    # Each implementing step HAS TO VERIFY THE VALUE OF THE lookup_method_to_call
    # method. Or else, the 'method' instruction won't be respected
    # if the user has used the 'method' instruction.
    # 
    def execute(*args)
  
      raise (ActionFlowError.new, "You can't directly use FlowStep as a step. As a matter of fact, I don't even know how you were able in the first place anyways...")
  
    end
    
    
    # Used to know if the step needs an explicitely declared step definition or if it can
    # manage the task with a default behavior.
    def definition_required?
      # We have to distinguish the false value from the non
      # existence of the variable. Therefore the ||= operator
      # can't help us.
      if @definition_required.class.kind_of?(NilClass)
	@definition_required = true
      else
        @definition_required
      end
    end
  
  

    # Maps an event to a method call. Use in a mapping like this :
    # 
    # implemented_step_type :id_of_step do
    #   on :event => :method
    # end
    # 
    # This is also possible :
    # 
    # implemented_step_type :id_of_step do
    #   on { :event => :method,
    #        :event2 => :method2 }
    # end
    # 
    def on ( hash )
    
      # Make sure we received a hash
      raise(ActionFlowError.new, "The 'on' method takes a Hash object as a parameter. Go back to the API documents since you've obviously didn't read them well enough...") unless hash.kind_of? Hash
    
      # Make sure the key is not used twice in a definition
      # to enforce coherence of the mapping.
      hash.each_key do |key|
        raise (ActionFlowError.new, "An event already uses the name '#{key}'. They must be unique within a step scope.") if outcomes.has_key?(key.to_s)
        raise (ActionFlowError.new, "You can't define an event named '#{key}' since it's a reserved event keyword.") if ActionFlow::Base.reserved_event?(key.to_s)
      end
    
      # Store the values in the possible outcomes hash
      hash.each { |key,value| outcomes.store key.to_s, value.to_s }
    
    end
  

    # Maps an error class to a step name to execute. 
    # Use in a mapping like this :
    # 
    #  implemented_step_type :id_of_step do
    #    upon :ActionFlowError => :step_name
    #  end
    # 
    # This is also possible :
    # 
    #  implemented_step_type :id_of_step do
    #    upon { :ActionFlowError => :step_name,
    #           :WhateverError => :step_name }
    #  end
    # 
    # Only subclasses of StandardError will be rescued. This means that RuntimeError
    # cannot be handeled.
    # 
    def upon ( hash )
    
      # Make sure we received a hash
      raise(ActionFlowError.new, "The 'upon' method takes a Hash object as a parameter. Go back to the API documents since you've obviously didn't read them well enough...") unless hash.kind_of? Hash
    
      # Make sure the key is not used twice in a definition
      # to enforce coherence of the mapping.
      hash.each_key do |key|
        raise (ActionFlowError.new, "An error of the class '#{key}' is already mapped. They must be unique within a step scope.") if handlers.has_key?(key.to_s)
      end
    
      # Store the values in the handlers hash
      hash.each { |key,value| handlers.store key.to_s, value.to_s }
    
    end
    
    
    
    
    # Maps a method name to execute instead of searching
    # the controller for a method name who is the same as
    # the step name.
    #
    # Use it as :
    #
    #  action_step :my_step do
    #    method :call_this_instead
    #  end
    # 
    def method ( method_name )
    
      @_method = method_name.to_s
      
    end
    
    
  
  
  
    # Tells if the error class passed as an argument is handled
    def handles?(error_class)
      handlers.has_key?(error_class)
    end
  
  
  
    # Returns the appropriate step name to execute upon 
    # the given error class
    def handler(error_class)
      error_class.kind_of?(String) ? key = error_class : key = error_class.to_s
      handlers.has_key?(key) ? handlers.fetch(key) : raise(ActionFlowError.new, "There's no handler defined for the error class '#{key}'.")
    end
  
  
    # Tells if the given event name is a possibe outcome of this step
    def has_an_outcome_for?(event_name)
      outcomes.has_key? event_name.to_s
    end

  
    # Returns the step name associated to the given event.
    def outcome(event_name)
      outcomes.has_key?(event_name.to_s) ? outcomes.fetch(event_name.to_s) : raise(ActionFlowError.new, "There's no outcome defined for the event name '#{event_name}'.")
    end
    
    
    protected
    
  
  
  
      # Tells the framework if the step needs a definition in the declaring controller. For example, the
      # view step doesn't need it. It can act without any step definition.
      @definition_required = true
  
  
  
      # Holds the different outcomes possible, which are
      # defined via the 'on' method    
      def outcomes
      	@outcomes ||= {}
      end
  
  
  
      # Holds the methods to call upon errors
      def handlers
        @handlers ||= {}
      end
      
      
      # Call this method from within a subclass to get the correct
      # method name to call. Pass a default value to return if nothing
      # is defined for this step. Don't pass a value and it will return
      # either nil or a method name.
      def lookup_method_to_call( default_value=nil )
        @_method ||= nil
        @_method.nil? ? default_value.to_s : @_method
      end
      
      
  end
end