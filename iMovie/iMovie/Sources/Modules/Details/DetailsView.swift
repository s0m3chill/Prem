//
//  DetailsView.swift
//  iMovie
//
//  Created by Dariy Kordiyak on 23.04.2020.
//  Copyright © 2020 Dariy Kordiyak. All rights reserved.
//

import SwiftUI

struct DetailsView: View {
    
    @State private var showImagePicker = false
    @State var videoItem: VideoItem
    
    var body: some View {
        Button(action: {
            self.showImagePicker.toggle()
        }) {
            Text("Play video")
        }
        .sheet(isPresented: $showImagePicker) {
            PlayerContainer(videoItem: self.$videoItem)
                .transition(.move(edge: .bottom))
                .edgesIgnoringSafeArea(.all)
        }
    }
}
