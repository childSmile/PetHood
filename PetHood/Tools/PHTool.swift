//
//  PHTool.swift
//  PetHood
//
//  Created by MacPro on 2024/9/10.
//

import UIKit

class PHTool: NSObject {
    
    class func calculateAge(from birthDate: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        return ageComponents.year ?? 0
    }
    
    
}
