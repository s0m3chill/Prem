//
//  VideoItem.swift
//  iMovie
//
//  Created by Dariy Kordiyak on 23.04.2020.
//  Copyright © 2020 Dariy Kordiyak. All rights reserved.
//

import SwiftUI

struct VideoItem {
    let id = UUID()
    let title: String
}

extension VideoItem: Identifiable {}
extension VideoItem: Hashable {}
