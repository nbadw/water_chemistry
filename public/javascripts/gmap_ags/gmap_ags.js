/*!
 * Google Maps Adapter to ArcGIS Server Cache
 * @Author Nianwei Liu [nianwei at gmail.com]
 * @Date 2008-03-27
 */
/**
 * Reference: 
 * http://pubs.er.usgs.gov/djvu/PP/PP_1395.pdf
 * http://www.posc.org/Epicentre.2_2/DataModel/ExamplesofUsage/eu_cs34.html
 * Each projection class is used to convert latlng from/to real world coord.
 * Should implemented three methods:forward, inverse and circum 
 */
/*==========start LCC code ===============*/
/**
 * Create a Lambert Conic Conformal Projection. 
 * @param {Js Literal}. It should contain the following properties:
 * -semi_major:  ellipsoidal semi-major axis 
 * -unit: meters per unit
 * -inverse_flattening: inverse of flattening of the ellipsoid where 1/f = a/(a - b)
 * -standard_parallel_1: phi1 latitude of the first standard parallel
 * -standard_parallel_2: phi2 latitude of the second standard parallel
 * -latitude_of_origin: phiF latitude of the false origin
 * -central_meridian: lamdaF longitude of the false origin  (with respect to the prime meridian)
 * -false_easting:FE false easting, the Eastings value assigned to the natural origin 
 * -false_northing: FN false northing, the Northings value assigned to the natural origin 
 */
function LCC(params){
    /*=========parameters=================*/
    //note: the default values are for NAD83 State Plane North Carolina Feet
    if (!params||params==null) params={};
    this.name=params.name||"LCC";
    var _a = (params.semi_major ||6378137.0 )/(params.unit||0.3048006096012192);
    var _f_i=params.inverse_flattening||298.257222101;//this.
    var _phi1 = (params.standard_parallel_1||34.33333333333334) * (Math.PI / 180);
    var _phi2 = (params.standard_parallel_2||36.16666666666666) * (Math.PI / 180);
    var _phiF = (params.latitude_of_origin||33.75) * (Math.PI / 180);
    var _lamdaF = (params.central_meridian||-79.0)* (Math.PI / 180);
    var _FE = params.false_easting||2000000.002616666;//this.
    var _FN = params.false_northing||0.0;//this.
    /*========== functions to calc values, potentially can move outside as static methods=========*/
    var calc_m = function(phi, es){
        var sinphi = Math.sin(phi);
        return Math.cos(phi) / Math.sqrt(1 - es * sinphi * sinphi);
    };
    var calc_t = function(phi, e){
        var esinphi = e * Math.sin(phi);
        return Math.tan(Math.PI / 4 - phi / 2) / Math.pow((1 - esinphi) / (1 + esinphi), e / 2);
    };
    var calc_r = function(a, F, t, n){
        return a * F * Math.pow(t, n)
    };
    var calc_phi = function(t_i, e, phi){
        var esinphi = e * Math.sin(phi);
        return Math.PI / 2 - 2 * Math.atan(t_i * Math.pow((1 - esinphi) / (1 + esinphi), e / 2));
    };
    
    var solve_phi = function(t_i, e, init){
        // iteration
        var i = 0;
        var phi = init;
        var newphi = calc_phi(t_i, e, phi);//this.
        while (Math.abs(newphi - phi) > 0.000000001 && i < 10) {
            i++;
            phi = newphi;
            newphi = calc_phi(t_i, e, phi);//this.
        }
        return newphi;
    }

/*=========shared, not point specific params or intermediate values========*/
    var _f = 1.0 /_f_i;//this.
    /*e: eccentricity of the ellipsoid where e^2 = 2f - f^2 */
    var _es = 2 * _f - _f * _f;
    var _e = Math.sqrt(_es);
    var _m1 = calc_m(_phi1, _es);//this.
    var _m2 = calc_m(_phi2, _es);//this.
    var _tF = calc_t(_phiF, _e);//this.
    var _t1 = calc_t(_phi1, _e);//this.
    var _t2 = calc_t(_phi2, _e);//this.
    var _n = Math.log(_m1 / _m2) / Math.log(_t1 / _t2);
    var _F = _m1 / (_n * Math.pow(_t1, _n));
    var _rF = calc_r(_a, _F, _tF, _n);//this.
    
    this.forward = function(latlng){
        var phi = latlng[1] * (Math.PI / 180);
        var lamda = latlng[0] * (Math.PI / 180);
        var t = calc_t(phi, _e);//this.
        var r = calc_r(_a, _F, t, _n);//this.
        var theta = _n * (lamda - _lamdaF);
        var E = _FE + r * Math.sin(theta);
        var N = _FN + _rF - r * Math.cos(theta);
        return [E, N];
    };
    this.inverse = function(xy){
        var E = xy[0];
        var N = xy[1];
        var theta_i = Math.atan((E - _FE) / (_rF - (N - _FN)));
        var r_i = (_n > 0 ? 1 : -1) * Math.sqrt((E - _FE) * (E - _FE) + (_rF - (N - _FN)) * (_rF - (N - _FN)));
        var t_i = Math.pow((r_i / (_a * _F)), 1 / _n);
        var phi = solve_phi(t_i, _e, 0);//this.
        var lamda = theta_i / _n + _lamdaF;
        return [lamda * (180 / Math.PI), phi * (180 / Math.PI)];
    };
    this.circum = function(){
        return Math.PI * 2 * _a;
    };
    
}

