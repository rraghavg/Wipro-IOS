//
//  ContentView.swift
//  Wipro IOS
//
//  Created by Raghav Gupta on 12/11/26.
//



import SwiftUI

struct ContentView: View {

    @State var name = ""
    @State var result = ""

    var body: some View {

        VStack {

            Text("My First App")
                .font(.largeTitle)

            TextField("Enter your name", text: $name)
                .textFieldStyle(.roundedBorder)
                .padding()

            Button("Submit") {

                if name == "" {
                    result = "Please enter your name"
                } else {
                    result = "Hello " + name
                }
            }

            Text(result)
                .padding()
        }
        .padding()
    }
}
