//
//  BidData.swift
//  IIQ-IOS-Agent
//
//  Created by Julian Rassolov on 11/01/2024.
//

import Foundation

class BidData: Encodable {
   private  var pbjsver: String = ""
   private  var bidderCode: String = ""//user
   private  var cpm: String = ""//user
   private  var currency: String = ""//user
   private  var originalCpm: String = ""//user
   private  var originalCurrency: String = ""//user
   private  var status: String = ""//user
   private  var prebidAuctionId: String = ""//user
   private  var placementId: String = ""//user
   private  var biddingPlatformId: Int = 0//user
   private  var partnerAuctionId: String = ""//user
   private  var abPercentage: Double = 0.0
   private  var abGroup: String = ""
   private  var isInTestGroup: String = ""
   private  var enhanceRequests: Bool = false
   private  var hadEids: Bool = false
   private  var userPercentage: Double = 0.0
   private  var ABTestingConfigurationSource: String = ""
   private  var jsversion: String = ""
   private  var lateConfiguration: Bool = false
   private  var eidsNames: [String] = []
   private  var rtt: Double = 0.0
   private  var clientType: String = ""
   private  var AdserverDeviceType: Int = 0
   private  var terminationCause: Int = 0
   private  var profile: String = ""
   private  var sid: Int = 0
   private  var idls: Bool = false
   private  var ast: Int = 0
   private  var eidt: Int64 = 0
   private  var aid: String = ""
   private  var aeidln: Int = 0
   private  var wsrvcll: Bool = false
   private  var vrref: String = ""
   private  var pcid: String = ""
   private  var partnerId: String = ""
    
    private func incorporateUserData(userData: IIQImpressionReport){
        self.biddingPlatformId = userData.biddingPlatformId
        self.partnerAuctionId = userData.partnerAuctionId
        self.bidderCode = userData.bidderCode
        self.prebidAuctionId = userData.prebidAuctionId
        self.cpm = "\(userData.cpm)"
        self.currency = userData.currency
        self.originalCpm = "\(userData.originalCpm)"
        self.originalCurrency = userData.originalCurrency
        self.status = userData.status
        self.partnerId = userData.placementId
    }
    
    private func fillSytemData(_ userConfiguration: IIQUserConfiguration, _ wasServerCalled: Bool, _ latestIdsUpdate:Int64, _ appName: String){
        self.pbjsver = "2.1.6"
        self.abPercentage = userConfiguration.ABPercentage
        self.abGroup = userConfiguration.currentABGroup
        self.isInTestGroup = "\(userConfiguration.currentABGroup == "A")"
        let pData = IIQAgent.shared.prebidData?.data ?? []
        self.enhanceRequests = !pData.isEmpty
        let eids = IIQAgent.shared.iiqData?.eids ?? []
        self.hadEids = !eids.isEmpty
        self.userPercentage = userConfiguration.ABPercentage
        self.ABTestingConfigurationSource = "percentage"
        self.jsversion = IIQConstants.version
        self.eidsNames = []
        self.rtt = 0
        self.clientType = "\(IdentityModule.shared.getClientId())"
        self.AdserverDeviceType = userConfiguration.data!.adt
        self.terminationCause = userConfiguration.data!.tc
        self.profile = (userConfiguration.data?.pid ?? "" )
        self.sid = userConfiguration.data!.sid
        self.idls = wasServerCalled && !( (userConfiguration.data?.data?.eids ?? []).isEmpty)
        self.eidt = latestIdsUpdate
        self.aid = userConfiguration.agentId
        self.aeidln = -1
        self.wsrvcll = wasServerCalled
        self.vrref = appName
        self.partnerId = "\(userConfiguration.pid)"
    }
    
    public func prepareForDelivery(userData: IIQImpressionReport, userConfiguration: IIQUserConfiguration, wasServerCalled:Bool,
        latestIdsUpdate:Int64,appName: String){
        self.fillSytemData(userConfiguration, wasServerCalled,latestIdsUpdate,appName)
        self.incorporateUserData(userData: userData)
    }
    
    
    func toJSON() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(self)
            if let jsonString = String(data: data, encoding: .utf8) {
                return jsonString
            } else {
                return ""
            }
        } catch {
            return ""
        }
    }
    
    func arrayToJSON() -> String {
            let encoder = JSONEncoder()
            encoder.outputFormatting =  [.sortedKeys, .withoutEscapingSlashes]
            let data = [self]
            do {
                let data = try encoder.encode(data)
                if let jsonString = String(data: data, encoding: .utf8) {
                    return jsonString
                } else {
                    return ""
                }
            } catch {
                return ""
            }
        }
}
