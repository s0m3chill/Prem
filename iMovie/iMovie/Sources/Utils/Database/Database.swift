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
    
    func save(urlPath: String) {
        let video = StoredVideoData.create(with: urlPath)
        try! realm.write {
            realm.add(video)
        }
    }
        
    func readPublisher() -> AnyPublisher<[String], Error> {
        let storedVideosUrls = Array(realm.objects(StoredVideoData.self).map { $0.path })
        return CurrentValueSubject<[String], Error>(storedVideosUrls).eraseToAnyPublisher()
    }
    
}

final class StoredVideoData: Object {
    @objc dynamic var path: String = ""
    
    static func create(with path: String) -> StoredVideoData {
        let videoData = StoredVideoData()
        videoData.path = path
        
        return videoData
    }
}
    

