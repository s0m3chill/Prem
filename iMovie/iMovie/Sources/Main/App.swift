//
//  App.swift
//  iMovie
//
//  Created by Dariy Kordiyak on 03.05.2020.
//  Copyright © 2020 Dariy Kordiyak. All rights reserved.
//

import Foundation
import Combine

struct World {
    var store = Database()
}

struct AppState {
    var searchResult: [VideoItem] = []
}

enum AppAction {
    case save(videos: [VideoItem])
    case set(videos: [VideoItem])
    case fetch
}

func appReducer(state: inout AppState,
                action: AppAction,
                environment: World) -> AnyPublisher<AppAction, Never> {
    switch action {
    case let .save(videos):
        environment.store.save(video: videos.last!)
        state.searchResult = videos
    case let .set(videos):
        state.searchResult = videos
    case .fetch:
        return environment
            .store
            .readPublisher()
            .replaceError(with: [])
            .map { AppAction.set(videos: $0) }
            .eraseToAnyPublisher()
    }
    
    return Empty().eraseToAnyPublisher()
}

typealias AppStore = Store<AppState, AppAction, World>
