//
//  VideoComposer.swift
//  iMovie
//
//  Created by Dariy Kordiyak on 24.04.2020.
//  Copyright © 2020 Dariy Kordiyak. All rights reserved.
//

import MediaPlayer
import Photos
import Combine

final class VideoComposer {
    
    // MARK: - Properties
    
    static let editingFinishedNotification = Notification.Name("EditingFinishedNotification")
    private(set) var editingMessage: String = ""
    private(set) var urlPath: String = ""
    
    static let firstVideoUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "car_ride", ofType: "mp4")!)
    static let secondVideoUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "coffin_dance", ofType: "mp4")!)
    static let audioUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "astronomia", ofType: "m4a")!)
    
    private var firstVideoAsset = AVAsset(url: firstVideoUrl)
    private var secondVideoAsset = AVAsset(url: secondVideoUrl)
    private var audioAsset = AVAsset(url: audioUrl)
    private let mixComposition = AVMutableComposition()
            
    // MARK: - API
    
    func merge() {
        let mainComposition = videoComposition(tracks: videoTracks())
        loadAudioTrack()
        
        guard let exporter = AVAssetExportSession(asset: mixComposition,
                                                  presetName: AVAssetExportPresetHighestQuality) else {
            fatalError()
        }
        exporter.outputURL = videoStorageUrl()
        exporter.outputFileType = AVFileType.mov
        exporter.videoComposition = mainComposition
        
        exporter.exportAsynchronously() {
            DispatchQueue.main.async {
                self.exportDidFinish(exporter)
            }
        }
    }
    
    // MARK: - Private
    
    private func videoTracks() -> (first: AVMutableCompositionTrack, second: AVMutableCompositionTrack) {
        guard let firstTrack = mixComposition.addMutableTrack(withMediaType: .video,
                                                              preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else { fatalError() }
        do {
            try firstTrack.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: firstVideoAsset.duration),
                                           of: firstVideoAsset.tracks(withMediaType: .video)[0],
                                           at: CMTime.zero)
        }
        catch {
            fatalError()
        }
        
        guard let secondTrack = mixComposition.addMutableTrack(withMediaType: .video,
                                                               preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else { fatalError() }
        do {
            try secondTrack.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: secondVideoAsset.duration),
                                            of: secondVideoAsset.tracks(withMediaType: .video)[0],
                                            at: firstVideoAsset.duration)
        }
        catch {
            fatalError()
        }
        
        return (firstTrack, secondTrack)
    }
    
    private func videoComposition(tracks: (first: AVMutableCompositionTrack, second: AVMutableCompositionTrack)) -> AVMutableVideoComposition {
        let mainInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero,
                                                    duration: CMTimeAdd(firstVideoAsset.duration, secondVideoAsset.duration))
        
        let firstInstruction = videoCompositionInstruction(tracks.first, asset: firstVideoAsset)
        firstInstruction.setOpacity(0.0, at: firstVideoAsset.duration)
        let secondInstruction = videoCompositionInstruction(tracks.second, asset: secondVideoAsset)
        
        mainInstruction.layerInstructions = [firstInstruction, secondInstruction]
        let mainComposition = AVMutableVideoComposition()
        mainComposition.instructions = [mainInstruction]
        mainComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        mainComposition.renderSize = CGSize(width: UIScreen.main.bounds.width,
                                            height: UIScreen.main.bounds.height)
        
        return mainComposition
    }
    
    private func loadAudioTrack() {
        let audioTrack = mixComposition.addMutableTrack(withMediaType: .audio,
                                                        preferredTrackID: 0)
        do {
            try audioTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero,
                                                            duration: CMTimeAdd(firstVideoAsset.duration, secondVideoAsset.duration)),
                                            of: audioAsset.tracks(withMediaType: .audio)[0] ,
                                            at: CMTime.zero)
        }
        catch {
            fatalError()
        }
    }
    
    private func videoStorageUrl() -> URL {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        let date = dateFormatter.string(from: Date())
        
        return documentDirectory.appendingPathComponent("mergeVideo-\(date).mov")
    }
    
    private func exportDidFinish(_ session: AVAssetExportSession) {
        guard session.status == .completed, let outputURL = session.outputURL else {
            return
        }
        
        let saveVideoToPhotos = {
            PHPhotoLibrary.shared().performChanges({ PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL) }) { [weak self] isSaved, error in
                defer {
                    NotificationCenter.default.post(name: VideoComposer.editingFinishedNotification,
                                                    object: self)
                }
                guard let sself = self else {
                    return
                }
                let isSuccessful = isSaved && (error == nil)
                sself.editingMessage = isSuccessful ? "Video edit: Success" : "Video edit: Failure"
                sself.urlPath = outputURL.absoluteString
            }
        }
        
        if PHPhotoLibrary.authorizationStatus() != .authorized {
            PHPhotoLibrary.requestAuthorization({ status in
                if status == .authorized {
                    saveVideoToPhotos()
                }
            })
        }
        else {
            saveVideoToPhotos()
        }
    }
    
}

extension VideoComposer {
    
    private func orientationFromTransform(_ transform: CGAffineTransform) -> (orientation: UIImage.Orientation, isPortrait: Bool) {
        var assetOrientation = UIImage.Orientation.up
        var isPortrait = false
        if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
            assetOrientation = .right
            isPortrait = true
        }
        else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
            assetOrientation = .left
            isPortrait = true
        }
        else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
            assetOrientation = .up
        }
        else if transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
            assetOrientation = .down
        }
        
        return (assetOrientation, isPortrait)
    }
    
    private func videoCompositionInstruction(_ track: AVCompositionTrack, asset: AVAsset) -> AVMutableVideoCompositionLayerInstruction {
        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        let assetTrack = asset.tracks(withMediaType: AVMediaType.video)[0]
        
        let transform = assetTrack.preferredTransform
        let assetInfo = orientationFromTransform(transform)
        
        var scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.width
        if assetInfo.isPortrait {
            scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.height
            let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
            instruction.setTransform(assetTrack.preferredTransform.concatenating(scaleFactor), at: CMTime.zero)
        }
        else {
            let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
            var concat = assetTrack.preferredTransform.concatenating(scaleFactor)
                .concatenating(CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.width / 2))
            if assetInfo.orientation == .down {
                let fixUpsideDown = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                let windowBounds = UIScreen.main.bounds
                let yFix = assetTrack.naturalSize.height + windowBounds.height
                let centerFix = CGAffineTransform(translationX: assetTrack.naturalSize.width, y: yFix)
                concat = fixUpsideDown.concatenating(centerFix).concatenating(scaleFactor)
            }
            instruction.setTransform(concat, at: CMTime.zero)
        }
        
        return instruction
    }
    
}
