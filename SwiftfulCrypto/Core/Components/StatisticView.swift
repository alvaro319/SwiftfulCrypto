//
//  StatisticView.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 8/9/25.
//

import SwiftUI

struct StatisticView: View {
    
    let stat: StatisticModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryTextColor)
            Text(stat.value)
                .font(.headline)
                .foregroundStyle(Color.theme.accentColor)
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(
                            degrees: (stat.percentageChange ?? 0) >= 0 ? 0: 180
                             )
                    )
                Text(stat.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
                
            }
            .foregroundStyle((stat.percentageChange ?? 0) >= 0 ? Color.theme.greenColor: Color.theme.redColor)
            .opacity(stat.percentageChange == nil ? 0.0 : 1.0)
        }
    }
}

//using old method of showing a preview because
//we extended the PreviewProvider, which is the previous
//preview provider before they created #Preview
struct StatisticView_Preview: PreviewProvider {
    static var previews: some View {
        
        //NOTE!!!! Remember to select the Selectable button in the Preview canvas to see dev.stat1, dev.stat2, dev.stat3
        Group {
            //recall that PreviewProvider has an extension
            //with a static var called dev
            StatisticView(stat: dev.stat1)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            
            StatisticView(stat: dev.stat2)
                .previewLayout(.sizeThatFits)
            
            StatisticView(stat: dev.stat3)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
        
    }
}

//#Preview {
//    StatisticView(stat: dev.stat1)
//}
