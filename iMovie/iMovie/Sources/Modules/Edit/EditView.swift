//
//  EditView.swift
//  iMovie
//
//  Created by Dariy Kordiyak on 23.04.2020.
//  Copyright © 2020 Dariy Kordiyak. All rights reserved.
//

import SwiftUI
import AVKit
import Combine

struct EditView: View {
    
    private var videoComposer = VideoComposer()
    private var cancelSet: Set<AnyCancellable> = []

    init() {
        NotificationCenter.default.publisher(for: VideoComposer.editingFinishedNotification)
            .compactMap{ $0.object as? VideoComposer }
            .map{ $0.editingMessage }
            .sink() { message in
                print(message)
            }
            .store(in: &cancelSet)
    }
    
    var body: some View {
        VStack {
            Button(action: {
                self.videoComposer.merge()
            }) {
                Text("Merge video")
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
