//
//  Infrastructure.swift
//  Student
//
//  Created by Walker on 2021/1/18.
//

import UIKit

class Infrastructure: NSObject {

}

class Once: NSObject {
    var executed: Bool = false
    
    func run(block: () -> Void) -> Void {
        guard !executed else {
            return
        }
        
        block()
        
        executed = true
    }
}
