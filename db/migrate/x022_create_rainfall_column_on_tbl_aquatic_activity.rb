class CreateRainfallColumnOnTblAquaticActivity < ActiveRecord::Migration
  def self.up
    add_column "tblAquaticActivity", "rainfall_last24", :string
  end

  def self.down
    remove_column "tblAquaticActivity", "rainfall_last24"
  end
end
