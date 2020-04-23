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
    
    @State private var showImagePicker: Bool = false
    @State private var videoUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "coffin_dance", ofType: "mp4")!)
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                self.showImagePicker.toggle()
            }) {
                Text("Play video")
            }
            .sheet(isPresented: $showImagePicker) {
                AVPlayerView(videoURL: self.$videoUrl).transition(.move(edge: .bottom)).edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
