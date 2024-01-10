//
//  ConfigView.swift
//  IIQ-IOS-Agent-Example
//
//  Created by Julian Rassolov on 24/12/2023.
//

import SwiftUI
import IIQ_IOS_Agent

struct ConfigView: View {
    @State private var partnerID: String = "1573968118"
    @State private var ip: String = "173.235.128.196"
    @State private var showAlert = false
    
    @ObservedObject var iiqAgent: IIQAgent
    
    var body: some View {
        VStack {
            Text("Test App")
                .font(.title)
                .padding()
            
            TextField("Partner ID", text: $partnerID)
                .keyboardType(.numberPad)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            

            TextField("IP", text: $ip)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Init Agent") {
                if let pid = Int64(partnerID) {
                    print("Partner ID:", pid)
                    IIQAgent.shared.initialize(partnerId: pid,ip:ip,loggerMode: IIQLoggerMode.BOTH)
                } else {
                    print("Failed to convert the partner id to a number.")
                    showAlert = true
                }
                
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Bad Configuration"),
                    message: Text("Partner ID should be a number."),
                    dismissButton: .default(Text("OK"))
                )
            }
            HStack{
                VStack{
                    Circle()
                        .fill(iiqAgent.iiqData != nil ? Color.green : Color.gray)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text("IIQ Data")
                                .foregroundColor(.white)
                        )
                        .onTapGesture {
                                      if let iiqData = iiqAgent.iiqData {
                                          iiqAgent.printIIQDataToDefaultLogger()
                                      }
                                  }
                    Text(iiqAgent.iiqData != nil ? "IIQ Data ready" : "No data")
                        .foregroundColor(.primary)
                }
                VStack{
                    Circle()
                        .fill(iiqAgent.prebidData != nil ? Color.green : Color.gray)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text("Prebid Data")
                                .foregroundColor(.white)
                        )
                        .onTapGesture {
                                      if let iiqData = iiqAgent.iiqData {
                                          iiqAgent.printPrebidDataToDefaultLogger()
                                      }
                                  }
                    Text(iiqAgent.prebidData != nil ? "Prebid Data" : "No data")
                        .foregroundColor(.primary)
                }
            }
            Spacer()
        }
        .padding()
    }
    
}



#Preview {
    ConfigView(iiqAgent: IIQAgent.shared)
}
