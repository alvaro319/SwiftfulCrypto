//
//  ChartView.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 8/22/25.
//

import SwiftUI

struct ChartView: View {
    
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    //used to animate the line graph
    @State private var percentage: CGFloat = 0
    
    init(coin: CoinModel) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        //last data point - first data point
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.greenColor : Color.theme.redColor
        
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        //starting date is 7 days before the end date
        //parameter is in seconds.. 7 days, 24hrs, 60min, 60 secs
        //negative value because we want to go 7 days before end date
        startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }
    
    /*
    using the width of the screen below to show the line graph of our chart
    isn't very dynamic, because we could make our chart smaller by adding some
    padding. The width of the screen would decrease as a result. Instead we
    want to base the width of our screen by the size of our chart. Therefore,
    it is best to use a Geometry Reader instead. This will give use the
    geometry of the chart inside
     */
    
    var body: some View {
        
        VStack {
            chartView
                .frame(height: 200)
            //show gridlines
                .background(chartBackground)
                .overlay (chartYAxis.padding(.horizontal, 4) , alignment: .leading)
            //X-Axis labels
            chartDateLabels.padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryTextColor)
        .onAppear {
            //wait 0.2 seconds before animating the line graph
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                //animates the line graph in a span of 2 second
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
    }
}

extension ChartView {
    
    private var chartView: some View {
        
        GeometryReader { goemetry in
            Path { path in
                //loops through each data index
                //get x coordinate in each path
                for index in data.indices {
                    /*
                    dividing by the # of data to display on the line chart(x-axis)
                    Also, if we had a screen width of 300 and there were 100 items
                    then each item would take up 3 points
                    with index: 0, 300/100 * (index + 1) =  3 * (0 + 1) = 3 => xPosition of 3 for index 0
                    with index: 1, 300/100 * (index + 1) =  3 * (1 + 1) = 6 => xPosition of 6 for index 1
                    with index: 1, 300/100 * (index + 1) =  3 * (2 + 1) = 9 => xPosition of 9 for index 2
                    .
                    .
                    with index: 1, 300/100 * (index + 1) =  3 * (99 + 1) = 300 => xPosition of 300 for index 99
                     */
                    //let xPosition = UIScreen.main.bounds.width / CGFloat(data.count) * CGFloat(index + 1)
                    //now that we are using the geometry width for the blue chart
                    //line, add a frame to the preview below of width 200 to
                    //see what happens to the line(it decreases)
                    let xPosition = goemetry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    //need to convert sparkline7d.price[certainIndex], e.g.,
                    //to a y coordinate
                    //now need to find a yPosition... looking for a range between
                    //50000 and 60000 see coin sparkline7d example in PreviewProvider.swift
                    //need to convert those values to y coordinates
                    //The range between 50k(min) and 60k(max) is 10k -> yAxis
                    //Let's say we have a data point of 52000 at sparklin7d.price[index]
                    //52k - 50k(min) = 2k
                    //2k/10000 = 20%
                    //50k - min
                    let yAxis = maxY - minY//calculates range of y axis(10000)
                    //yPosition = ((data point - minY)/YAxis)*geometryReaderHeight
                    //((52k - 50k(min))/10000)*height = 20%
                    let yPosition = (1 - CGFloat((data[index] - minY)/yAxis)) * goemetry.size.height//invert the chart
                    
                    //Inverting the chart:
                    //the coordinates of the iPhone start at (0,0) from the top left corner
                    //if you study the sparkline7d prices, the prices go up over time
                    //but our initial line chart shows our prices decreasing...
                    //that is because the screen coordinates are inverted for the iPhone
                    //so we must invert the line chart, therefore, in our example above,
                    //if our percentage is 20%, we must invert it by subrtracting
                    //1 - 20% = 80%
                    
                    if index == 0 {
                        //start the path at the first data point x-y coordinates
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                        
                }
            }
            //draws line graph using the stroke from 0 to 100% or 50% or 75%
            //trim(from: 0, to: 0.5) ////adding trim cuts the line graph in half
            //trim(from: 0, to: 0.25)//cuts the line graph to 25%
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, x: 0.0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0.0, y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0.0, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0.0, y: 40)
        }
    }
    
    private var chartBackground : some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartYAxis : some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text((maxY - (maxY - minY)/2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    
    private var chartDateLabels : some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }

}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        //NavigationView {
            ChartView(coin: dev.coin)
                //.navigationBarHidden(true)
                //.frame(width: 200)
        //}
        //.environmentObject(dev.homeVM)
    }
}

//#Preview {
//    ChartView()
//}
