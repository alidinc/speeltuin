//
//  Admin.swift
//  Speeltuin
//
//  Created by Ali Dinç on 02/01/2024.
//

import SwiftUI
import Combine
import Connectivity
import Observation

@Observable
class Admin {
    
    var networkStatus: NetworkStatus = .unavailable
    var connectivityListener: AnyCancellable?
    
    init() {
        self.setupConnectivityObserver()
    }
    
    func setupConnectivityObserver() {
        let stream = Connectivity.Publisher(configuration:.init().configureURLSession(.default))
        connectivityListener?.cancel() // Remove old observer
        connectivityListener = stream.receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                DispatchQueue.main.async { [weak self] in
                    self?.networkStatus = output.availableInterfaces.isEmpty ? .unavailable : .available
                }
            }
    }
}
