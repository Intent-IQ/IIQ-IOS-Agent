//
//  IIQPrebidId.swift
//  IIQ-IOS-Agent
//
//  Created by Julian Rassolov on 25/12/2023.
//

import Foundation

public class IIQPrebidData{
    internal init(data: [IIQPrebidId]) {
        self.data = data
    }
    
    var data:[IIQPrebidId]
    
    func prettyPrint() -> String {
           return IIQPrebidId.prettyPrintArray(data)
       }
}

public class IIQPrebidId {
    var source: String
    var identifier: String
    var atype: NSNumber?
    var ext: [String: Any]?
    
    init(source: String, identifier: String, atype: NSNumber?, ext: [String: Any]?) {
        self.source = source
        self.identifier = identifier
        self.atype = atype
        self.ext = ext
        if self.source == "adserver.org" {
            self.ext = ["rtiPartner" : "TDID"]
        }
    }
    
    func prettyPrint() -> String {
        var prettyString = "Source: \(source)\n"
        prettyString += "Identifier: \(identifier)\n"
        prettyString += "Atype: \(atype?.stringValue ?? "nil")\n"
        prettyString += "Extension: \(ext)\n"
        return prettyString
    }
}

extension IIQPrebidId {
    class func prettyPrintArray(_ prebidIds: [IIQPrebidId]) -> String {
        var result = ""
        for prebidId in prebidIds {
            result += prebidId.prettyPrint() + "\n"
        }
        return result
    }
}
