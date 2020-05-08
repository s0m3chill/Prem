//
//  VideoListView.swift
//  iMovie
//
//  Created by Dariy Kordiyak on 23.04.2020.
//  Copyright © 2020 Dariy Kordiyak. All rights reserved.
//

import SwiftUI

struct VideoListView: View {
    
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        VideoList(videos: store.state.searchResult.map { VideoItem(title: $0.title,
                                                                   path: $0.path) })
        .onAppear(perform: fetch)
    }

    private func fetch() {
        store.send(.fetch)
    }
    
}

struct VideoList: View {
    
    let videos: [VideoItem]
    
    var body: some View {
        NavigationView {
            List(videos) { video in
                NavigationLink(destination: DetailsView(videoItem: video)) {
                    VideoRow(videoItem: video)
                }
            }
            .navigationBarTitle("Edited videos")
            .navigationBarItems(trailing:
                NavigationLink(destination: EditView(isLoadingShown: false)) {
                    Text("+")
                }
            )
        }
    }
}

struct VideoListView_Previews: PreviewProvider {
    static var previews: some View {
        VideoListView()
    }
}
