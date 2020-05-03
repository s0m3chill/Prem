//
//  EditViewModel.swift
//  iMovie
//
//  Created by Dariy Kordiyak on 03.05.2020.
//  Copyright © 2020 Dariy Kordiyak. All rights reserved.
//

import Foundation
import Combine

final class EditViewModel: ObservableObject {
    
    @Published var isAlertShown: Bool = false
    var editingResultMessage = ""
    private var cancelSet: Set<AnyCancellable> = []

    init() {
        NotificationCenter.default.publisher(for: VideoComposer.editingFinishedNotification)
            .compactMap{ $0.object as? VideoComposer }
            .map{ $0.editingMessage }
            .sink() { message in
                self.editingResultMessage = message
                self.isAlertShown = true
        }
        .store(in: &cancelSet)
    }
    
}
