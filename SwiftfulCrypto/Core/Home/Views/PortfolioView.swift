//
//  PortfolioView.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 8/11/25.
//

import SwiftUI


struct PortfolioView: View {
    
    /*
     apparently presentationMode will be deprecated so using
     dismiss instead make sure to add the environmentObject
     modifier when calling this view and adding a
     NavigationView as well to this view because a sheet
     creates a new environment.. 4:50 mark in Create a View to
     manage current user's portfolio
     */
    //@Environment(\.presentationMode) var presentationMode
    //moved to XMarkButton component in Component folder for reuse
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckMark: Bool = false
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0)
                {
                    SearchBarView(searchText: $viewModel.searchText)
                    
                    //lists coins horizontally to allow user to add to own
                    //portfolio
                    coinLogoList
                    
                    //two versions of coinLogoList...
                    //version iOS 15 or >= iOS 16
                    /*
                    if #available(iOS 16.0, *) {
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 10) {
                                ForEach(viewModel.allCoins) { coin in
                                    CoinLogoView(coin: coin)
                                        .frame(width: 75)
                                         .padding(4)
                                         .onTapGesture {
                                             selectedCoin = coin
                                         }
                                        .background {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(
                                                    selectedCoin?.id == coin.id ? Color.theme.greenColor :
                                                        Color.clear, lineWidth: 1)
                                        }
                                }
                                
                            }
                            .padding(.vertical, 4)
                            .padding(.leading)
                        }
                        .scrollIndicators(.hidden)
                    } else {
                        // Fallback on earlier versions
                        ScrollView(.horizontal,
                                   showsIndicators: false,
                                   content: {
                            //using lazy because there are lots of items to list and don't want to load them all at once
                            LazyHStack(spacing: 10) {
                                ForEach(viewModel.allCoins) { coin in
                                    CoinLogoView(coin: coin)
                                        .frame(width: 75)
                                        .padding(4)
                                        .onTapGesture {
                                            withAnimation(.easeIn) {
                                                selectedCoin = coin
                                            }
                                        }
                                        .background {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(
                                                    selectedCoin?.id == coin.id ? Color.theme.greenColor :
                                                        Color.clear, lineWidth: 1)
                                        }
                                }
                            }
                            .padding(.vertical, 4)
                            .padding(.leading)
                        }
                        )
                    }//end else
                     */
                    
                    //coin was selected, calculate
                    if selectedCoin != nil {
                        portfolioCalculationSection
                    }

                }

            }
            //setting background like this because Portfolio is a modal view (sheet)
            //placing it on the ScrollView{}
            .background(
                Color.theme.backgroundColor
                    .ignoresSafeArea()
            )
            .navigationBarTitle("Edit Portfolio")
            .toolbar(content: {
                //.navigationBarLeading is deprecating
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButton(dismiss: _dismiss)
                }
                //.navigationBarTrailing is deprecating
                ToolbarItem(placement: .topBarTrailing) {
                    trailingNavBarButtons
                }
            })
            //if user enters text to search for a coin, selects a coin
            //from the filtered list, then clicks on 'x' button, the searchText should
            //clear and the calculation portion of the view should not display
            .onChange(of: viewModel.searchText) { newValue in
                
                    if viewModel.searchText == "" {
                        removeSelectedCoin()
                    }
                 
            }
            //Deprecated in iOS 13(still working in iOS 18.2 but leaving for reference to legacy code
            /*
            .navigationBarItems(
                leading:
                    XMarkButton(dismiss: _dismiss)
                    //Moved X button to the component folder for reuse...XMarkButton struct
                    /*
                    Button(
                        action: {
                            //will be deprecated
                            //presentationMode.wrappedValue.dismiss()
                            dismiss()
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.headline)
                        }
                    )//end button
                     */
            )//end NavigationBarItems
             */
            
        }
        
    }
}

extension PortfolioView {
    
    private var coinLogoList: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                //If user is not searching, show portfolio coins, else show all coins
                ForEach(viewModel.searchText.isEmpty ? viewModel.portfolioCoins : viewModel.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                         .padding(4)
                         .onTapGesture {
                             //selectedCoin = coin
                             updateSelectedCoin(coin: coin)
                                                         
                         }
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    selectedCoin?.id == coin.id ? Color.theme.greenColor :
                                        Color.clear, lineWidth: 1)
                        }
                }
                
            }
            .padding(.vertical, 4)
            .padding(.leading)
        }
        .scrollIndicators(.hidden)
    }
    
    /* When a coin is selected from the ScrollView LazyHStack, see if that selected coin is in the user's portfolio. if so, get that coin's currentHoldings amount and display it on the the screen. */
    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        
        if let portfolioCoin = viewModel.portfolioCoins.first(where: { (portfolioCoin) -> Bool in
            return portfolioCoin.id == coin.id
        }),
           let amount = portfolioCoin.currentHoldings
        {
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private var portfolioCalculationSection: some View {
        
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimal() ?? "")
            }
            Divider()
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimal())
            }
        }
        //SwiftUI Crypto App Video #14, 27:30 minute mark
        .animation(.none, value: selectedCoin?.id)
        .padding()
        .font(.headline)
    }
    
    private var trailingNavBarButtons : some View {
        
        HStack(spacing: 10) {
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1.0 : 0.0)
            Button {
                saveButtonPressed()
            } label: {
                //only want to show this Save button when user selects
                //a crypto coin and adds a numerical value to the TextField
                Text("Save".uppercased())
                    .opacity(
                        (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0 : 0.0
                    )
            }
        }
        .font(.headline)
    }
    
    private func saveButtonPressed() {
        guard
            let amount = Double(quantityText),
            let coin = selectedCoin
        else {
            return
        }
        
        //save to Portfolio
        viewModel.updatePorfolio(coin: coin, amount: amount)
        
        //show the checkmark
        withAnimation(.easeIn) {
            showCheckMark = true
            removeSelectedCoin()
        }
        
        //hide keyboard
        UIApplication.shared.endEditing()//see extension
        
        //hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeIn) {
                showCheckMark = false
            }
        }
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        
        viewModel.searchText = ""
    }
}

//using old Preview structure to be able to make use of dev.homeVM
//which is a sample homeViewModel to be used just to show fake data in a preview
struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}

// #Preview {
// PortfolioView()
// .environmentObject(dev.homeVM)
// }
 
