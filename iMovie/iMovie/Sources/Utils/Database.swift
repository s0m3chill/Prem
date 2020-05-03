//
//  Database.swift
//  iMovie
//
//  Created by Dariy Kordiyak on 03.05.2020.
//  Copyright © 2020 Dariy Kordiyak. All rights reserved.
//

import Foundation
import RealmSwift

enum Database {
            
    final class Store {
        private var videos: [StoredVideoData] = []
        private let realm = try! Realm(configuration: .defaultConfiguration)
        
        func save(for url: URL) {
            let video = StoredVideoData.create(with: url)
            try! realm.write {
                realm.add(video)
            }
        }
        
        func read() -> [String] {
            let videos = realm.objects(StoredVideoData.self)
            return videos.map { $0.path }
        }
        
    }
    
    private final class StoredVideoData: Object {
        dynamic var videoId = UUID().uuidString
        dynamic var path: String = ""
        
        static func create(with url: URL) -> StoredVideoData {
            let videoData = StoredVideoData()
            videoData.path = url.absoluteString
            
            return videoData
        }
        
        override class func primaryKey() -> String? {
            return "videoId"
        }
    }
    
}


