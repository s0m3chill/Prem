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
    
    func save(for url: URL) {
        let video = StoredVideoData.create(with: url)
        try! realm.write {
            realm.add(video)
        }
    }
        
    func readPublisher() -> AnyPublisher<[String], Error> {
        let storedVideosUrls = Array(realm.objects(StoredVideoData.self).map { $0.path })
        let passthrough = PassthroughSubject<[String], Error>()
        _ = passthrough.append(storedVideosUrls)
        
        return passthrough.eraseToAnyPublisher()
    }
    
}

final class StoredVideoData: Object {
    dynamic var path: String = ""
    
    static func create(with url: URL) -> StoredVideoData {
        let videoData = StoredVideoData()
        videoData.path = url.absoluteString
        
        return videoData
    }
}
    

