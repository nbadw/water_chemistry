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

  # This class allows the controllers to create action steps. Action steps
  # do nothing but call a method defined in the controller and then route
  # the flow according to it's events mapping.
  # 
  # == Simple usage
  # 
  #  action_step :action_name do
  #    on :success => :another_step
  #    on :back => :yet_another_step
  #  end
  # 
  # The method identified by :action_name will simply be called and then the 
  # flow will be routed to either another_step or yet_another_step steps.
  #
  # One could also use the action_step instruction to batch define action
  # steps. Simply call the action_step instruction and give it a comma separated
  # list of step names.
  #
  #  action_step :first_step, :second_step do
  #    (...)
  #  end
  #
  # == Inherited instructions
  #
  # The ViewStep class inherits all the standard step methods defined in FlowStep class. 
  # 
  # 
  class ActionStep < ActionFlow::FlowStep


    # Holds the view name to render once the execution is complete
    @action_name



    # Initializes the instance
    def initialize( m_action_name )

      @action_name = m_action_name

    end




    # This method is required by the ActionFlow::Base and will be called
    # once it relays the execution to this step instance
    def execute(*args)

      # Verify if the controller answers to the @action_name value
      raise ActionFlowError, "The action step #{@action_name} is not defined in your controller." unless args[0].respond_to? lookup_method_to_call(@action_name)
    
      # The controller defines a method with the same name as @action_name.
      # Kewl! A 'someone else problem' !!!
      return args[0].send( lookup_method_to_call( @action_name ) )
  
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
  # See the ActionStep class documentation for more options.
  # 
  def action_step(*action_name, &block)

    # Instanciate a ViewStep object if symbol or string received
    action_name.each do |name|
          
      step = ActionFlow::ActionStep.new(name.to_s) 
          
      # Register this step in the flow repository
      register name.to_s, step
          
      # Execute the config block
      step.instance_eval(&block) if block_given?
          
    end

  end

end