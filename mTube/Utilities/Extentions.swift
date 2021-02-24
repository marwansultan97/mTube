//
//  Extentions.swift
//  mTube
//
//  Created by Marwan Osama on 2/22/21.
//

import UIKit

protocol HasApply { }

extension HasApply {
    func apply(closure: (Self)->()) {
        closure(self)
    }
}

extension NSObject: HasApply { }
