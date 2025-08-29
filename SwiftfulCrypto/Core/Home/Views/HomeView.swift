//
//  HomeView.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 7/29/25.
//

import SwiftUI

struct HomeView: View {
    
    //Since we are sharing this viewModel across many different views, instead of defining a viewModel here, we will define one in SwiftfulCryptoApp.swift as an EnvironmentObject
//    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    @EnvironmentObject private var viewModel: HomeViewModel
    //animates top right button
    @State private var showPortfolio: Bool = false
    //shows sheet when '+' button is pressed on top left of screen
    @State private var showPortfolioView: Bool = false
    
    @State private var showSettingsView: Bool = false
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
    
    var body: some View {
        
        ZStack {
            //background layer
            Color.theme.backgroundColor
                .ignoresSafeArea()
                //this sheet is creating a whole new environment
                //so when we go to this new sheet, we need to add the
                //viewModel environment object to the PortfolioView because
                //it won't have access to the viewModel Environment object
                //and because we are in another environment, we are no longer in a
                //navigation view, so we need to add a navigation view for
                //the PortfolioView
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                        //adds viewModel environment object to the Portfolio view
                        .environmentObject(viewModel)
                }
                //can't place a second sheet for the SettingsView here
                //Only one sheet is allowed per view hierarchy, placing one
                //here would place a second sheet in the same hierarchy.
                //However we can add a sheet to the VStack below because
                //it will be in a different view hierarchy
            
            //content layer
            VStack {
                homeHeader
                //CoinRowView(coin: DeveloperPreview.instance.coin, showHoldingsColumn: false)
                
                HomeStatsView(showPortfolio: $showPortfolio)
                
                //search bar
                //we could have defined the searchText locally like this:
                //@State private var searchText: String = ""
                SearchBarView(searchText: $viewModel.searchText)
                
                columnTitles
                
                if !showPortfolio {
                    allCoinsList
                    //moves the CoinRows towards the leading edge of the
                    //screen and therefore off the screen
                    .transition(.move(edge: .leading))
                }
                else {
                    
                    //added message to display if there are no portfolio
                    //coins
                    ZStack {
                        if viewModel.portfolioCoins.isEmpty &&
                            viewModel.searchText.isEmpty {
                            VStack {
                                Spacer()
                                Text("Click the + button to add coins to your portfolio!")
                                .font(.callout)
                                .foregroundStyle(Color.theme.accentColor)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                                .padding(50)
                                Spacer()
                            }
                            
                        }
                        else {
                            portfolioCoinsList
                        }
                    }
                    //transitions into view from the right either for the
                    //portfolioCoinsList or the message  prompt above
                    .transition(.move(edge: .trailing))
                    //portfolioCoinsList
                        
                }
                
                //pushes the HStack above up to the top
                Spacer(minLength: 0)
            }
            .sheet(isPresented: $showSettingsView) {
                SettingsView()
            }
        }//end ZStack
        .background(
            //ignore warning: 'init(destination:isActive:label:)' was deprecated in iOS 16.0: use NavigationLink(value:label:), or navigationDestination(isPresented:destination:), inside a NavigationStack or NavigationSplitView
            NavigationLink(
                destination: DetailLoadingView(coin: $selectedCoin),
                isActive: $showDetailView,
                label: { EmptyView() })
        )
    }
}

extension HomeView {
    
    private var homeHeader: some View {
        
        //this HStack was where homeHeader is now in the HomeView above
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                //turns animation off when showPortfolio toggles
                //below; when it toggles the value from
                //"plus" to "info" or "info" to "plus"
                .animation(.none, value: showPortfolio)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    } else {
                        showSettingsView.toggle()
                    }
                    
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
                
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.theme.accentColor)
                .animation(.none, value: showPortfolio)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        //places padding outside the info and chevron buttons
        //near edge of view
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View {

        List {
            ForEach(viewModel.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: showPortfolio)
                    .listRowInsets(
                        .init(
                            top: 10,
                            leading: 0,
                            bottom: 10,
                            trailing: 10
                        )
                    )
                    .onTapGesture {
                        segue(coin: coin)
                    }
                    .listRowBackground(Color.theme.backgroundColor)
            }
        }
        .listStyle(PlainListStyle())
        .refreshable {
            //reload the data
            viewModel.reloadData()
        }

        //creates all the destination views before the user
        //clicks on a row, inefficient
        /*
            List {
                ForEach(viewModel.allCoins) { coin in
                    NavigationLink {
                        DetailView(coin: coin)
                    } label: {
                        CoinRowView(coin: coin, showHoldingsColumn: showPortfolio)
                            .listRowInsets(
                                .init(
                                    top: 10,
                                    leading: 0,
                                    bottom: 10,
                                    trailing: 10
                                )
                            )
                    }
                }
            }
            .listStyle(PlainListStyle())
            .refreshable {
                //reload the data
                viewModel.reloadData()
            }
         */
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(viewModel.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: showPortfolio)
                    .listRowInsets(
                        .init(
                            top: 10,
                            leading: 0,
                            bottom: 10,
                            trailing: 10
                        )
                    )
                    .onTapGesture {
                        segue(coin: coin)
                    }
                    .listRowBackground(Color.theme.backgroundColor)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    private var columnTitles: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((viewModel.sortOption == .rank || viewModel.sortOption == .rankReversed) ?  1.0 : 0.0)
                    //if sort option is rank, keep chevron pointing as is, otherwise turn it 180 degrees and point up
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                //if viewModel.sortOption == .rank {
                //    viewModel.sortOption = .rankReversed
                //}
                //else {
                //    viewModel.sortOption = .rank
                //}
                    //shorthand:
                    viewModel.sortOption = viewModel.sortOption == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((viewModel.sortOption == .holdings || viewModel.sortOption == .holdingsReversed) ?  1.0 : 0.0)
                    //if sort option is rank, keep chevron pointing as is, otherwise turn it 180 degrees and point up
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        viewModel.sortOption = viewModel.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            HStack(spacing: 4) {
                Text("Price")
                    .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
                Image(systemName: "chevron.down")
                    .opacity((viewModel.sortOption == .price || viewModel.sortOption == .priceReversed) ?  1.0 : 0.0)
                    //if sort option is rank, keep chevron pointing as is, otherwise turn it 180 degrees and point up
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .price ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = viewModel.sortOption == .price ? .priceReversed : .price
                    }
                }
                
            //refresh button
            //we can explicitly show a refresh button or use .refreshable{} in allCoinsList
            /*
            Button {
                
                withAnimation(.linear(duration: 2.0)) {
                    //reload the data
                    viewModel.reloadData()
                }

            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(
                Angle(degrees: viewModel.isLoading ? 360 : 0),
                anchor: .center)
             */

        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryTextColor)
        .padding(.horizontal)//pads on the sides
    }
}

//using older version of Previews syntax to follow along in tutorial
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.homeVM)
    }
}

//#Preview {
//    NavigationView {
//        HomeView()
//            .navigationBarHidden(true)
//    }
//}
