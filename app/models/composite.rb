class Composite < ActiveRecord::Base   
  def self.columns
    @columns = []
        
    @mappings = {
      :id => { :model => 'ModelOne', :column => 'id' },
      :name_one => { :model => 'ModelOne', :column => 'name'},
      :name_two => { :model => 'ModelTwo', :column => 'name'},
      :test_one => { :model => 'ModelOne', :column => 'column_one'},
      :test_two => { :model => 'ModelTwo', :column => 'column_two'}
    }
    
    @mappings.each do |name, mapping|
      ar_klass = mapping[:model].constantize
      column = ar_klass.columns_hash[mapping[:column]]
      @columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, column.default, column.type, column.null)      
    end
    
    @columns
  end
  
  def self.count(*args)
    options = args.extract_options!
    options[:order] = nil
    options[:include] ||= []
    options[:include] << :model_two
    ModelOne.count(args.first, options)    
  end
  
  def self.find(*args)
    options = args.extract_options!
    options[:order] = nil
    options[:include] ||= []
    options[:include] << :model_two
    results = ModelOne.find(args.first, options)
    records = []
    if results
      [results].flatten.each do |result|
        record = self.new
        record.model_one = result
        record.model_two = result.model_two
        records << record
      end
    end    
    
    case args.first
      when :first then records[0]
      when :last  then records[0]
      when :all   then records
      else             records[0]
    end
  end
  
  attr_accessor :model_one, :model_two
  
  def id
    model_one.id
  end
  
  def name_one
    model_one.name
  end
  
  def name_two
    model_two.name
  end
  
  def test_one
    model_one.column_one
  end
  
  def test_two
    model_two.column_two
  end
end
