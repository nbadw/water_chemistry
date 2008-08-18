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

  # This class is used by the ActionFlow framework to generate the
  # FlowExecutionKey which uniquely identifies a user flow execution.
  #
  # It creates random alphanumeric strings with upper-case characters.
  class RandomGenerator

    # Defines which characters are used to generate random strings
    Chars = ("A".."Z").to_a + ("0".."9").to_a
  
    # Generates a random string of the given length. By default, it's
    # 64 characters long.
    def self::random_string(len = 64)
      
      # Initial string
      string = ""
    
      # Pick characters at random
      1.upto(len) { |i| string << Chars[rand(Chars.size-1)] }
    
      # Return the resulting string
      return string.to_s
    
    end

  end
end