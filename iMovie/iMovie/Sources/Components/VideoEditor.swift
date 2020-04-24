//
//  VideoEditor.swift
//  iMovie
//
//  Created by Dariy Kordiyak on 24.04.2020.
//  Copyright © 2020 Dariy Kordiyak. All rights reserved.
//

import SwiftUI
import MediaPlayer
import Photos

struct VideoEditor: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = MPMediaPickerController
        
    func makeUIViewController(context: Context) -> MPMediaPickerController {
        return MPMediaPickerController()
    }
    
    func updateUIViewController(_ uiViewController: MPMediaPickerController, context: Context) {
        
    }
    
}
