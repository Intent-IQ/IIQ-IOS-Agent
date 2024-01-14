//
//  IIQImpressionReport.swift
//  IIQ-IOS-Agent
//
//  Created by Julian Rassolov on 10/01/2024.
//

import Foundation

public class IIQImpressionReport {
    var biddingPlatformId: Int
    var partnerAuctionId: String
    var bidderCode: String
    var prebidAuctionId: String
    var cpm: Double
    var currency: String
    var originalCpm: Double
    var originalCurrency: String
    var status: String
    var placementId: String

    public init(biddingPlatformId: Int, partnerAuctionId: String, bidderCode: String, prebidAuctionId: String, cpm: Double, currency: String, originalCpm: Double, originalCurrency: String, status: String, placementId: String) {
        self.biddingPlatformId = biddingPlatformId
        self.partnerAuctionId = partnerAuctionId
        self.bidderCode = bidderCode
        self.prebidAuctionId = prebidAuctionId
        self.cpm = cpm
        self.currency = currency
        self.originalCpm = originalCpm
        self.originalCurrency = originalCurrency
        self.status = status
        self.placementId = placementId
    }
}
