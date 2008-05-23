class CreateAquaticSiteAgencyUses < ActiveRecord::Migration
  def self.up
    create_table :aquatic_site_agency_uses do |t|
      t.integer   :aquatic_site_id
      t.integer   :aquatic_activity_code
      t.string    :aquatic_site_type
      t.string    :agency_code
      t.string    :agency_site_id
      t.string    :start_year
      t.string    :end_year
      t.string    :years_active
      t.timestamp :entered_at
      t.timestamp :incorporated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :aquatic_site_agency_uses
  end
end
