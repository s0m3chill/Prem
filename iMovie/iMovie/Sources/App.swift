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
    var searchResult: [String] = []
}

enum AppAction {
    case save(paths: [String])
    case fetch
}

func appReducer(state: inout AppState,
                action: AppAction,
                environment: World) -> AnyPublisher<AppAction, Never> {
    switch action {
    case let .save(paths):
        state.searchResult = paths
    case .fetch:
        return environment
            .store
            .readPublisher()
            .replaceError(with: [])
            .map { AppAction.save(paths: $0) }
            .eraseToAnyPublisher()
    }
    
    return Empty().eraseToAnyPublisher()
}

typealias AppStore = Store<AppState, AppAction, World>
