//
//  rental.swift
//  car_rental
//
//  Created by MacStudent on 2020-03-06.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import Foundation
class rental
{
    var name: String
    var rate: Double
    var status: Bool
    var milage: Double
    
    init(name: String,rate: Double,status: Bool,milage: Double)
    {
        self.name = name
        self.rate = rate
        self.status = status
        self.milage = milage
    }
}
