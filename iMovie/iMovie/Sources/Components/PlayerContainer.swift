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

    @Binding var videoURL: URL

    private var player: AVPlayer {
        return AVPlayer(url: videoURL)
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
