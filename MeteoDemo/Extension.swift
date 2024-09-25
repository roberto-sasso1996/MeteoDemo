//
//  Extension.swift
//  MeteoDemo
//
//  Created by MacBook Pro  on 25/09/24.
//

import Foundation
import SwiftUI


extension Double {
    func roundDable() -> String {
        //return String(format: "%.0f", self)
        let celsius = self - 274
        return String(format: "%.0f", celsius)
    }
    
    func roundDable2() -> String {
        return String(format: "%.0f", self)
    }
}

extension View{
    func cornerRadius(_ radius: CGFloat , corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners:corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
