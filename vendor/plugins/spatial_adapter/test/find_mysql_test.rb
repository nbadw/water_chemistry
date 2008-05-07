$:.unshift(File.dirname(__FILE__))

require 'test/unit'
require 'common/common_mysql'

class Park < ActiveRecord::Base
end

class FindMysqlTest < Test::Unit::TestCase
   
  def setup
    ActiveRecord::Schema.define() do
      create_table "parks", :options => "ENGINE=MyISAM" , :force => true do |t|
        t.column "data" , :string, :limit => 100
        t.column "geom", :point,:null=>false
      end
      add_index "parks","geom",:spatial=>true,:name => "example_spatial_index"
    end

    pt = Park.new(:data => "Point1", :geom => Point.from_x_y(1.2,0.75))
    assert(pt.save)

    pt = Park.new(:data => "Point2",:geom => Point.from_x_y(0.6,1.3))
    assert(pt.save)

    pt = Park.new(:data => "Point3", :geom => Point.from_x_y(2.5,2))
    assert(pt.save)
  end

  def test_find_by_geom_column
    #the linestring bbox is [0 0,2 2]
    pts = Park.find_all_by_geom(LineString.from_coordinates([[0,0],[2,2]]))
    assert(pts)
    assert(pts.is_a?(Array))
    assert_equal(2,pts.length)
    assert(pts[0].data == "Point1" ||pts[1].data == "Point1" )
    assert(pts[0].data == "Point2" ||pts[1].data == "Point2" )

    #the linestring bbox is [2.49 1.99,2.51 2.01]
    pts = Park.find_all_by_geom(LineString.from_coordinates([[2.49,1.99],[2.51,2.01]]))
    assert(pts)
    assert(pts.is_a?(Array))
    assert_equal(1,pts.length)
    assert(pts[0].data == "Point3")
    
  end

  def test_find_by_geom_column_bbox_condition
    pts = Park.find_all_by_geom([[0,0],[2,2]])
    assert(pts)
    assert(pts.is_a?(Array))
    assert_equal(2,pts.length)
    assert(pts[0].data == "Point1" ||pts[1].data == "Point1" )
    assert(pts[0].data == "Point2" ||pts[1].data == "Point2" )

    pts = Park.find_all_by_geom([[2.49,1.99],[2.51,2.01]])
    assert(pts)
    assert(pts.is_a?(Array))
    assert_equal(1,pts.length)
    assert(pts[0].data == "Point3")
  end
  

end
