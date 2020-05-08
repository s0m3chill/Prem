//
//  EditView.swift
//  iMovie
//
//  Created by Dariy Kordiyak on 23.04.2020.
//  Copyright © 2020 Dariy Kordiyak. All rights reserved.
//

import SwiftUI

struct EditView: View {
    
    var videoComposer = VideoComposer()
    @ObservedObject var model = EditViewModel()
    @State var isLoadingShown: Bool
    
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        LoadingView(isShowing: $isLoadingShown) {
            VStack {
                Button(action: {
                    self.isLoadingShown.toggle()
                    self.videoComposer.merge()
                }) {
                    Text("Merge video")
                }
            }
        }
        .alert(isPresented: $model.isAlertShown, content: {
            Alert(title: Text("Edining finished"),
                  message: Text("Save to database?"),
                  dismissButton: .default(Text("Yes")) {
                    self.isLoadingShown.toggle()
                    self.store.send(.save(videos: [self.model.videoItem]))
                })
        })
    }
}
