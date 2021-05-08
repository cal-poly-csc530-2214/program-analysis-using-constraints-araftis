//
//  PV1.swift
//  Lab4
//
//  Created by AJ Raftis on 4/27/21.
//

import Foundation

func PV1(_ y: Int) {
    var x = -50
    while x < 0 {
        x = x + y
        y += 1
    }
    assert(y > 0)
}
