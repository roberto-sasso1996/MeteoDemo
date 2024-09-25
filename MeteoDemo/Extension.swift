//
//  Extension.swift
//  MeteoDemo
//
//  Created by MacBook Pro  on 25/09/24.
//

import Foundation


extension Double {
    func roundDable() -> String {
        //return String(format: "%.0f", self)
        let celsius = self - 274
        return String(format: "%.0f", celsius)
    }
}
