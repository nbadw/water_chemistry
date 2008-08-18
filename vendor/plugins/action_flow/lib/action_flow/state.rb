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


  
  
  # The State module is simply a method inclusion mechanism which allows
  # the user to store data relevant to a flow state. It is used exactly like
  # the 'session' attribute of the ActionController::Base. See the ActionFlow
  # wiki for more details.
  
ActionFlow::Base.class_eval do


  # TODO Send the state method to the ActionViews

  protected

    
    # Returns the state data hash
    def state
      
      return session[ flow_session_name ].fetch( state_session_name )
      
    end
    
    # Changes the state hash for another one
    def state=(hash)
      session[ flow_session_name ].store( state_session_name, hash )
      return state
    end
    
    # Does the sasme as state(k,v)
    #def []=(k, v)
    #  return session[ flow_session_name ].fetch( state_session_name ).store( k.to_s, v )
    #end
    
    
    # Does the same as state(k)
    #def [](k)
      
    #  return session[ flow_session_name ].fetch( state_session_name ).fetch( k )
    #  
    #end
    
    
    # Adds ActionView helper methods
    def self.included(base)
      base.send :helper_method, :state
    end
    

end
  

