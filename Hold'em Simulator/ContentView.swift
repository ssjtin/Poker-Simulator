//
//  ContentView.swift
//  Hold'em Simulator
//
//  Created by Hoang Luong on 13/7/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

import SwiftUI

struct CardBox: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(idealWidth: 60, idealHeight: 100)
            .fixedSize()
            .border(Color.black)
    }
}

enum CardIdentifier {
    case holeCardOneA
    case holeCardTwoA
    case holeCardOneB
    case holeCardTwoB
    
    case flopCardOne
    case flopCardTwo
    case flopCardThree
    case turnCard
    case riverCard
}

struct MainView: View {
    
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                NavigationLink(destination: EquityRunoutView()) {
                    Text("Simulate runout")
                }
                Spacer()
                    .frame(height: 20)
                
                HStack {
                    Group {
                        NavigationLink(destination: ContentView(editing: .holeCardOneA)) {
                            Image(viewModel.firstHoleCardA.lowercased())
                                .resizable()
                                .modifier(CardBox())
                        }.buttonStyle(PlainButtonStyle())
                        NavigationLink(destination: ContentView(editing: .holeCardTwoA)) {
                            Image(viewModel.secondHoleCardA.lowercased())
                                .resizable()
                                .modifier(CardBox())
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
                Spacer()
                    .frame(height: 100)
                Text("Community cards")
                HStack {
                    Group {
                        NavigationLink(destination: ContentView(editing: .flopCardOne)) {
                            Image(viewModel.flopCardOne.lowercased())
                                .resizable()
                                .modifier(CardBox())
                        }.buttonStyle(PlainButtonStyle())
                        NavigationLink(destination: ContentView(editing: .flopCardTwo)) {
                            Image(viewModel.flopCardTwo.lowercased())
                                .resizable()
                                .modifier(CardBox())
                        }.buttonStyle(PlainButtonStyle())
                        NavigationLink(destination: ContentView(editing: .flopCardThree)) {
                            Image(viewModel.flopCardThree.lowercased())
                                .resizable()
                                .modifier(CardBox())
                        }.buttonStyle(PlainButtonStyle())
                        Spacer()
                            .frame(width: 14)
                        NavigationLink(destination: ContentView(editing: .turnCard)) {
                            Image(viewModel.turnCard.lowercased())
                                .resizable()
                                .modifier(CardBox())
                        }.buttonStyle(PlainButtonStyle())
                        Spacer()
                            .frame(width: 14)
                        NavigationLink(destination: ContentView(editing: .riverCard)) {
                            Image(viewModel.riverCard.lowercased())
                                .resizable()
                                .modifier(CardBox())
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
                
                Spacer()
                    .frame(height: 100)
                HStack {
                    Group {
                        NavigationLink(destination: ContentView(editing: .holeCardOneB)) {
                            Image(viewModel.firstHoleCardB.lowercased())
                                .resizable()
                                .modifier(CardBox())
                        }.buttonStyle(PlainButtonStyle())
                        NavigationLink(destination: ContentView(editing: .holeCardTwoB)) {
                            Image(viewModel.secondHoleCardB.lowercased())
                                .resizable()
                                .modifier(CardBox())
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
                Text(viewModel.handEvaluationString)
                Button(action: { self.viewModel.evaluateHand() }) {
                    Text("Best hand") .padding(12)
                        .foregroundColor(Color.white) .background(Color.blue) .cornerRadius(8)
                }
                .shadow(color: Color.purple, radius: 3, x: 2, y: 2)
            }
        }
        
    }
}

struct ContentView: View {
    
    @EnvironmentObject var viewModel: MainViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var valueSelection = 0
    @State private var suitSelection = 0
    
    let editingCard: CardIdentifier
    
    init(editing: CardIdentifier) {
        self.editingCard = editing
    }
    
    func updateSelection() {
        let suit = Suit.allCases[suitSelection]
        let value = Value.allCases[valueSelection]
        
        let suitLetter = String(String(describing: suit).first!).lowercased()
        let valueLetter = value.stringDescriber
        
        let cardString = valueLetter + suitLetter
        
        if viewModel.cardChoosable(from: cardString) {
            switch editingCard {
            case .holeCardOneA: viewModel.firstHoleCardA = cardString
            case .holeCardTwoA: viewModel.secondHoleCardA = cardString
            case .holeCardOneB: viewModel.firstHoleCardB = cardString
            case .holeCardTwoB: viewModel.secondHoleCardB = cardString
            case .flopCardOne: viewModel.flopCardOne = cardString
            case .flopCardTwo: viewModel.flopCardTwo = cardString
            case .flopCardThree: viewModel.flopCardThree = cardString
            case .turnCard: viewModel.turnCard = cardString
            case .riverCard: viewModel.riverCard = cardString
            }
            self.presentationMode.wrappedValue.dismiss()
        } else {
            viewModel.cardSelectionErrorString = "Card already taken.  Please choose another or clear existing selection."
        }
    }
    
    func clearCard() {
        
        switch editingCard {
        case .holeCardOneA: viewModel.firstHoleCardA = "blank"
        case .holeCardTwoA: viewModel.secondHoleCardA = "blank"
        case .holeCardOneB: viewModel.firstHoleCardB = "blank"
        case .holeCardTwoB: viewModel.secondHoleCardB = "blank"
        case .flopCardOne: viewModel.flopCardOne = "blank"
        case .flopCardTwo: viewModel.flopCardTwo = "blank"
        case .flopCardThree: viewModel.flopCardThree = "blank"
        case .turnCard: viewModel.turnCard = "blank"
        case .riverCard: viewModel.riverCard = "blank"
        }
        
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        
        VStack {
            
            Button(action: {self.clearCard()}) {
                Text("Clear card") .padding(12)
                    .foregroundColor(Color.white) .background(Color.blue) .cornerRadius(8)
            }
            .shadow(color: Color.red, radius: 3, x: 2, y: 2)
            
            Text(viewModel.cardSelectionErrorString)
                .lineLimit(nil)
                .padding()
            
            Picker(selection: $valueSelection, label: Text("")) {
                ForEach(0 ..< Value.allCases.count) { index in
                    Text(String(Value.allCases[index].stringDescriber)).tag(Value.allCases[index].rawValue)
                }
            }
            
            Picker(selection: $suitSelection, label: Text("")) {
                Text("Diamond").tag(0)
                Text("Heart").tag(1)
                Text("Spade").tag(2)
                Text("Club").tag(3)
            }
            
            Button(action: {self.updateSelection()}) {
                Text("Confirm selection") .padding(12)
                    .foregroundColor(Color.white) .background(Color.blue) .cornerRadius(8)
            }
            .shadow(color: Color.purple, radius: 3, x: 2, y: 2)
        }
        .labelsHidden()

    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView().environmentObject(MainViewModel())
            ContentView(editing: .flopCardOne).environmentObject(MainViewModel())
        }
    }
}
