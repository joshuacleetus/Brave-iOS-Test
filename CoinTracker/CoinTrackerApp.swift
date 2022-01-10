//
//  CoinTrackerApp.swift
//  CoinTracker
//
//  Created by Joshua Cleetus on 1/8/22.
//

import SwiftUI
import ComposableArchitecture

@main
struct CoinTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(
              store: Store(
                initialState: RootState(),
                reducer: rootReducer,
                environment: .live(environment: RootEnvironment())))
        }
    }
}
