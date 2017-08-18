//
//  Constants.swift
//  Virtual Tourist
//
//  Created by Jamel Reid  on 8/17/17.
//  Copyright © 2017 Jamel Reid . All rights reserved.
//

import Foundation

struct Constants {
    
    struct Scheme {
        static let ApiScheme = "https"
    }
    
    struct Flickr {
        static let ApiKey = "1b33165347835bdb55d04b04737639f3"
        static let ApiHost = "api.flickr.com"
        static let ApiPath = "/services/rest"
    }
    
    struct Methods {
        static let PhotoSearch = "flickr.photos.search"
    }
    
    struct HTTPMethods {
        static let GET = "GET"
    }
    
    struct ParameterKeys {
        static let Method = "method"
        static let Format = "format"
        static let Latitude = "lat"
        static let Longitude = "lon"
        static let ApiKey = "api_key"
        static let Extras = "extras"
        static let JSONCallabck = "nojsoncallback"
    }
    
    struct ParameterValues {
        static let Format = "json"
        static let Extras = "url_m"
        static let JSONCallback = 1
    }
}
