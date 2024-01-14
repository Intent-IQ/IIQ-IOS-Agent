//
//  VRRequestHandler.swift
//  IIQ-IOS-Agent
//
//  Created by Julian Rassolov on 25/12/2023.
//

import Foundation

class VRRequestHandler{
     init(userConfiguration: IIQUserConfiguration) {
         self.userConfiguration = userConfiguration
    }
    
    private var userConfiguration:IIQUserConfiguration;
    private let logger = IIQLogService.shared
    public var requestBuilder = VRRequestBuilder()
    
    private func updateIIQData(){
        DispatchQueue.main.async {
            IIQAgent.shared.iiqData = self.userConfiguration.data?.data
        }
    }
    private func updatePrebidData(){
        IIQAgent.shared.prebidData = IIQPrebidData(data: (self.userConfiguration.data?.extructIIQPrebidIds())!)

    }
    
    
    func sendImpressionReport(builder: ImpressionRequestBuilder){
        if let unwrappedUrl = builder.getUrl() {
            logger.Log("Impression URL : \(unwrappedUrl)")
            let url = URL(string: unwrappedUrl)!;
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    self.logger.Log("IIQ Agent Impression report Error: \(error)")
                } else if let httpResponse = response as? HTTPURLResponse {
                    self.logger.Log("IIQ Agent Impression Report status: \(httpResponse.statusCode)")
                }
            }
            task.resume()
        } else {
            logger.Log("Failed to construct Impression report URL")
        }
    }
    
    func getIIQData() -> Bool {
        if self.userConfiguration.currentABGroup == "B" || self.userConfiguration.currentABGroup == "U"  {
            return false
        }
        
        var wasServerCalled = false;
        let timeDifference =   ((userConfiguration.data?.cttl ?? -1) + userConfiguration.dataReceptionDate!) - IIQUtils.getCurrentDateInMilliseconds()
            
            if timeDifference > 0 {
                logger.Log("-----------------------------------------")
                logger.Log("Data is still valid - skipping VR request")
                logger.Log("New data will be ready in \(IIQUtils.convertMillisecondsToHours(milliseconds: timeDifference)) hours")
                logger.Log("-----------------------------------------")
                
                self.updateIIQData()
                self.updatePrebidData()
                return wasServerCalled;
                
            }
        
        
       
        if self.userConfiguration.currentIp != "" {
            requestBuilder.addParam("ip", self.userConfiguration.currentIp)
        }
        requestBuilder.addParam("dpi", "\(self.userConfiguration.pid)")
        
        
        if let unwrappedUrl = requestBuilder.getUrl() {
            logger.Log("VR URL : \(unwrappedUrl)")
            let url = URL(string: unwrappedUrl)!;
            wasServerCalled = true
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    self.logger.Log("IIQ Agent Error: \(error)")
                } else if let httpResponse = response as? HTTPURLResponse { if let data = data {
                    self.logger.Log("IIQ Agent response status: \(httpResponse.statusCode)")
                    do {
                        let decoder = JSONDecoder()
                        print(String(data: data, encoding: .utf8))
                        self.userConfiguration.data = try decoder.decode(VRResponse.self, from: data)
                        if self.userConfiguration.data?.cttl == nil {
                            self.userConfiguration.data?.cttl = IIQConstants.defaultCttl
                        }
                        self.userConfiguration.dataReceptionDate = IIQUtils.getCurrentDateInMilliseconds()
                        self.userConfiguration.data = self.userConfiguration.data
                        self.userConfiguration.storeAllData()
                        self.logger.Log((self.userConfiguration.data?.prettyPrint())!)
                        if self.userConfiguration.data?.data?.eids != nil {
                            let uidInfoArray: [IIQPrebidId] =  self.userConfiguration.data?.extructIIQPrebidIds() ?? []
                            self.logger.Log(IIQPrebidId.prettyPrintArray(uidInfoArray))
                            self.updatePrebidData()
                        }
                        self.updateIIQData()
                        
                    } catch {
                        self.logger.Log("Error decoding JSON: \(error)")
                    }
                }
                }
            }
            task.resume()
        } else {
            logger.Log("Failed to construct VR URL")
            return wasServerCalled
        }
        return wasServerCalled
    }
}
