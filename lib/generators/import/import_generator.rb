class ImportGenerator < Rails::Generator::Base
  attr_accessor :name

  def initialize(*runtime_args)
    super(*runtime_args)
    if args[0].nil? 
      puts banner
    else
      @name = args[0]
    end
  end
  
  def manifest
    record do |m|
      if @name 
        m.directory 'db/etl/scripts/control'
        m.template 'import.rhtml', File.join('db/etl/scripts/control', "import_#{@name}.ctl")
      end
    end
  end
  
  protected 
  
  def banner
    IO.read File.expand_path(File.join(File.dirname(__FILE__), 'USAGE')) 
  end
end
