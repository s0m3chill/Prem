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
    @State private var videoUrl = VideoComposer.firstVideoUrl
    
    var body: some View {
        Button(action: {
            self.showImagePicker.toggle()
        }) {
            Text("Play video")
        }
        .sheet(isPresented: $showImagePicker) {
            PlayerContainer(videoURL: self.$videoUrl).transition(.move(edge: .bottom)).edgesIgnoringSafeArea(.all)
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView()
    }
}
