//
//  HomeStatsView.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 8/9/25.
//

import SwiftUI

struct HomeStatsView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    //moved let statistics array below to HomeViewModel
    /*
    let statistics: [StatisticModel] = [
        StatisticModel(title: "Title", value: "Value", percentageChange: 1),
        StatisticModel(title: "Title", value: "Value"),
        StatisticModel(title: "Title", value: "Value"),
        StatisticModel(title: "Title", value: "Value", percentageChange: -7)
    ]
     */
    
    //When top right arrow is clicked on the HomeView to show the portfolio, this field will let you know if portfolio should be showing
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack {
            ForEach(viewModel.statistics) { stat in
                StatisticView(stat: stat)
                //the use of UIScreen.main.bounds.width only works if app is for portrait only. Doesn't work for landscape. In the case we need to support landscape, we would need to use geometry reader
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        //with just the .frame modifier above for a statistic view, the four statistic model sample objects in statistics[] extend beyond the frame of the device screen on both sides. This frame below will limit the statistic model objects within the width of the screen(portrait only).
        //adding alignment parameter to leading shifts the first
        //statistic model to the left edge of the screen(leading)
        .frame(width: UIScreen.main.bounds.width,
               alignment: showPortfolio ? .trailing : .leading
        )
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView(showPortfolio: .constant(false))
            .environmentObject(dev.homeVM)
    }
}

//#Preview {
//    HomeStatsView(showPortfolio: .constant(false))
//}
