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
            Alert(title: Text("Title"),
                  message: Text(model.editingResultMessage),
                  dismissButton: .default(Text("OK")) {
                    self.store.send(.save(paths: [self.model.urlPath]))
                })
        })
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
