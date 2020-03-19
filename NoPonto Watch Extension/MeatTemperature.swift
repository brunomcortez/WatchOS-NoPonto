//
//  MeatTemperature.swift
//  NoPonto Watch Extension
//
//  Created by Bruno Cortez on 3/18/20.
//  Copyright © 2020 Bruno Cortez. All rights reserved.
//

import Foundation

enum MeatTemperature: Int {
    case rare = 0, mediumRare, medium, wellDone
    
    var stringValue: String {
        let temperatures = ["Cru", "Mal passado", "Ao ponto", "Bem passado"]
        return temperatures[self.rawValue]
    }
    
    var timeModifier: Double {
        let modifiers = [0.5, 0.75, 1, 1.5]
        return modifiers[self.rawValue]
    }
    
    func cookTimeForKg(_ kg: Double) -> TimeInterval {
        let baseTime: TimeInterval = 13 * 60
        let baseWeight = 0.5
        let weightModifier: Double = kg/baseWeight
        return baseTime * weightModifier * timeModifier
    }
}