/*==========end LCC code ===============*/

/**
 * Reference: 
 * http://pubs.er.usgs.gov/djvu/PP/PP_1395.pdf
 * http://www.posc.org/Epicentre.2_2/DataModel/ExamplesofUsage/eu_cs34.html
 * Each projection class is used to convert latlng from/to real world coord.
 * Should implemented three methods:forward, inverse and circum 
 */
/*==========start TMERC code ===============*/
/**
 * Create a Transverse Mercator Projection. 
 * @param {Js Literal}. It should contain the following properties:
 * -semi_major:  ellipsoidal semi-major axis 
 * -unit: meters per unit
 * -inverse_flattening: inverse of flattening of the ellipsoid where 1/f = a/(a - b)
 * -Scale Factor: scale factor at origin
 * -latitude_of_origin: phiF latitude of the false origin
 * -central_meridian: lamdaF longitude of the false origin  (with respect to the prime meridian)
 * -false_easting:FE false easting, the Eastings value assigned to the natural origin 
 * -false_northing: FN false northing, the Northings value assigned to the natural origin 
 */
function TMERC(params){
   if (!params||params==null) params={};
    this.name=params.name||"TMERC";
   //note: default value are State Plane NAD83 Georgia West Feet.
    var _a = (params.semi_major ||6378137.0 )/(params.unit||0.3048006096012192);//this.
    var _f_i=params.inverse_flattening||298.257222101;//this.
    var _k0=params.scale_factor||0.9999;
    var _phiF = (params.latitude_of_origin||30.0) * (Math.PI / 180);//this.
    var _lamdaF = (params.central_meridian||-84.16666666666667)* (Math.PI / 180);//this.
    var _FE = params.false_easting||2296583.333333333;//this.
    var _FN = params.false_northing||0.0;//this.
    var _f = 1.0 /_f_i;//this.
    /*e: eccentricity of the ellipsoid where e^2 = 2f - f^2 */
    var _es = 2 * _f - _f * _f;
    var _e = Math.sqrt(_es);
    /* e^4 */
    var _ep4 = _es * _es;
    /* e^6 */
    var _ep6=_ep4 * _es;
    /* e'  second eccentricity where e'^2 = e^2 / (1-e^2) */
    var _eas= _es/(1-_es);
   
    var calc_m = function (phi, a, es, ep4,ep6){
        return a * ((1-es/4-3*ep4/64-5*ep6/256) * phi - (3*es/8+3*ep4/32+45*ep6/1024)*Math.sin(2*phi) + (15 * ep4/256+45*ep6/1024)*Math.sin(4*phi)-(35*ep6/3072)*Math.sin(6*phi));
    }
    
    var _M0=calc_m(_phiF, _a, _es, _ep4, _ep6);

    this.forward = function(latlng){
        var phi = latlng[1] * (Math.PI / 180);
        var lamda = latlng[0] * (Math.PI / 180);
        var N= _a / Math.sqrt(1- _es * Math.pow(Math.sin(phi),2)); 
        var T = Math.pow(Math.tan(phi),2);
        var C= _eas * Math.pow(Math.cos(phi),2);
        var A = (lamda-_lamdaF) * Math.cos(phi);
        var M = calc_m(phi,_a, _es, _ep4, _ep6);
        var E = _FE + _k0* N * (A+(1-T+C)*Math.pow(A,3)/6+(5-18*T+T*T+72*C-58*_eas)*Math.pow(A,5)/120);
        var N = _FN + _k0*(M-_M0)+N * Math.tan(phi)* (A*A/2+(5-T+9*C+4*C*C)*Math.pow(A,4)/120+(61-58*T+T*T+600*C-330*_eas)*Math.pow(A,6)/720);
        return [E, N];
    };
    this.inverse = function(xy){
        var E = xy[0];
        var N = xy[1];
        var e1=(1-Math.sqrt(1-_es))/(1+Math.sqrt(1-_es));
        var M1=_M0+(N-_FN)/_k0;
        var mu1=M1/(_a*(1-_es/4-3*_ep4/64-5*_ep6/256));
        var phi1=mu1+(3*e1/2-27*Math.pow(e1,3)/32)*Math.sin(2*mu1)+(21*e1*e1/16-55*Math.pow(e1,4)/32)*Math.sin(4*mu1)+(151*Math.pow(e1,3)/6)*Math.sin(6*mu1)+(1097*Math.pow(e1,4)/512)*Math.sin(8*mu1);
        var C1=_eas * Math.pow(Math.cos(phi1),2);
        var T1=Math.pow(Math.tan(phi1),2);
        var N1=_a / Math.sqrt(1-_es * Math.pow(Math.sin(phi1),2));
        var R1=_a*(1-_es)/Math.pow((1-_es*Math.pow(Math.sin(phi1),2)),3/2);
        var D=(E-_FE)/(N1*_k0);
        var phi = phi1-(N1*Math.tan(phi1)/R1)*(D*D/2-(5+3*T1+10*C1-4*C1*C1-9*_eas)*Math.pow(D,4)/24+(61+90*T1+28*C1+45*T1*T1-252*_eas-3*C1*C1)*Math.pow(D,6)/720);
        var lamda = _lamdaF+(D-(1+2*T1+C1)*Math.pow(D,3)/6+(5-2*C1+28*T1-3*C1*C1+8*_eas+24*T1*T1)*Math.pow(D,5)/120)/Math.cos(phi1);
        return [lamda * (180 / Math.PI), phi * (180 / Math.PI)];
    };
    this.circum = function(){
        return Math.PI * 2 * _a;
    };
}
/*==========end TMERC code ===============*/

