//
//  Constants.swift
//  IIQ-IOS-Agent
//
//  Created by Julian Rassolov on 25/12/2023.
//

import Foundation

class IIQConstants {
    struct keys {
        public var idfaKeyName: String
        public var groupKeyName: String
        public var percentageKeyName: String
        public var dataKeyName: String
        public var dataDateKeyName: String
        public var agentIdKeyName: String
    }
    
    
    public static let userStoreKeys =  keys (idfaKeyName: "iiqIdfaValue", groupKeyName: "iiqGroup",percentageKeyName: "iiqPercentage", dataKeyName: "iiqData", dataDateKeyName: "iiqDataDate", agentIdKeyName: "iiqAgentId")
    public static let defaultCttl:Int64 = 43200000
    
    public static let version = "2.0001"
    
}
