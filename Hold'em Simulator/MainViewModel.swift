//
//  MainViewModel.swift
//  Hold'em Simulator
//
//  Created by Hoang Luong on 20/7/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

import SwiftUI

class MainViewModel: ObservableObject {
    
    @Published var firstHoleCardA = "As"
    @Published var secondHoleCardA = "Kc"
    
    @Published var firstHoleCardB = "js"
    @Published var secondHoleCardB = "jh"
    
    @Published var flopCardOne = "2s"
    @Published var flopCardTwo = "3s"
    @Published var flopCardThree = "5d"
    @Published var turnCard = "qs"
    @Published var riverCard = "blank"
    
    @Published var handEvaluationString = ""
    @Published var cardSelectionErrorString = ""
    
    @Published var runoutResults = [[String]]()
    
    var currentlyEditingCard: CardIdentifier?
    
    var allSelectedCardStrings: [String] {
        return [
            firstHoleCardA,
            secondHoleCardA,
            firstHoleCardB,
            secondHoleCardB,
            flopCardOne,
            flopCardTwo,
            flopCardThree,
            turnCard,
            riverCard
        ].map { $0.lowercased() }
    }
    
    func evaluateHand() {
        let cardStringsA = [firstHoleCardA, secondHoleCardA, flopCardOne, flopCardTwo, flopCardThree, turnCard, riverCard]
        let cardStringsB = [firstHoleCardB, secondHoleCardB, flopCardOne, flopCardTwo, flopCardThree, turnCard, riverCard]
        let cardsA = Card.createCards(cardStringsA)
        let cardsB = Card.createCards(cardStringsB)
        
        let handA = HandEvaluator.besthand(from: cardsA)
        let handB = HandEvaluator.besthand(from: cardsB)
        
        if handA == handB {
            handEvaluationString = "Split pot"
        } else {
            (handA > handB) ?
                (handEvaluationString = "Winner is player ONE: \(handA)") :
                (handEvaluationString = "Winner is player TWO: \(handB)")
        }
        
    }
    
    func cardChoosable(from cardString: String) -> Bool {
        return !allSelectedCardStrings.contains(cardString.lowercased())
    }
    
    func runout(_ times: Int) {
        let cardsToCome = (turnCard == "blank" && riverCard == "blank") ? 2 : 1
        
        runoutResults = RunoutSimulator.simulateRunout(numOfTimes: times, numOfCards: cardsToCome, takenCards: allSelectedCardStrings)
    }
}
