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

  # This class is used by steps to return an event descriptor to
  # the ActiveFlow framework.
  # 
  # Use it as :
  # 
  #  def step_definition
  #  
  #    (...)
  #  
  #    ActionFlow::Event.new(:success)
  #  
  #  end
  #  
  # There is also a sugar method included in ActionFlow::Base which simplifies
  # the event returning process.
  # 
  #  def step_definition
  #  
  #    (...)
  #  
  #    event :success
  #  
  #  end
  # 
  class Event
  
    attr_accessor :name

    # Initializes the class instance
    def initialize(m_event_name)

      # The name of the event returned
      @name = m_event_name.to_s

    end
  
  end
  
  # The SystemEvent class is a subclass of ActionFlow::Event and is used
  # internally to trigger plugins execution.
  # Since the plugins are not activated yet, SystemEvents are not used.
  class SystemEvent < ActionFlow::Event
  
    attr_accessor :controller, :flow_data
    
    # Initializes the class instance
    def initialize(m_event_name, m_controller, m_flow_data)
    
      # Super controller
      super m_event_name
    
      # Set values
      @controller, @flow_data = m_controller, m_flow_data
    
    end
  
  end
  
  
end