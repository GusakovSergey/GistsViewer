//
//  Thread+Extensions.swift
//  Util
//
//  Created by Sergey on 26/01/2019.
//

import Foundation

extension Thread {
    public static func onMainThread(_ block: @escaping ()->()) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
}
