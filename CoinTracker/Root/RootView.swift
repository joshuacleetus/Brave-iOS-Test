//
//  RootView.swift
//  CoinTracker
//
//  Created by Joshua Cleetus on 1/8/22.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    let store: Store<RootState, RootAction>
    var body: some View {
        WithViewStore(self.store.stateless) { _ in
            TabView {
                CryptoListView(
                    store: store.scope(
                        state: \.cryptoState,
                        action: RootAction.cryptoAction))
                    .tabItem {
                        Image("center-icon")
                    }
            }
            .onAppear() {
                UITabBar.setTransparentTabbar()
            }
            .accentColor(Color.clear)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        let rootView = RootView(
            store: Store(
                initialState: RootState(),
                reducer: rootReducer,
                environment: .dev(environment: RootEnvironment())))
        return rootView
    }
}

extension UITabBar {
    
    static func setTransparentTabbar() {
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage     = UIImage()
        UITabBar.appearance().clipsToBounds   = true
    }
    
}

extension UITabBarController {
    
    override open func viewDidLayoutSubviews() {
        let items = tabBar.items
        for item in items!
        {
            if item.title == nil {
                item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
            }
        }
    }
}
