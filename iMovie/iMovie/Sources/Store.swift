//
//  Store.swift
//  iMovie
//
//  Created by Dariy Kordiyak on 03.05.2020.
//  Copyright © 2020 Dariy Kordiyak. All rights reserved.
//

import Foundation
import Combine

typealias Reducer<State, Action, Environment> = (inout State, Action, Environment) -> AnyPublisher<Action, Never>?

final class Store<State, Action, Environment>: ObservableObject {
    
    @Published private(set) var state: State
    
    private let environment: Environment
    private let reducer: Reducer<State, Action, Environment>
    private var effectCancellables: Set<AnyCancellable> = []
    
    init(initialState: State,
         reducer: @escaping Reducer<State, Action, Environment>,
         environment: Environment) {
        self.state = initialState
        self.reducer = reducer
        self.environment = environment
    }
    
    func send(_ action: Action) {
        guard let effect = reducer(&state, action, environment) else {
            return
        }
        
        effect.receive(on: DispatchQueue.main)
              .sink(receiveValue: send)
              .store(in: &effectCancellables)
    }
    
}
