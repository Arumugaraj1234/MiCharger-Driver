//
//  AppInitModel.swift
//  MiCharger
//
//  Created by MacBook Pro on 2019-12-16.
//  Copyright © 2019 Peach. All rights reserved.
//

import Foundation

class AppInitModel {
    var id: Int
    var type: String
    var newVersion: String
    var flag: Int
    var instruction: String
    
    init(id: Int, type: String, newVersion: String, flag: Int, instruction: String) {
        self.id = id
        self.type = type
        self.newVersion = newVersion
        self.flag = flag
        self.instruction = instruction
    }
}
