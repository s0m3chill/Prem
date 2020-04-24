//
//  VideoComposer.swift
//  iMovie
//
//  Created by Dariy Kordiyak on 24.04.2020.
//  Copyright © 2020 Dariy Kordiyak. All rights reserved.
//

import MediaPlayer
import Photos

class VideoComposer {
    
    private var firstVideoAsset = AVAsset(url: VideoHelper.firstVideoUrl)
    private var secondVideoAsset = AVAsset(url: VideoHelper.secondVideoUrl)
    private var audioAsset = AVAsset(url: VideoHelper.audioUrl)
    
    private let mixComposition = AVMutableComposition()
    
    func merge() {
        let mainComposition = videoComposition(tracks: videoTracks())
        loadAudioTrack()
        
        guard let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality) else {
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
        
        let firstInstruction = VideoHelper.videoCompositionInstruction(tracks.first, asset: firstVideoAsset)
        firstInstruction.setOpacity(0.0, at: firstVideoAsset.duration)
        let secondInstruction = VideoHelper.videoCompositionInstruction(tracks.second, asset: secondVideoAsset)
        
        mainInstruction.layerInstructions = [firstInstruction, secondInstruction]
        let mainComposition = AVMutableVideoComposition()
        mainComposition.instructions = [mainInstruction]
        mainComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        mainComposition.renderSize = CGSize(width: UIScreen.main.bounds.width,
                                            height: UIScreen.main.bounds.height)
        
        return mainComposition
    }
    
    private func loadAudioTrack() {
        let audioTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: 0)
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
        guard session.status == AVAssetExportSession.Status.completed,
            let outputURL = session.outputURL else {
                return
        }
        
        let saveVideoToPhotos = {
            PHPhotoLibrary.shared().performChanges({ PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL) }) { saved, error in
                let success = saved && (error == nil)
                let title = success ? "Success" : "Error"
                let message = success ? "Video saved" : "Failed to save video"
                
                //          let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                //          alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                //          self.present(alert, animated: true, completion: nil)
            }
        }
        
        // Ensure permission to access Photo Library
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
