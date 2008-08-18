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

# This module adds helper methods to ActionFlow controllers. See each method
# for a complete description of their function.
module ActionFlow::BaseHelper
  
  

  
  # Creates a submit button to send the parent form to an ActionFlow controller.
  # The options array takes the same values as the standard Rails submit_tag.
  def flow_submit_tag( value="Submit", event_name='', options={} )
    
    # Convert keys to strings
    options.stringify_keys!
  
    # We can't use the disable_with option since disabling the button will
    # prevent some browsers from sending the submit button name along
    # with the form data. We need this button to send the event name.
    options.delete("disable_with")
    
    # Generate the tag
    tag :input, { "type" => "submit", 
      "name" => "#{ActionFlow::Base.event_input_name_prefix}#{ActionFlow::Base.event_prefix}#{event_name}", 
      "value" => value }.update(options.stringify_keys)
    
  end
  
  
  
  
  
  
  # Creates a link to send an event to an ActionFlow controller.
  # The method takes all the standard Rails link_to parameters
  # but needs one more : the event name to return.
  def flow_link_to(name, event_name='', options = {}, html_options = nil, *parameters_for_method_reference)
  
    # Delete the action and controller definition
    options.delete :action
    options.delete :controller
  
    # Specify the 'index' action
    options[:action] = :index
    
    # Add the flow key to the url
    options[ActionFlow::Base.flow_execution_key_id] = @flow_id
        
    # Add the event name
    options[ActionFlow::Base.event_input_name_prefix + ActionFlow::Base.event_prefix + event_name.to_s] = ActionFlow::Base.event_prefix + event_name.to_s
    
    # Call the standard link_to helper
    link_to name, options, html_options, *parameters_for_method_reference 
  
  end
  
  
  
  
  
  
  # Creates a form tag to send data to the ActionFlow controller.
  # Takes the same parameters as Rail's form_tag, but adds the flow
  # exec key hidden input. You can either declare it as a returning 
  # function :
  #
  #  <%= flow_form_tag %>
  #
  # or give it a block :
  #
  #  <% flow_form_tag do |form| %>
  #
  # See end_flow_form_tag to close the first use case.
  def flow_form_tag( options={}, &block )
    
    # Init the HTML subhash if required
    options[:html] ||= {}
    
    # Remove the action html parameter
    options[:html].delete( :action )
    
    # There are two use cases.
    #
    # 1. The user has passed a block
    #      We have to extend the block to add our controls
    #
    # 2. The user hasn't passed a block
    #      We add our inputs at the end of the returned string
    #    
    if block_given?
    
      # Okay, here's the strategy. We create a 'file' variable which calls all
      # necessary methods. Then, we tell Rails to evaluate all this while binding
      # the correct Ruby context to the new block.
      # Thanks a million to Guy Nador at http://devblog.famundo.com/articles/2007/03/28/lost-in-binding-adventures-in-ruby-metaprogramming
      # for this hack.
      
      @res = <<-EOF
      
        #{form_tag( url_for( :action => 'index' ), options[:html] )}
        
          
          #{capture(&block)}
        
          
	  #{tag( 'input', { :type => :hidden, :name => ActionFlow::Base.flow_execution_key_id, :value => @flow_id } )}
	
        #{end_form_tag}
        
      EOF
      
      
      # Finally, launch execution.
      eval '_erbout.concat @res', block
      
    
    else
    
      # Looks like the user didn't pass a block, it's more simple like that.
      # We just concatenate our stuff at the end of the form_tag call
      result = form_tag( url_for( :action => 'index' ), options[:html] )
      
      # Add the flow key input
      result << tag( 'input', { :type => :hidden, :name => ActionFlow::Base.flow_execution_key_id, :value => @flow_id } )
          	
      # Add the event input
      #result << tag( 'input', { :type => :hidden, :name => ActionFlow::Base.event_input_name, :id => ActionFlow::Base.event_input_name, :value => '' } )
      
      return result
    
    end
    
    
  end
  
  
  
  
  
  # Allows the ActionFlow framework to use AJAX form submission.
  # Takes all the same parameters as the standard Rails form_remote_tag
  # but alters the options hash to force the 'index' action to be called.
  def flow_form_remote_tag( options = {}, &block )

    # I don't know why to do this, they do it in form_remote_tag
    # and there's no documentation nor comments available... nice going.
    options[:form] = true
    
    # Init the options hash
    options[:html] ||= {}
    options[:url] ||= {}
    
    # Alter the options to change the destination url so that it points to
    # the index action
    options[:url][:action] = :index
    options[:action] = :index
    
    # Alter the onsubmit event to create an ajax form
    options[:html][:onsubmit] = 
      (options[:html][:onsubmit] ? options[:html][:onsubmit] + "; " : "") + 
      "#{remote_function(options)}; return false;"
  
    # Call the standard flow_form_tag to do it's job
    flow_form_tag( options, &block )
  
  end
  
  
  
  # Allows the ActionFlow framework to use AJAX form submission.
  # Takes all the same parameters as the standard Rails form_remote_tag, but adds
  # the event name and flow id to the URL to return to the ActionFlow controller.
  # The URL is also overridden to point to the 'index' action.
  def flow_link_to_remote( name, event, options = {}, html_options = {} )
    
    # Alter the options to change the destination url so that it points to
    # the index action
    options[:url] ||= {}
    options[:url][:action] = :index
    options[:action] = :index
    
    # Add the flow key to the url
    options[:url][ActionFlow::Base.flow_execution_key_id] = @flow_id
    
    # Add the event name
    options[:url][ActionFlow::Base.event_input_name_prefix + ActionFlow::Base.event_prefix + event.to_s] = ActionFlow::Base.event_prefix + event.to_s
    
    # Call the standard ajax link creation method
    link_to_function(name, remote_function(options), html_options)
    
  end
  
  
  
  
  # Alias for Rails standard end_form_tag
  def end_flow_form_tag
    end_form_tag
  end
  
  
end
