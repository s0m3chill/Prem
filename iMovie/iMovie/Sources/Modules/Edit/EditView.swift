//
//  EditView.swift
//  iMovie
//
//  Created by Dariy Kordiyak on 23.04.2020.
//  Copyright © 2020 Dariy Kordiyak. All rights reserved.
//

import SwiftUI

struct EditView: View {
    
    private var videoComposer = VideoComposer()
    @ObservedObject private var model = EditViewModel()
    
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        VStack {
            Button(action: {
                self.videoComposer.merge()
            }) {
                Text("Merge video")
            }
        }
        .alert(isPresented: $model.isAlertShown, content: {
            Alert(title: Text("Edining finished"),
                  message: Text("Save to database?"),
                  dismissButton: .default(Text("Yes")) {
                    self.store.send(.save(videos: [self.model.videoItem]))
                })
        })
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
