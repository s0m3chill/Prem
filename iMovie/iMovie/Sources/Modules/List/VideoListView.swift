//
//  VideoListView.swift
//  iMovie
//
//  Created by Dariy Kordiyak on 23.04.2020.
//  Copyright © 2020 Dariy Kordiyak. All rights reserved.
//

import SwiftUI

struct VideoListView: View {
    
    private let videos = [VideoItem(title: "edited!")]

    var body: some View {
        NavigationView {
            List(videos) { video in
                NavigationLink(destination: DetailsView()) {
                    VideoRow(videoItem: video)
                }
            }
            .navigationBarTitle("Edited videos")
            .navigationBarItems(trailing:
                NavigationLink(destination: EditView()) {
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
