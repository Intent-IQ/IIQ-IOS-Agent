//
//  IdentityModule.swift
//  IIQ-IOS-Agent
//
//  Created by Julian Rassolov on 10/01/2024.
//

import Foundation
import AppTrackingTransparency
import AdSupport
import UIKit

class IdentityModule{
    public static let shared = IdentityModule()
    
    private let logger = IIQLogService.shared
    
    init() {
        initIDFA()
        initIDFV()
        prepareCppaStringValue()
        updateClientType()
    }
    
    
    var isAuthorized = false;
    private var idfa: String = ""
    private var idfv:String = ""
    private var permissionStatus:Int = -1
    private var usPapyString = "1YYY"
    private var client_id_type = 1
    
    public func getClientId() -> Int{
        return client_id_type
    }
    
    private func updateClientType(){
        if (self.isAuthorized && self.idfa != "00000000-0000-0000-0000-000000000000") {
            self.client_id_type = 4
        } else {
            self.client_id_type = 1
        }
    }
    
    public func getUspapi() -> String{
        return self.usPapyString
    }
    
    private func prepareCppaStringValue(){
        //1YYY - no consent
        //1YNY - yes consent
        if self.isAuthorized {
            self.usPapyString = "1YNY"
        }
    }
    
    func prepareUrl(requestBuilder: VRRequestBuilder?) {

        guard let requestBuilder = requestBuilder else {
                return
            }
        requestBuilder.addParam("pa",self.usPapyString)
        requestBuilder.addParam("attv","\(self.permissionStatus)")
        
        if (self.isAuthorized && self.idfa != "00000000-0000-0000-0000-000000000000") {
            requestBuilder.addParam("pcid", self.idfa)
            requestBuilder.addParam("idtype", "4")
        } else {
            requestBuilder.addParam("pcid", self.idfv)
            requestBuilder.addParam("idtype", "1")
        }
        
    }
    
    private func initIDFV(){
        if let identifierForVendor = UIDevice.current.identifierForVendor {
            self.idfv = identifierForVendor.uuidString
            self.logger.Log("IDFV detected: \(self.idfv)")
        }
        else {
            self.logger.Log("Failed to get IDFV ")
            self.idfv = ""
        }
    }
    
    private func initIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        self.logger.Log("Authorized for getting Private data")
                        self.permissionStatus = Int(status.rawValue)
                        self.isAuthorized = true
                        self.retrieveIDFA()
                    case .denied:
                        // Tracking authorization dialog was
                        // shown and permission is denied
                        self.permissionStatus = Int(status.rawValue)
                        self.logger.Log("Denied receiving private data")
                    case .notDetermined:
                        // Tracking authorization dialog has not been shown
                        self.permissionStatus = Int(status.rawValue)
                        self.logger.Log("Not Determined getting private data.Tracking authorization dialog has not been shown")
                    case .restricted:
                        self.permissionStatus = Int(status.rawValue)
                        self.logger.Log("Restricted private data")
                    @unknown default:
                        self.permissionStatus = -2
                        self.logger.Log("Unknown - private data")
                    }
                }
            }
        } else {
            // Fallback for iOS versions prior to 14
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                self.isAuthorized = true
                self.retrieveIDFA()
            } else {
                logger.Log("IIQ Agent IDFA is not available or tracking is disabled.")
                self.isAuthorized = false
            }
        }
    }
    

    
    private func retrieveIDFA() {
        self.idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        if  (self.idfa == "00000000-0000-0000-0000-000000000000") {
            logger.Log("Detected 0 idfa despite users concent")
        } else {
            logger.Log("IIQ Agent IDFA Read: \(self.idfa)")
        }
    }
    
}
