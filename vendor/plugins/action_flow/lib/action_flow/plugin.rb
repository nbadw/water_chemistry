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
  
  # This is a squeletton class to create plugins to the ActionFlow framework.
  # Any plugin MUST me a subclass of this superclass.
  #
  # Plugins are still under development so they are not activated yet.
  class Plugin
  
    # Method called by a controller when a system event for which this
    # plugin is registered is reached.
    def self::call(system_event)
      
      # Execute the plugin
      return_value = self.notify
      
      # Make sure we got a system event back
      raise(ActionFlowError.new, "One of your plugin didn't return a system event, as required. The culprit is : " + self.inspect ) unless return_value.kind_of? ActionFlow::SystemEvent
      
      # Act accordingly
      return return_value
          
      
    end
  
  
    protected
  
    # Method to override in a plugin subclass. This method will be called
    # when a controller encounters one of it's internal events
    def self::notify( internal_event_name, controller, flow_data, request, response, session)
      
      raise(ActionFlowError.new, "One of your plugins didn't override the notify method. The culprit is : " + self.inspect)
      
    end
    
    
    protected
    
      # Allows a plugin to register itself as a listener of the ActionFlow::Base class
      # internal events.
      def self::listen(*event_names)
      
        event_names.each do |name|
          ActionFlow::Base.listen name.to_s, self
        end
        
      end
      
      # Tells the notifier that this filter has done it's job and other filters
      # may do whatever the see fit.
      def self::resume
        ActionFlow::SystemEvent
  
  end
  
  
  
  
  
end