# puts "executing delimited.ctl"

source :in, {
  :file => 'data/delimited.txt',
  :parser => :delimited
}, 
[ 
  :first_name,
  :last_name,
  :ssn
]

transform :ssn, :sha1
transform(:ssn){ |v| v[0,24] }

destination :out, {
  :type => :database,
  :target => :data_warehouse,
  :database => 'etl_unittest',
  :table => 'people',
},
{
  :order => [:first_name, :last_name, :ssn]
}