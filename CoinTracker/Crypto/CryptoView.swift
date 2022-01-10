//
//  CryptoView.swift
//  CoinTracker
//
//  Created by Joshua Cleetus on 1/8/22.
//

import SwiftUI
import Combine
import ComposableArchitecture

struct CryptoListView: View {
    let store: Store<CryptoState, CryptoAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                Spacer()
                TitleView()
                Spacer()
                Section() {
                    ListHeader()
                    List(viewStore.cryptoCoins) { cryptoCoin in
                        CryptoView(store: store, cryptoCoin: cryptoCoin)
                            .listRowSeparatorTint(Color.gray)
                            .clipped()
                        
                    }
                    .listStyle(InsetGroupedListStyle())
                    .background(Color.black
                                    .edgesIgnoringSafeArea([.top, .leading, .trailing]))
                    .onAppear {
                        viewStore.send(.onAppear)
                        UITableView.appearance().backgroundColor = UIColor.black
                        UITableViewCell.appearance().backgroundColor = UIColor.black
                    }
                }
                
            }
            .foregroundColor(Color.white)
            .background(Color.black)
            
        }
    }
    
}

struct TitleView: View {
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 10)
            HStack {
                Spacer()
                Text("Crypto")
                    .frame(height: 22)
                    .font(.headline)
                Spacer()
                Image("search-bar-icon")
                    .frame(width: 59)
            }
            Spacer()
                .frame(height: 10)
        }
        .background(Color(hex: "1e2029"))
    }
}

struct ListHeader: View {
    var body: some View {
        HStack {
            VStack {
                Spacer()
                    .frame(height: 10)
                Text("Assets")
            }
            Spacer()
        }
    }
}

struct CryptoView: View {
    let store: Store<CryptoState, CryptoAction>
    let cryptoCoin: CryptoModel
    @ObservedObject var imageLoader = ImageLoaderService()
    @State var image: UIImage = UIImage()
    @State var btcPrice: String?
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                Spacer()
                HStack {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:40, height:40)
                        .onReceive(imageLoader.$image) { image in
                            self.image = image
                        }
                        .onAppear {
                            imageLoader.loadImage(for: cryptoCoin.image)
                        }
                    Spacer()
                    VStack {
                        Text(cryptoCoin.name)
                            .font(Font.custom("SF Pro Text", size: 13))
                            .fontWeight(.bold)
                            .leftAligned()
                            .minimumScaleFactor(0.01)
                        Spacer()
                            .frame(width: 20)
                        Text(cryptoCoin.symbol.uppercased())
                            .font(Font.custom("SF Pro Text", size: 12))
                            .leftAligned()
                    }
                    Spacer()
                    VStack {
                        HStack {
                            
                            Text(cryptoCoin.currentPriceString)
                                .font(Font.custom("SF Pro Text", size: 13))
                                .rightAligned()
                        }
                        Spacer()
                        Text(cryptoCoin.bitcoinPriceString)
                            .font(Font.custom("SF Pro Text", size: 13))
                            .rightAligned()
                    }
                    
                }
                Spacer()
            }
            .foregroundColor(Color.white)
            .listRowBackground(Color(hex: "1e2029"))
        }
    }
    
}

struct RepositoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoListView(
            store: Store(
                initialState: CryptoState(),
                reducer: cryptoReducer,
                environment: .dev(
                    environment: CryptoEnvironment(
                        cryptoRequest: dummyRepositoryEffect))))
    }
}

struct LeftAligned: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            content
            Spacer()
        }
    }
}

struct RightAligned: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
        }
    }
}
