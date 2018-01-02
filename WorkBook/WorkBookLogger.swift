//
//  WorkBookLogger.swift
//  WorkBook
//
//  Created by Aliaksandr Kantsevoi on 9/16/17.
//  Copyright © 2017 Aliaksandr Kantsevoi. All rights reserved.
//

import Foundation

public enum WorkBookLogger {
    public static var enable: Bool = true
    static func log(tag: String, message: @autoclosure () -> String) {
        if WorkBookLogger.enable {
            print("[\(tag)]:[\(Date().description)] \(message())")
        }
    }
}
