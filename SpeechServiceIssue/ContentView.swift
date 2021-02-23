//
//  ContentView.swift
//  SpeechServiceIssue
//
//  Created by Aleksandr on 23.02.2021.
//

import SwiftUI

struct ContentView: View {
    private let speech = AzureService(subscriptionKey: "", region: "")
    
    var body: some View {
        Button("Synthesize Hello") {
            speech.synthesize("Hello") { }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
