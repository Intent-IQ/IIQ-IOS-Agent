//
//  IIQAgent.swift
//  IIQ-IOS-Agent
//
//  Created by Julian Rassolov on 23/12/2023.
//

import Foundation

import AdSupport
import AppTrackingTransparency
import SwiftUI

public class IIQAgent : ObservableObject {
    
    public static let shared = IIQAgent()
    private init() {
       }
    
    @Published public var iiqData: VRData?
    @Published public var prebidData: IIQPrebidData?
    
    private let logger = IIQLogService.shared
    private let identityModule:IdentityModule = IdentityModule.shared
    private var pid:Int64 = -1;
    private var userConfiguration: IIQUserConfiguration = IIQUserConfiguration(pid: -1)
    private var requestHandler:VRRequestHandler?
    
    public func initialize(partnerId: Int64, ip:String = "" , loggerMode:IIQLoggerMode = IIQLoggerMode.NONE) {
        logger.setLoggerMode(mode: loggerMode)
        pid = partnerId;
        userConfiguration = IIQUserConfiguration(pid: pid)
        userConfiguration.currentIp = ip;
        requestHandler = VRRequestHandler(userConfiguration: userConfiguration)
        logger.Log("Agent configured successfully")
        initABTesting();
        identityModule.prepareUrl(requestBuilder: requestHandler!.requestBuilder)
        self.mainBody()
    }
    
    
    private func mainBody() {
        self.userConfiguration.storeAllData()
        if userConfiguration.currentABGroup == "A" {
            requestHandler!.getIIQData()
        }
    }
    
    public func getPartnerId() -> Int64 {
        return self.pid
    }
    
    private func initABTesting() {
        if userConfiguration.currentABGroup != "U" {
            logger.Log("IIQ Agent Retrieved current group: \(userConfiguration.currentABGroup)")
        } else {
            let randomNumber = Double.random(in: 0...100)
            
            if randomNumber <= userConfiguration.ABPercentage {
                userConfiguration.currentABGroup = "A"
            } else {
                userConfiguration.currentABGroup = "B"
            }
            logger.Log("IIQ Agent : generating new AB group : \(userConfiguration.currentABGroup)")
            self.userConfiguration.storeABGroup()
        }
        requestHandler!.requestBuilder.addParam("abtg", userConfiguration.currentABGroup)
    }

    
    public func printIIQDataToDefaultLogger(){
        logger.Log(self.iiqData!.prettyPrint())
    }
    
    public func printPrebidDataToDefaultLogger(){
        logger.Log((self.prebidData?.prettyPrint())!)
    }
}
