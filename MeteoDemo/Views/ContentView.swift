//
//  ContentView.swift
//  MeteoDemo
//
//  Created by MacBook Pro  on 24/09/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            WelcomeView()
                .environmentObject(locationManager)
        }
        .background(.blue)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
