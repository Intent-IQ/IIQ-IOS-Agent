//
//  PrebidRunner.swift
//  IIQ-IOS-Agent-Example
//
//  Created by Julian Rassolov on 26/12/2023.
//

import Foundation
import PrebidMobile
class PrebidRunner {
    
    public static let shared = PrebidRunner()
    private init() {
        Prebid.shared.prebidServerHost = .Rubicon
        
        // Account Id
        Prebid.shared.prebidServerAccountId = "1234"

        // Geolocation
        Prebid.shared.shareGeoLocation = true

        // Log level data
        Prebid.shared.logLevel = .debug

        // Set Prebid timeout in milliseconds
        Prebid.shared.timeoutMillis = 3000

        // Enable Prebid Server debug respones
        Prebid.shared.pbsDebug = true

//        // Stored responses  can be one of storedAuction response or storedBidResponse
//        Prebid.shared.storedAuctionResponse = "111122223333"
//
//        //or
//        Prebid.shared.addStoredBidResponse(bidder: "appnexus", responseId: "221144")
//        Prebid.shared.addStoredBidResponse(bidder: "rubicon", responseId: "221155")
        
        
        Prebid.initializeSDK { status, error in
            switch status {
            case .succeeded:
                print("Prebid SDK successfully initialized")
            case .failed:
                if let error = error {
                    print("An error occurred during Prebid SDK initialization: \(error.localizedDescription)")
                }
            case .serverStatusWarning:
                if let error = error {
                    print("Prebid Server status checking failed: \(error.localizedDescription)")
                }
            default:
                break
            }
        }
        
       }
}