/*==========start GCS code ===============*/
/**
* This is a simple lat lng coordinate system. 
*/
function GCS(params){
if (!params||params==null) params={};
 this.name=params.name||"GCS";
  this.circum = function(){
    return 360.0;
  }
  this.forward = function(latlng){
    return latlng;
 };
  this.inverse = function(xy){
   return xy;
  };
}
/*==========end GCS code ===============*/



/*==========start  GMapCacheProjection code ==================*/ 
/**
 * This is a class that implements Google Map API's GProjection interface
 * It handles tile system transformation between pixel and latlng.
 * @param {js literal} params: tile system parameters.
 * it should contain the following properties:
 * -zoomOffset:The approximate offset between ArcGIS Cache's Level of Detail and Google Map's zoom Level.
 * -originalX: The tile orginal X
 * -originalY: The tile orginal Y
 * -projection: projection object
 * -resolution:array of resolution values (units/pixel) for each level
 * -bounds: (optional) {literal} object with minX, minY, maxX, maxY properties to set extent constraint.
 */
function GMapCacheProjection(params){
//note: default values are a customized set of zoom levels from 1:500000 to 0.5 ft/pixel
    if (!params||params == null) 
        params = {};
    this.zoomOffset = params.zoomOffset||10;
    this.originX = params.originX || 0;
    this.originY = params.originY || 2000000;// pixel Y increase downwards. 
    this.projection = params.projection||new LCC();
    this.resolutions = params.resolutions||[434.027777777778,
217.013888888889, 108.506944444444,  55.5555555555556,
 27.7777777777778, 13.8888888888889, 6.94444444444444, 
3.47222222222222,1.73611111111111,1,0.5] ; // units/pixel
    this.bounds = params.bounds||null;
}

