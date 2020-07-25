//
//  EquityRunoutView.swift
//  Hold'em Simulator
//
//  Created by Hoang Luong on 20/7/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

import SwiftUI

struct EquityRunoutView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private var runTimes = 5000
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()    //  Push VStack to top
                Button(action: { self.viewModel.runoutHighVolume(runs: self.runTimes) }) {
                    Text("Calculate equity") .padding(12)
                        .foregroundColor(Color.white) .background(Color.blue) .cornerRadius(8)
                }
                .shadow(color: Color.purple, radius: 3, x: 2, y: 2)
                Spacer()
                HStack {
                    Image(viewModel.firstHoleCardA.lowercased())
                        .resizable()
                        .modifier(CardBox())
                    Image(viewModel.secondHoleCardA.lowercased())
                        .resizable()
                        .modifier(CardBox())
                    Text("vs")
                    Image(viewModel.firstHoleCardB.lowercased())
                        .resizable()
                        .modifier(CardBox())
                    Image(viewModel.secondHoleCardB.lowercased())
                        .resizable()
                        .modifier(CardBox())
                }
                
                Text(viewModel.playerOneEquity)
                
                HStack {
                    Spacer()
                    HStack {
                        Image(viewModel.flopCardOne.lowercased())
                            .resizable()
                            .modifier(CardBox())
                        Image(viewModel.flopCardTwo.lowercased())
                            .resizable()
                            .modifier(CardBox())
                        Image(viewModel.flopCardThree.lowercased())
                            .resizable()
                            .modifier(CardBox())
                        Image(viewModel.turnCard.lowercased())
                            .resizable()
                            .modifier(CardBox())
                        Image(viewModel.riverCard.lowercased())
                            .resizable()
                            .modifier(CardBox())
                    }
                    Spacer()
                }
                Spacer()    //  Push VStack to bottom
            }.background(Color.gray.opacity(0.8))
        }.onDisappear {
            self.viewModel.clearEquityResults()
        }
    }
}

struct EquityRunoutView_Previews: PreviewProvider {
    static var previews: some View {
        EquityRunoutView().environmentObject(MainViewModel())
    }
}
