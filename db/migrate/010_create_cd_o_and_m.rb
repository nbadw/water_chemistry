class CreateCdOAndM < ActiveRecord::Migration
  def self.up
    create_table "cdOandM", :primary_key => "oandmcd" do |t|
      t.string  "oandm_type",        :limit => 32
      t.string  "oandm_category",    :limit => 80
      t.string  "oandm_group",       :limit => 100
      t.string  "oandm_parameter",   :limit => 100
      t.string  "oandm_parametercd", :limit => 60
      t.boolean "oandm_valuesind",                  :null => false
    end
  end

  def self.down
    drop_table "cdOandM"
  end
end