GMapCacheProjection.prototype = new GProjection();
GMapCacheProjection.prototype.fromLatLngToPixel = function(latlng, zoom){
    if (latlng == null) 
        return null;
    var coords = this.projection.forward([latlng.lng(), latlng.lat()]);
    var zoomInx = zoom - this.zoomOffset;
    var x = Math.round((coords[0] - this.originX) / this.resolutions[zoomInx]);
    var y = Math.round((this.originY - coords[1]) / this.resolutions[zoomInx]);
    return new GPoint(x, y);
};
GMapCacheProjection.prototype.fromPixelToLatLng = function(pixel, zoom, unbound){
    if (pixel == null) 
        return null;
    var zoomInx = zoom - this.zoomOffset;
    var x = pixel.x * this.resolutions[zoomInx] + this.originX;
    var y = this.originY - pixel.y * this.resolutions[zoomInx];
    var geo = this.projection.inverse([x, y]);
    return new GLatLng(geo[1], geo[0]);
};

GMapCacheProjection.prototype.tileCheckRange = function(tile, zoom, tilesize){
    var b=this.bounds;
    if (!b||b==null)     return true;
    var zoomInx = zoom - this.zoomOffset;
    var minX = tile.x * tilesize * this.resolutions[zoomInx] + this.originX;
    var minY = this.originY - (tile.y + 1) * tilesize * this.resolutions[zoomInx];
    var maxX = (tile.x + 1) * tilesize * this.resolutions[zoomInx] + this.originX;
    var maxY = this.originY - tile.y * tilesize * this.resolutions[zoomInx];
    return ! (b.minX>maxX||b.maxX<minX||b.maxY<minY||b.minY>maxY);
};

// This is the X sizes in pixel of the earth under this projection.
GMapCacheProjection.prototype.getWrapWidth = function(zoom){
    var zoomInx = zoom - this.zoomOffset;
    return this.projection.circum() / this.resolutions[zoomInx];
}

// To realworld coordinates, not required for GProjection implementation
GMapCacheProjection.prototype.fromLatLngToCoords = function(latlng){
    var xy = this.projection.forward([latlng.lng(), latlng.lat()]);
    return new GPoint(xy[0], xy[1]);
};

GMapCacheProjection.prototype.fromCoordsToLatLng = function(coords){
    var geo = this.projection.inverse([coords.x, coords.y]);
    return new GLatLng(geo[1], geo[0]);
};
//==========end  GMapCacheProjection code ==================/ 

/**
 * This is a helper class to bridge Google Map API and ArcGIS Server
 * Map Cache. It uses the Map Cache Configuration file (conf.xml) path
 * and automatically read configuration and setup a GMapType.
 * @param {String} confUrl: The absolute path to conf.xml, without the host name
 *                 example: "/arcgiscache/MyMap/Layers/conf.xml". The path is subject
 *                 to javascript host cross domain scripting security constraint.
 * @param {Object} map of type GMap2, the map object to add ArcGIS map cache to.
 * @param {Object} opts, javascript literal. It can contain the following values:
 *                 -baseUrl: The base Url for each tiles, up to the zoom level part. 
 *                         Default to confUrl's path plus "_allLayers".
 *                 -name: the name of the GMapType to create. Default to the folder after
 *                         virtual directory's name, normally map service name. 
 *                 -all other option values availiable for GTileLayer and GMapType,
 *                        they will be passed into the constructors. 
 */
