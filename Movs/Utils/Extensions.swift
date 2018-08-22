//
//  Extensions.swift
//  Movs
//
//  Created by Adolfho Athyla on 05/07/2018.
//  Copyright © 2018 a7hyla. All rights reserved.
//

import UIKit

extension Date {
    static func dateSourcedInServer(dateString: String) -> Date {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        return formater.date(from: dateString)!
    }
    
    func stringDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    func year() -> Int {
        let year = Calendar.current.component(.year, from: self)
        return year
    }
}
