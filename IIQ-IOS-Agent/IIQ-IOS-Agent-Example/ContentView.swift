//
//  ContentView.swift
//  IIQ-IOS-Agent-Example
//
//  Created by Julian Rassolov on 23/12/2023.
//

import SwiftUI
import IIQ_IOS_Agent
import AppTrackingTransparency
import AdSupport

struct ContentView: View {
    @State private var showAlert = false
    var prebidRunner = PrebidRunner.shared
   
    var body: some View {
        TabView {
            ConfigView(iiqAgent: IIQAgent.shared)
                       .tabItem {
                           Image(systemName: "gear")
                           Text("App")
                       }

                   LogView()
                       .tabItem {
                           Image(systemName: "list.bullet")
                           Text("Log")
                       }
               }
           .onAppear {
               requestIDFAAuthorization()
           }
          
           .padding()
       }

       func requestIDFAAuthorization() {
           if #available(iOS 14, *) {
               ATTrackingManager.requestTrackingAuthorization { status in
                   switch status {
                   case .authorized:
                       // IDFA access is authorized. You can now retrieve the IDFA.
                       self.retrieveIDFA()

                   case .denied:
                       // User denied access to IDFA. Handle accordingly.
                       print("IDFA access denied.")

                   case .restricted:
                       // IDFA access is restricted. Handle accordingly.
                       print("IDFA access restricted.")

                   case .notDetermined:
                       // The user has not yet made a choice regarding IDFA access.
                       // You can choose to request IDFA again or handle it later.
                       print("IDFA access not determined.")
                   }
               }
           } else {
               // Fallback for iOS versions prior to 14
               if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                   // IDFA access is available. You can now retrieve the IDFA.
                   self.retrieveIDFA()
               } else {
                   // IDFA is not available or tracking is disabled.
                   print("IDFA is not available or tracking is disabled.")
               }
           }
       }

       func retrieveIDFA() {
           let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
           print("IDFA: \(idfa)")
           // Do something with the IDFA
       }
   }

#Preview {
    ContentView()
}
