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
    
    func read() -> [String] {
        let videos = realm.objects(StoredVideoData.self)
        return videos.map { $0.path }
    }
    
    func readPublisher(matching query: String) -> AnyPublisher<[String], Error> {
//        guard
//            var urlComponents = URLComponents(string: "https://api.github.com/search/repositories")
//            else { preconditionFailure("Can't create url components...") }
//
//        urlComponents.queryItems = [
//            URLQueryItem(name: "q", value: query)
//        ]
//
//        guard
//            let url = urlComponents.url
//            else { preconditionFailure("Can't create url from url components...") }
//
//        return session
//            .dataTaskPublisher(for: url)
//            .map { $0.data }
//            .decode(type: SearchResponse.self, decoder: decoder)
//            .map { $0.items }
//            .eraseToAnyPublisher()
        
        
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
    

