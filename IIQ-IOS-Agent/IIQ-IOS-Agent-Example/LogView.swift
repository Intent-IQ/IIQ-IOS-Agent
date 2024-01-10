//
//  LogView.swift
//  IIQ-IOS-Agent-Example
//
//  Created by Julian Rassolov on 24/12/2023.
//

import SwiftUI
import IIQ_IOS_Agent
struct LogView: View {
    @ObservedObject var logService = IIQLogService.shared

    var body: some View {
          NavigationView {
              TextEditor(text: Binding(
                  get: { logService.log ?? "" },
                  set: { logService.log = $0 }
              ))
              .font(.system(size: 10))
              .navigationBarTitle("Log View")
              .navigationBarItems(trailing: Button("Clear") {
                  self.logService.log = nil
              })
          }
      }
  }
struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
    }
}
