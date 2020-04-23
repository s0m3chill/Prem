//
//  VideoRow.swift
//  iMovie
//
//  Created by Dariy Kordiyak on 23.04.2020.
//  Copyright © 2020 Dariy Kordiyak. All rights reserved.
//

import SwiftUI

struct VideoRow: View {
    
    let videoItem: VideoItem
    
    var body: some View {
        return HStack {
            Text(videoItem.title)
            Spacer()
        }
    }
    
}
