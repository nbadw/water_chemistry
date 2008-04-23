class Demo::ApplicationController < ApplicationController  
  before_filter :not_logged_in_required 
  
  def login
    render :layout => false
  end

  def activities
    logger.debug "displaying activities demo screen"
    lorem_ipsum = %q(Lorem ipsum dolor sit amet, consectetuer adipiscing elit. 
Duis consequat, lacus eu molestie sagittis, est nunc facilisis nisi, eu dapibus 
elit enim et quam. Pellentesque justo mauris, congue eu, ultricies quis, 
consequat mattis, purus. Cras suscipit fermentum erat. Nam in purus at enim 
ultrices vehicula. Aliquam a ligula. Ut vel dolor.)
    @activities = [
      Activity.new(:title => 'Demo Activity #1', :desc => lorem_ipsum,
        :author => 'Colin Casey', :updated_at => DateTime.now, :type => 'WaterChemistry'),
      Activity.new(:title => 'Demo Activity #2', :desc => lorem_ipsum,
        :author => 'Colin Casey', :updated_at => DateTime.now, :type => 'Electrofishing'),
      Activity.new(:title => 'Demo Activity #3', :desc => lorem_ipsum,
        :author => 'Colin Casey', :updated_at => DateTime.now, :type => 'WaterChemistry')
    ]
  end

  def activity
  end

  def tasks
  end

  def choose_site
  end

  def enter_measurements
  end
end
