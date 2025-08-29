//
//  DetailView.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 8/18/25.
//

import SwiftUI

struct DetailLoadingView: View {
    
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    
    @StateObject private var viewModel: DetailViewModel
    @State private var showFullDescription = false
    
    private let columns: [GridItem] = [
        //The UI will try to fit as many Rectangles as possible into columns with a minimum of 50 and a maximum of 300
        GridItem(.flexible()),
        GridItem(.flexible())
//        GridItem(.flexible(), spacing: 6, alignment: nil),
//        GridItem(.flexible(), spacing: 6, alignment: nil),
//        GridItem(.flexible(), spacing: 6, alignment: nil)
    ]
    
    private let spacing: CGFloat = 30
    
    //no longer needed since we now have a viewModel
    //so we inject the coin passed into the init()
    //let coin: CoinModel
    
    //a binding coin model is passed in,set the type to: Binding<CoinModel
    init(coin: CoinModel) {
        //self.coin = coin
        print("Initializing Detail View for: \(coin.name)")
        _viewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            //ChartView was initially inside the VStack with the
            //overviewTitle, overviewGrid, additionalDetailsTitle, and
            //additionalDetailsGrid, but we wanted to push the grid
            //to the edges of the screen, so we took ChartView out of the inner VStack and placed inside an outter VStack
            //and included original VStack within the outter VStack
            //to keep the padding for the overview and additional details
            VStack {
                //Text("")
                    //.frame(width: 300, height: 300)
                ChartView(coin: viewModel.coin)
                    .padding(.vertical)
                VStack(spacing: 20) {
                    overviewTitle
                    Divider()
                    //description
                    descriptionSection
                    overviewGrid
                    additionalDetailsTitle
                    Divider()
                    additionalDetailsGrid
                    websiteSection
                }
                .padding()
            }
            
        }
        .background(
            Color.theme.backgroundColor
                .ignoresSafeArea()
        )
        //we can add this here because this view is a child of
        //the SwiftfulCryptoApp view and it is within a NavigationView
        //Place a NavigationView around the preview below
        .navigationTitle(viewModel.coin.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                //bitcoin symbol with image
                toobarItemsTrailing
                
            }
        }
    }
}

extension DetailView {
    
    private var toobarItemsTrailing : some View {
        HStack {
            Text(viewModel.coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.secondaryTextColor)
            CoinImageView(coin: viewModel.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    private var overviewTitle : some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accentColor)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var descriptionSection : some View {
        ZStack {
            if let coinDescription = viewModel.coinDescription,
                    !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        //limits text to 3 lines
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundStyle(Color.theme.secondaryTextColor)
                    Button {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "Less" : "Read more...")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    }
                    .foregroundStyle(Color.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
            }
        }
    }
    
    private var overviewGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {
                ForEach(viewModel.overviewStatisticModel){ stat in
                    StatisticView(stat: stat)
                }
            
            })
    }
    
    private var additionalDetailsTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accentColor)
            .frame(maxWidth: .infinity, alignment: .leading)
        
    }
    
    private var additionalDetailsGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {
                ForEach(viewModel.additionalDetailsStatisticModel){ additionalDetailStat in
                    StatisticView(stat: additionalDetailStat)
                }
            
            })
    }
    
    private var websiteSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let websiteString = viewModel.websiteURL,
               let url = URL(string: websiteString) {
                Link("Website", destination: url)
                    
            }
            
            if let redditString = viewModel.redditURL,
               let url = URL(string: redditString) {
                Link("Reddit", destination: url)
                    
            }
        }
        .foregroundStyle(Color.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
    
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
        
    }
}

//#Preview {
//    DetailView()
//}
