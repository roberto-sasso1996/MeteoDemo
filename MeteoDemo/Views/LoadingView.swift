//
//  LoadingView.swift
//  MeteoDemo
//
//  Created by MacBook Pro  on 24/09/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .frame(maxWidth: .infinity , maxHeight: .infinity)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View{
        LoadingView()
    }
}
