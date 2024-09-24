//
//  WelcomeView.swift
//  MeteoDemo
//
//  Created by MacBook Pro  on 24/09/24.
//

import SwiftUI

struct WelcomeView : View {
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct WelcomeView_Previews: PreviewProvider{
    static var previews: some View{
        WelcomeView()
    }
}
