//
//  FileManager+Extensions.swift
//  iMovie
//
//  Created by Dariy Kordiyak on 05.05.2020.
//  Copyright © 2020 Dariy Kordiyak. All rights reserved.
//

import Foundation

extension FileManager {
    
    var documentsDirectoryUrl: URL {
        return FileManager.default.urls(for: .documentDirectory,
                                        in: .userDomainMask).first!
    }
    
}
