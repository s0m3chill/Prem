//
//  PlayerContainer.swift
//  iMovie
//
//  Created by Dariy Kordiyak on 23.04.2020.
//  Copyright © 2020 Dariy Kordiyak. All rights reserved.
//

import SwiftUI
import AVKit

struct PlayerContainer: UIViewControllerRepresentable {

    @Binding var videoItem: VideoItem
    
    private var player: AVPlayer {
        let videoPathUrl = FileManager.default.documentsDirectoryUrl.appendingPathComponent(videoItem.title)
        return AVPlayer(url: videoPathUrl)
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        return AVPlayerViewController()
    }

    func updateUIViewController(_ playerController: AVPlayerViewController,
                                context: Context) {
        playerController.modalPresentationStyle = .fullScreen
        playerController.player = player
        playerController.player?.play()
    }
    
}
