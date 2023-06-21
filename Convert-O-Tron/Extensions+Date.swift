//
//  Extensions+Date.swift
//  Convert-O-Tron
//
//  Created by Stef Kors on 22/06/2023.
//

import Foundation

extension Date {
    var nsDate: NSDate {
        NSDate(timeIntervalSince1970: self.timeIntervalSince1970)
    }
}
