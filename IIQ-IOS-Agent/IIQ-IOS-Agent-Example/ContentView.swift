//
//  ContentView.swift
//  IIQ-IOS-Agent-Example
//
//  Created by Julian Rassolov on 23/12/2023.
//

import SwiftUI
import IIQ_IOS_Agent

struct ContentView: View {
    let iiqAgent = IIQAgent(partnerId: 1232456)
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Click me") {
                           // This code will be executed when the button is clicked
                print("Agent is active \(iiqAgent.isActive())")
                       }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
