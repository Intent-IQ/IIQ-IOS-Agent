//
//  IIQAgent.swift
//  IIQ-IOS-Agent
//
//  Created by Julian Rassolov on 23/12/2023.
//

import Foundation

import AdSupport
import AppTrackingTransparency

public class IIQAgent {
    
    
    private var active: Bool = false
    private var pid:Int64;
    
    init(partnerId: Int64) {
        
        self.pid = partnerId
        print("Agent configured successfully")
        self.active = true;
        initIDFA();
    }
    
    public func getPartnerId() -> Int64 {
        return self.pid
    }
    
    func initIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self.retrieveIDFA()
                    } else {
                        print("IDFA access is not authorized. Requesting authorization...")
                        self.requestAuthorization()
                    }
                }
            }
        } else {
            // Fallback for iOS versions prior to 14
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                self.retrieveIDFA()
            } else {
                print("IDFA is not available or tracking is disabled.")
                self.active = false
            }
        }
    }

    private func requestAuthorization() {
        ATTrackingManager.requestTrackingAuthorization { status in
            DispatchQueue.main.async {
                if status == .authorized {
                    self.retrieveIDFA()
                } else {
                    print("IDFA access is still not authorized.")
                    self.active = false
                }
            }
        }
    }

    private func retrieveIDFA() {
        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        print("IDFA: \(idfa)")
    }
}
