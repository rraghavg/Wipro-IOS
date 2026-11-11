//
//  ContentView.swift
//  Wipro IOS
//
//  Created by Raghav Gupta on 12/11/26.
//

import SwiftUI

struct ContentView: View {

    @State private var name = ""
    @State private var result = ""

    var body: some View {

        VStack(spacing: 20) {

            Text("My First App")
                .font(.largeTitle)
                .bold()

            TextField("Enter your name", text: $name)
                .textFieldStyle(.roundedBorder)
                .padding()

            Button("Submit") {
                if name.isEmpty {
                    result = "Please enter your name"
                } else {
                    result = "Hello \(name)"
                }
            }
            .buttonStyle(.borderedProminent)

            Text(result)
                .font(.title3)

        }
        .padding()
    }
}
