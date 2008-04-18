module AquaticSitesHelper
  def create_bounds(extent)
    coords = extent.match( /\((.*)\)/ )[1]
    box = coords.split(',').collect{ |coord| coord.split(' ').collect{ |num| num.to_f } }
    GLatLngBounds.new(GLatLng.new(box[0].reverse), GLatLng.new(box[1].reverse)).create
  end
end
