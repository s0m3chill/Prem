//
//  Database.swift
//  iMovie
//
//  Created by Dariy Kordiyak on 03.05.2020.
//  Copyright © 2020 Dariy Kordiyak. All rights reserved.
//

import Foundation
import RealmSwift
import Combine
            
final class Database {
    private var videos: [StoredVideoData] = []
    private let realm = try! Realm(configuration: .defaultConfiguration)
    
    func save(video: VideoItem) {
        let video = StoredVideoData.create(with: video)
        try! realm.write {
            realm.add(video)
        }
    }
        
    func readPublisher() -> AnyPublisher<[VideoItem], Error> {
        let storedVideos = Array(realm.objects(StoredVideoData.self).map { VideoItem(title: $0.name, path: $0.path) })
        return CurrentValueSubject<[VideoItem], Error>(storedVideos).eraseToAnyPublisher()
    }
    
}

final class StoredVideoData: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var path: String = ""
    
    static func create(with video: VideoItem) -> StoredVideoData {
        let videoData = StoredVideoData()
        videoData.name = video.title
        videoData.path = video.path
        
        return videoData
    }
}
    

