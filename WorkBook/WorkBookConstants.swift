//
//  WorkBookConstants.swift
//  WorkBook
//
//  Created by Aliaksandr Kantsevoi on 9/16/17.
//  Copyright © 2017 Aliaksandr Kantsevoi. All rights reserved.
//

import Foundation

public enum WorkBookConstants {
    public static var basePath: String = "ws://localhost:1337"
    static func resourceURL(_ resource: String) -> URL {
        return URL(string: "\(WorkBookConstants.basePath)/client/\(resource)")!
    }
}
