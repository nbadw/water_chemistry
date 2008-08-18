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

  
  
  
  # Superclass used to raise errors from within the ActionFlow framework.
  class ActionFlowError < StandardError
  end
  
  
  
  # Superclass used to raise errors from within the ActionFlow framework
  # when no flow corresponding to a given key can be found.
  class NoSuchFlowError < ActionFlowError
  end
  
  
  
  # This error class allows plugins to interrupt a flow execution and substitute
  # it's execution result by a given Proc object.
  #
  # Example...
  # 
  #  my_block = proc { render 'test' }
  #  raise( PluginInterruptionError.new( my_block ), "Plugin Interruption..." ) 
  #
  # In this example, the flow execution chain would be halted and the block
  # passed as a contructor argument would be executed. The Proc code will
  # be executed on the current controller object instance via Ruby's
  # instance_eval mechanism.
  #
  class PluginInterruptionError < ActionFlowError
  
    # Constructor used to create this error type.
    # Pass a Proc object to be executed upon the rescue
    # of a PluginInterruptionError exception.
    def initialize(&block)
    
      @_block = block
    
    end
    
    # Getter method to obtain the Proc object associated
    # to this PluginInterruptionError instance.
    def block
      @_block
    end
    
    private
    
    # Declaration of a private constructor to prevent initialization
    # without the block parameter
    def initialize
    end
    
  end
  
end