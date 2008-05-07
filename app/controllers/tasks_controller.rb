class TasksController < ApplicationController
  def index
    @tasks = [
      Task.new(:title => 'Select Site', :controller => 'aquatic_sites', :action => 'index'),
      Task.new(:title => 'Enter Measurements', :controller => 'test', :action => 'fail'),
      Task.new(:title => 'Another Step', :controller => 'test', :action => 'fail')
    ]
    @tasks.each_index do |i|
      t = @tasks[i]
      t.id = i
      t.position = i + 1
      t.url = url_for(:controller => t.controller, :action => t.action)
    end
  end
end
