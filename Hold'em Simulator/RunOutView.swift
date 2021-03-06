//
//  RunOutView.swift
//  Hold'em Simulator
//
//  Created by Hoang Luong on 19/7/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

import SwiftUI

struct RunOutView: View {
    
    @EnvironmentObject var viewModel: MainViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var runTimes = 0
    @State private var amount: String = "0"
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Bet amount")
                TextField("Bet amount", text: $amount).modifier(CardBox())
                Button(action: {
                    self.viewModel.betAmount = Double(self.amount) ?? 0
                    self.viewModel.runout(self.runTimes + 1)
        
                }) {
                    Text("Run it out") .padding(12)
                        .foregroundColor(Color.white) .background(Color.blue) .cornerRadius(8)
                    if viewModel.betAmount != 0 {
                        Text("Player one EV = \(viewModel.playerOneEV)")
                        Text("Player two EV = \(viewModel.playerTwoEV)")
                    }
                    
                }
                .shadow(color: Color.purple, radius: 3, x: 2, y: 2)
                
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
                
                HStack {
                    if viewModel.flopCardOne != "blank" {
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
                            if viewModel.turnCard != "blank" {
                                Image(viewModel.turnCard.lowercased())
                                    .resizable()
                                    .modifier(CardBox())
                            }
                        }
                    }
                    
                    VStack {
                        ForEach(viewModel.runoutResults, id: \.id) { result in
                            HStack {
                                ForEach(result.cards, id: \.self) { card in
                                    Image(card.lowercased())
                                        .resizable()
                                        .modifier(CardBox())
                                }
                                Text(result.winner)
                            }
                        }
                    }
                }
                
                Picker(selection: $runTimes, label: Text("")) {
                    ForEach(1 ..< 10) {
                        Text(String($0))
                    }
                }
                .labelsHidden()
                
            }
            
        }.onDisappear {
            self.viewModel.clearRunOut()
        }
    }
    
}

struct RunOutView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RunOutView().environmentObject(MainViewModel())
        }
    }
}
