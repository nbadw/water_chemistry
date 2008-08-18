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
  
  
  # This class adds a couple validations before creating a new flow.
  class Controller < ActionFlow::Plugin
  
    # Listen to the 'before_new_flow' internal event
    self.listen :before_new_flow
  
      
      
      
    # Method to override in a plugin subclass. This method will be called
    # when a controller encounters one of it's internal events
    def self::notify( system_event)
             
      # Make sure there's a start_step defined
      raise (ActionFlowError.new, "Your controller must declare a start step name. Use 'start_step :step_name' and define this step in the mapping.") if controller.instance_variable_get("@_start_step").nil?
                
      # Make sure there's an end_step defined
      raise (ActionFlowError.new, "Your controller must declare an end step name. Use 'end_step :step_name' and define this step in the mapping. I suggest using a view step which could redirect if you don't want to create a 'thank you' screen.") if controller.instance_variable_get("@_end_step").nil?
      
      # Resume filter chain
      resume
            
    end
  
  
  
  end
  
  
  
  ActionFlow::Base.class_eval do
  
    protected
    
      # Allows the controller to handle errors which were not handled by
      # the steps themselves.
      def upon
      end
        
      
      
      
      
      
      # Holds the methods to call upon errors
      def handlers
        @handlers ||= {}
      end
      
      
  end
  
  
end