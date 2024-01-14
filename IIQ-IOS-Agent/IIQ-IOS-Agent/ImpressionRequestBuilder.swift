//
//  ImpressionRequestBuilder.swift
//  IIQ-IOS-Agent
//
//  Created by Julian Rassolov on 11/01/2024.
//

import Foundation

class ImpressionRequestBuilder{
    private var parameters: [String: String] = [:]
    
    private let scheme = "https"
    private let host = "reports.intentiq.com"
    private let path = ""
    
    init(userConfiguration: IIQUserConfiguration, appName:String) {
        parameters.updateValue("\(userConfiguration.pid)", forKey: "pid")
         parameters.updateValue("1", forKey: "mct")
        parameters.updateValue(userConfiguration.agentId, forKey: "agid")
        parameters.updateValue(IIQConstants.version, forKey: "jsver")
         parameters.updateValue(appName, forKey: "vrref")
        parameters.updateValue(IdentityModule.shared.getUspapi(), forKey: "pa")

     }
    
    private func prepareUrl() -> String? {
        var components = URLComponents()
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }

        components.scheme = scheme
        components.host = host
        components.path = path

        return components.string
    }
    
    public func addPayload(_ payload: BidData) -> Bool{
        
        if let data = payload.arrayToJSON().data(using: .utf8) {
            let base64String = data.base64EncodedString()
            parameters.updateValue(base64String, forKey: "payload")
            return true
        } else {
            IIQLogService.shared.Log("Failed to encode impression data to base64")
            return false;
        }
    }
    
    public func getUrl() -> String? {
        return prepareUrl()
    }
    
}
