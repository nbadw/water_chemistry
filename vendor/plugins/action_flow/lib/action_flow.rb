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

# Load the basic stuff
require 'action_flow/exceptions'
require 'action_flow/base'
require 'action_flow/session_handler'
require 'action_flow/state'
require 'action_flow/event'
require 'action_flow/random_generator'
require 'action_flow/action_step'
require 'action_flow/view_step'
#require 'action_flow/plugin'


# Reserve the render user event for the Base class.
ActionFlow::Base.reserve_event :render



# Load the plugins
# Plugins are just an experiment for now, so I've deactivated them.
# You can reactivate them
#Dir[File.dirname(__FILE__) + '/plugins/*.rb'].each do |file|
# require file
#end
  