function GMapCacheAdapter(confUrl, map, opts){
   if (!opts||opts==null) opts={};
/**
 * Extract SubString from a String based on start and end string
 * @param {String} fullStr
 * @param {String} startStr
 * @param {String} endStr
 */
    var extractString=function(fullStr,startStr,endStr){
      var s = fullStr.indexOf(startStr);
      if (s == -1) return "";
      if (startStr == "") 
        s = 0;
      var e = fullStr.indexOf(endStr, s + startStr.length);
      if (e == -1 || endStr == "") 
        e = fullStr.length - 1;
    
      return fullStr.substring(s + startStr.length, e);
    };
/**
 * Extract child Node value based on tag name
 * @param {Node} node
 * @param {String} tag
 */
    var extractNode = function(node, tag){
        return node.getElementsByTagName(tag)[0].firstChild.nodeValue;
    };

/** create a projection from well-known-text
 *  example:
 * PROJCS["NAD_1927_StatePlane_Texas_South_Central_FIPS_4204",
 * GEOGCS["GCS_North_American_1927",
 * DATUM["D_North_American_1927",
 * SPHEROID["Clarke_1866",6378206.4,294.9786982]],
 * PRIMEM["Greenwich",0.0],
 * UNIT["Degree",0.0174532925199433]],
 * PROJECTION["Lambert_Conformal_Conic"],
 * PARAMETER["False_Easting",2000000.0],
 * PARAMETER["False_Northing",0.0],
 * PARAMETER["Central_Meridian",-99.0],
 * PARAMETER["Standard_Parallel_1",28.38333333333333],
 * PARAMETER["Standard_Parallel_2",30.28333333333334],
 * PARAMETER["Latitude_Of_Origin",27.83333333333333],
 * UNIT["Foot_US",0.3048006096012192]]
 */
    var createProjectionFromWKT= function(wkt){
        var params={};
        var prj = extractString(wkt,"PROJECTION[\"", "\"]");
        var spheroid = extractString(wkt,"SPHEROID[", "]").split(",");
        if (prj!=""){
            params.unit = parseFloat(extractString(extractString(wkt,"PROJECTION", ""),"UNIT[", "]").split(",")[1]);
            params.semi_major = parseFloat(spheroid[1]) ;
            params.inverse_flattening= parseFloat(spheroid[2]);
            params.latitude_of_origin=parseFloat(extractString(wkt,"\"Latitude_Of_Origin\",", "]"));
            params.central_meridian=parseFloat(extractString(wkt,"\"Central_Meridian\",", "]"));
            params.false_easting=parseFloat(extractString(wkt,"\"False_Easting\",", "]"));
            params.false_northing=parseFloat(extractString(wkt,"\"False_Northing\",", "]"));
        }
        switch (prj) {
            case "":
		        return new GCS(params);
            case "Lambert_Conformal_Conic":
                params.standard_parallel_1=parseFloat(extractString(wkt,"\"Standard_Parallel_1\",", "]"));
                params.standard_parallel_2=parseFloat(extractString(wkt,"\"Standard_Parallel_2\",", "]"));
 	            return new LCC(params);
		    case "Transverse_Mercator":
		        params.scale_factor=parseFloat(extracString(wkt,"\"Scale_Factor\",","]"));
                return new TMERC(params);
            // more implementations here.
            default:
                throw prj + "  not implemented yet";
        }
    };

// download configuration file from same host
    GDownloadUrl(confUrl,function(confxml,responseCode) {
      if (responseCode==200){

		var conf = GXml.parse(confxml);
	    var wkt = extractNode(conf, 'WKT');
		var prj=createProjectionFromWKT(wkt);
	    var params = {};
		params.projection=prj;
	    params.originX = parseFloat(extractNode(conf, 'X'));
	    params.originY = parseFloat(extractNode(conf, 'Y'));
	    var res = [];
	    var lods = conf.getElementsByTagName('LODInfo');
	    for (var i = 0; i < lods.length; i++) {
	        res.push(extractNode(lods[i], 'Resolution'));
	    }
	    params.resolutions = res;
	    params.zoomOffset = Math.floor(Math.log(prj.circum() / res[0] / 256) / Math.LN2+0.5);
		if (opts && opts.bounds) params.bounds=opts.bounds;
		
		var gprojection=new GMapCacheProjection(params);
		
	    var tileSize = parseInt(extractNode(conf, 'TileCols'));
	    var format = extractNode(conf, 'CacheTileFormat');
	    switch (format) {
	        case "JPEG":
	        case "JPG":
	            format = "jpg";
	            break;
	        case "PNG8":
	        case "PNG24":
	        case "PNG32":
	            format = "png";
	            break;
	    }
		var baseUrl=opts.baseUrl||confUrl.substring(0,confUrl.lastIndexOf("/"))+"/_allLayers";
		var mapName=opts.name||extractString(extractString(confUrl,"/",""),"/","/");

		var agsLayer=new GTileLayer(opts.copyright||"",params.zoomOffset, (params.zoomOffset+params.resolutions.length-1), opts);
	    agsLayer.getTileUrl = function(tile, zoom){
			var u = baseUrl + '/L' + ('00' + (zoom - params.zoomOffset).toString(10)).substring(('00' + (zoom - params.zoomOffset).toString(10)).length - 2) + '/R' + ('00000000' + tile.y.toString(16)).substring(('00000000' + tile.y.toString(16)).length - 8) + '/C' + ('00000000' + tile.x.toString(16)).substring(('00000000' + tile.x.toString(16)).length - 8) + '.' + format;
	 // GLog.write(u);		
			return u;
		}
		opts.tileSize=tileSize;
		var agsMap=new GMapType([agsLayer],gprojection,mapName,opts);
        map.addMapType(agsMap);
        // make the new map active map
        map.setMapType(agsMap);
      }
    });
    
    
}



 //===========Start MapImageOverlayer ===================================/
 // A MapImageOverlay is a simple overlay that cover the whole map with a map image.
