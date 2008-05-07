class Waterbody < ActiveRecord::Base
  has_many :aquatic_sites
  belongs_to :watershed, :foreign_key => 'drainage_code'
  
  def to_label
    self.name
  end
  
  def self.import_from_datawarehouse(attributes)
    waterbody = Waterbody.new
    waterbody.id = attributes['waterbodyid']
    waterbody.drainage_code = attributes['drainagecd']
    waterbody.name = attributes['waterbodyname']
    waterbody.abbrev_name = attributes['waterbodyname_abrev']
    waterbody.alt_name = attributes['waterbodyname_alt']
    waterbody.waterbody_type = attributes['waterbodytypecd']
    waterbody.waterbody_complex_id = attributes['waterbodycomplexid']
    waterbody.surveyed = attributes['surveyed_ind'] == 'Y' ? true : false
    waterbody.flows_into_waterbody_id = attributes['flowsintowaterbodyid']
    waterbody.flows_into_waterbody_name = attributes['flowsintowaterbodyname']
    waterbody.flows_into_watershed = attributes['flowintodrainagecd']
    waterbody.date_entered = attributes['dateentered']
    waterbody.date_modified = attributes['datemodified']
    waterbody.save(false)
  end
end
