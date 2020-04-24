//
//  EditView.swift
//  iMovie
//
//  Created by Dariy Kordiyak on 23.04.2020.
//  Copyright © 2020 Dariy Kordiyak. All rights reserved.
//

import SwiftUI
import AVKit

struct EditView: View {
    
    @State private var showImagePicker = false
    @State private var performVideoMerge = false
    @State private var videoUrl = VideoHelper.firstVideoUrl
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                self.showImagePicker.toggle()
            }) {
                Text("Play video")
            }
            Button(action: {
                self.performVideoMerge.toggle()
            }) {
                Text("Merge video")
            }
            .sheet(isPresented: $showImagePicker) {
                PlayerContainer(videoURL: self.$videoUrl).transition(.move(edge: .bottom)).edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
