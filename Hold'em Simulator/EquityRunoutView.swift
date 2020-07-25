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
    
    @State private var runTimes = 0
    
    var body: some View {
        VStack {
            Text("Run it out")
            
            Button(action: { self.viewModel.runoutHighVolume(runs: 10000) }) {
                Text("Simulate") .padding(12)
                    .foregroundColor(Color.white) .background(Color.blue) .cornerRadius(8)
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
            
            Text(viewModel.playerOneEquity)
            
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
                
            }
            
            Picker(selection: $runTimes, label: Text("")) {
                ForEach(1 ..< 10) {
                    Text(String($0))
                }
            }
            .labelsHidden()
            
        }
        
        
    }
}

struct EquityRunoutView_Previews: PreviewProvider {
    static var previews: some View {
        EquityRunoutView().environmentObject(MainViewModel())
    }
}