function MapOverlay(url, bounds) {
  this.url= url;
  this.bounds=bounds;
}
MapOverlay.prototype = new GOverlay();

// Creates the DIV representing this rectangle.
MapOverlay.prototype.initialize = function(map) {
  var img=document.createElement("img");
  img.style.position = "absolute";
  map.getPane(G_MAP_MAP_PANE).appendChild(img);
  this.map_ = map;
  this.img_=img;
}

// Remove the main DIV from the map pane
MapOverlay.prototype.remove = function() {
  this.img_.parentNode.removeChild(this.img_);
}

// Copy our data to a new MapImageOverlay
MapOverlay.prototype.copy = function() {
  return new MapOverlay(this.url);
}

// Redraw the rectangle based on the current projection and zoom level
MapOverlay.prototype.redraw = function(force) {
  // We only need to redraw if the coordinate system has changed
  if (!force) return;
  var sw=this.bounds.getSouthWest();
  var ne=this.bounds.getNorthEast();
  var swpx = this.map_.fromLatLngToDivPixel(sw);
  var nepx = this.map_.fromLatLngToDivPixel(ne);
  //this.img_.style.visibility='hidden';
  this.img_.src=this.url;
  this.img_.style.left =swpx.x+'px';
  this.img_.style.top =nepx.y+'px';
  this.img_.style.width = Math.abs(nepx.x - swpx.x) + 'px';
  this.img_.style.height =Math.abs(swpx.y - nepx.y) + 'px';
  //this.img_.style.visibility='visible';
}

