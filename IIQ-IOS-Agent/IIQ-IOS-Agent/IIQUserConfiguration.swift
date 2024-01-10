//
//  UserConfiguration.swift
//  IIQ-IOS-Agent
//
//  Created by Julian Rassolov on 25/12/2023.
//

import Foundation

public class IIQUserConfiguration {
    
    private let logger = IIQLogService.shared
    
    
    var ABPercentage = 95.0
    var currentABGroup = "U"
    var pid:Int64 = -1
    var data:VRResponse?
    var dataReceptionDate: Int64?
    var currentIp: String
    
    init(pid: Int64){
        self.pid = pid
        currentIp = ""
        loadAllData()
    }
    
    private func loadAllData(){
        
        if let savedAbPercentage = UserDefaults.standard.string(forKey: IIQConstants.userStoreKeys.percentageKeyName) {
            if let doubleValue = Double(savedAbPercentage) {
                self.ABPercentage = doubleValue
                logger.Log("Retreived AB percentage stored data: \(doubleValue)")
            } else {
                logger.Log("Conversion of stored percentage to double failed.")
                self.ABPercentage = 95.0
            }
        } else {
            self.ABPercentage = 95.0
            logger.Log("No AB percentage stored data")
        }
        
        if let savedGroup = UserDefaults.standard.string(forKey: IIQConstants.userStoreKeys.groupKeyName) {
            self.currentABGroup = savedGroup
            logger.Log("Retreived AB Group stored data: \(savedGroup)")
        } else {
            self.currentABGroup = "U"
            logger.Log("No AB group stored data: B")
        }
        
        getVRData()
        
        if let savedDataReception = UserDefaults.standard.string(forKey: IIQConstants.userStoreKeys.dataDateKeyName) {
            if let intDateValue = Int64(savedDataReception) {
                self.dataReceptionDate = intDateValue
                logger.Log("Retreived VR date stored data: \(intDateValue)")
            } else {
                logger.Log("Conversion of stored date to Int64 failed.")
                self.dataReceptionDate = -1
            }
        } else {
            self.dataReceptionDate = -1
            logger.Log("No VR Date stored")
        }
        
    }
    
    public func storeAllData(){
        storeABGroup()
        storeAbPercentage()
        storeDataReceptionDate()
        storeVRData()
    }
    
   
    public func storeABGroup(){
        UserDefaults.standard.set(self.currentABGroup, forKey: IIQConstants.userStoreKeys.groupKeyName)
    }
    public func storeAbPercentage(){
        UserDefaults.standard.set("\(self.ABPercentage)", forKey: IIQConstants.userStoreKeys.percentageKeyName)
    } 
    public func storeDataReceptionDate(){
        UserDefaults.standard.set("\(self.dataReceptionDate ?? -1)", forKey: IIQConstants.userStoreKeys.dataDateKeyName)
    }
    
    public func storeVRData() {
        if data != nil {
            do {
                let encoder = JSONEncoder()
                if let encodedData = try? encoder.encode(data) {
                    UserDefaults.standard.set(encodedData, forKey: IIQConstants.userStoreKeys.dataKeyName)
                    logger.Log("VR data stored ")
                }
            } catch {
                logger.Log("Error encoding VRData: \(error)")
            }
        }
    }

    public func getVRData() {
        if let savedData = UserDefaults.standard.data(forKey: IIQConstants.userStoreKeys.dataKeyName) {
            do {
                let decoder = JSONDecoder()
                self.data = try decoder.decode(VRResponse.self, from: savedData)
                
                //logger.Log("Retreived VR stored data: \(vrData.prettyPrint())")
                logger.Log("Retreived VR stored data")
                logger.Log(self.data?.prettyPrint() ?? "")
            } catch {
                logger.Log("Error decoding VRData: \(error)")
            }
        }
        return
    }

}
