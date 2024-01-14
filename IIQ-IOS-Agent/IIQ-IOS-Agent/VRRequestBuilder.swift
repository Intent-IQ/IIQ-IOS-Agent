//
//  RequestBuilder.swift
//  IIQ-IOS-Agent
//
//  Created by Julian Rassolov on 24/12/2023.
//

import Foundation

class VRRequestBuilder  {
 
    private var parameters: [String: String] = [:]
    
    private let scheme = "https"
    private let host = "api.intentiq.com"
    private let path = "/profiles_engine/ProfilesEngineServlet"
    
     init() {
         parameters.updateValue("39", forKey: "at")
         parameters.updateValue("10", forKey: "mi")
         parameters.updateValue("17", forKey: "pt")
         parameters.updateValue("1", forKey: "dpn")
         parameters.updateValue("2.001", forKey: "jsver")

     }
    
    private func prepareUrl() -> String? {
        var components = URLComponents()
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }

        // If you need to set the base URL, replace "example.com" with your actual base URL.
        components.scheme = scheme
        components.host = host
        components.path = path

        return components.string
    }
    
    public func addParam(_ key:String, _ value:String){
        parameters.updateValue(value, forKey: key)
    }
    
    public func getUrl() -> String? {
        return prepareUrl()
    }
    
}
