class ChangeSampleCollectionMethodCdColumnToString < ActiveRecord::Migration
  def self.up
    change_column "TblSample", "samplecollectionmethodcd", :string
  end

  def self.down
    change_column "TblSample", "samplecollectionmethodcd", :integer
  end
end
