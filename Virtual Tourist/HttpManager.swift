//
//  HttpManager.swift
//  Virtual Tourist
//
//  Created by Jamel Reid  on 8/17/17.
//  Copyright © 2017 Jamel Reid . All rights reserved.
//

import Foundation
class HttpManager {
    
    static let shared = HttpManager()
    
    func taskForGETRequest(_ lat: Double, _ lon: Double, completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void ) -> URLSessionTask {
        
        let session = URLSession.shared
        
        var components = URLComponents()
        components.scheme = Constants.Scheme.ApiScheme
        components.host = Constants.Flickr.ApiHost
        components.path = Constants.Flickr.ApiPath
        components.queryItems = buildQueryItems(lat, lon)
        
        let request = URLRequest(url: components.url!)
        
        let task = session.dataTask(with: request, completionHandler: { (data,response,error) in
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandler(nil, NSError(domain: "taskForGetRequest", code: 1, userInfo: userInfo))
                return
            }
            
            guard (error == nil) else {
                completionHandler(nil, error! as NSError)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            
        })
        
        task.resume()
        
        return task
        
        
    }
    
    func buildQueryItems(_ lat: Double, _ lon: Double) -> [URLQueryItem] {
        
        var queryItems = [URLQueryItem]()
        
        queryItems.append(URLQueryItem(name: Constants.ParameterKeys.Method, value: Constants.Methods.PhotoSearch))
        queryItems.append(URLQueryItem(name: Constants.ParameterKeys.ApiKey, value: Constants.Flickr.ApiKey))
        queryItems.append(URLQueryItem(name: Constants.ParameterKeys.Extras, value: Constants.ParameterValues.Extras))
        queryItems.append(URLQueryItem(name: Constants.ParameterKeys.Latitude, value: "\(lat)"))
        queryItems.append(URLQueryItem(name: Constants.ParameterKeys.Longitude, value: "\(lon)"))
        queryItems.append(URLQueryItem(name: Constants.ParameterKeys.Format, value: Constants.ParameterValues.Format))
        queryItems.append(URLQueryItem(name: Constants.ParameterKeys.JSONCallabck, value: "\(Constants.ParameterValues.JSONCallback)"))
        
        return queryItems
        
    }
}
