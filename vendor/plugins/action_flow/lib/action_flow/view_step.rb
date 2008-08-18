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

#require 'flow_step'
#require 'base'
#require 'event'

module ActionFlow

  # This class allows the controllers to create view steps. It adds the
  # view_step method to the ActionFlow::Base class evaluation so we can
  # define view steps from the controllers.
  # 
  # == Simple usage
  # 
  #  view_step :view_name do
  #    on :success => :another_step
  #    on :back => :yet_another_step
  #  end
  # 
  # The view name will be stored in the @view_name instance variable
  # until it is needed.
  # 
  # If no method corresponding to @view_name is defined inside the 
  # calling controller upon execution, the ViewStep tries to render
  # a file with the same name as the @view_step value. Therefore,
  # it is not mandatory to define view_step methods in the flow controller.
  #
  # The view_step instruction can also be used to batch define view steps.
  # Just pass a coma separated list of view names. Note that the mappings
  # defined in the following block will be applied to all the view steps
  # in the given list.
  #
  #  view_step :view_name, :another_view_step
  # 
  # == Advanced usage
  #
  # You can define how to render the view steps directly in the mapping, 
  # instead of doing it in the action itself. This gives a more clean code
  # and separates the rendering concern from the business logic. The render_to
  # instruction does this job. Here's a simple usage.
  #
  #  view_step :view_name do
  #  
  #    (...)
  #  
  #    to_render :my_event do
  #      render 'template/path'
  #    end
  #  end
  #
  # The to_render instruction tells the view step that upon the returning of the
  # my_event event from the step implementation, we must render the 'template/path' 
  # file. As a matter of fact, all the to_render does is to call the given block
  # right after the step definition execution. One could use the to_render mechanism
  # as he wishes and therefore perform actions other than rendering.
  #
  # The to_render can also take many event names as arguments simultanously, 
  # as shown here :
  #
  #  view_step :view_name do
  #  
  #    (...)
  #  
  #    to_render :my_event, :some_other_event, :yet_more_events do
  #      render 'template/path'
  #    end
  #  end
  #
  # == Inherited instructions
  #
  # The ViewStep class inherits all the standard step methods defined in FlowStep class.
  #
  #
  class ViewStep < ActionFlow::FlowStep
  
  
    # Initializes the instance
    def initialize( m_view_name )
      
      # Holds the view name to render once the execution is complete
      @view_name = m_view_name
      
      # Tells the framework that no method definition is required for
      # this step type
      @definition_required = false
  
    end
  
  
  
  
    # This method is required by the ActionFlow::Base and will be called
    # once it relays the execution to this step instance
    def execute(*args)
    
      # Verify if the controller answers to the @view_name value
      if args[0].respond_to? lookup_method_to_call(@view_name)
      
        # The controller defines a method with the same name as @view_name.
        # Kewl! A 'someone else problem' !!!
        
        # Launch execution
        result = args[0].send( lookup_method_to_call(@view_name) )
          
      else
      
        # Do we have to do everything here? lazy user...
      
        # Render something but only if the user hasn't
        # defined a custom render block.
        args[0].send :render, :action => lookup_method_to_call(@view_name) unless renders.has_key?('render')
        
        # Return the :render event
        result = ActionFlow::Event.new(:render)
      
      end
      
      
      
      # Verify if we have to overide the render result.
      # Execute if necessary.
      # Also validate thet the return type is an event, or let go and it will
      # crash as soon as execution completes anyways...
      if result.kind_of?(ActionFlow::Event) && renders.has_key?(result.name)
      
        # Execute the render block
        return args[0].instance_eval( &renders.fetch( result.name ) )  
        
      end
        
                
      result
         
  
    end
    
    
    
    
    # Used to override the render action to be taken by the step.
    # The render result defined here overrides the one defined in the step
    # definition.
    # Use it as :
    #
    #  class Controller < ActionFlow::Base
    #  
    #    def initialize
    #  
    #      render_override [:some_event_name, :some_other_event_name] do
    #        render(:action => :whatever )
    #      end
    #  
    #    end
    #  
    #  end
    def to_render( *events, &block )
    
      # Make sure we have a block as a parameter
      raise(ActionFlow::ActionFlowError.new, "The renders instruction takes a block as a parameter. Use the 'do' format. See API.") unless block_given?
      
      # Iterate over the events to map
      events.each do |name|
      
        # Associate each event name with the received block
        renders.store name.to_s, block
        
      end
      
    end
    
    
    
    
    
    private
    
      # Returns the mapped rendering overrides hash.
      def renders
          
        @_renders ||= {}
            
      end

  end


end

# Let's create the view_step definition inside the ActionFlow::Base
# controller class
ActionFlow::Base.class_eval do

protected
  
  # Called to define a step into a flow. Example of usage :
  # 
  #  view_step :view_name do
  #    on :success => :another_step
  #    on :back => :yet_another_step
  #  end
  # 
  # See the ViewStep class documentation for more options.
  #
  def view_step(*view_name, &block)
  
    # Instanciate a ViewStep object if symbol or string received
    view_name.each do |name|
      
      step = ActionFlow::ViewStep.new(name.to_s) 
      
      # Register this step in the flow repository
      register name.to_s, step
      
      # Execute the config block
      step.instance_eval(&block) if block_given?
      
    end
    
  end
  

end