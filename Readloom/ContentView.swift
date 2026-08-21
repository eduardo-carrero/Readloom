//
//  ContentView.swift
//  Readloom
//
//  Created by Eduardo Carrero Yubero on 01/08/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "Readloom",
                systemImage: "character.book.closed",
                description: Text("Vocabulary review is coming soon.")
            )
            .navigationTitle("Readloom")
        }
    }
}

#Preview {
    ContentView()
}
