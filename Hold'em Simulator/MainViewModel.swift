//
//  MainViewModel.swift
//  Hold'em Simulator
//
//  Created by Hoang Luong on 20/7/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

import SwiftUI

struct Runout {
    let id = UUID()
    let cards: [String]
    let winner: String
}

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
    
    @Published var runoutResults = [Runout]()
    
    @Published var playerOneEquity = ""
    
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
    
    func runoutHighVolume(runs: Int) {
        var playerOneWins: Float = 0
        
        let cardsToCome = flopCardOne == "blank" ? 5 : (turnCard == "blank" && riverCard == "blank") ? 2 : 1
        
        let cardStringsA = [firstHoleCardA, secondHoleCardA, flopCardOne, flopCardTwo, flopCardThree, turnCard, riverCard]
        let cardStringsB = [firstHoleCardB, secondHoleCardB, flopCardOne, flopCardTwo, flopCardThree, turnCard, riverCard]
        
        for _ in 1...runs {
            let runout = RunoutSimulator.simulateRunout(numOfCards: cardsToCome, takenCards: allSelectedCardStrings)
            let combinedA = cardStringsA + runout
            let combinedB = cardStringsB + runout
            
            let cardsA = Card.createCards(combinedA)
            let cardsB = Card.createCards(combinedB)
            
            let handA = HandEvaluator.besthand(from: cardsA)
            let handB = HandEvaluator.besthand(from: cardsB)
            
            if handA == handB {
                playerOneWins += 0.5
                print("tie")
            } else if handA > handB {
                playerOneWins += 1
            }
        }
        
        playerOneEquity = String(playerOneWins / Float(runs))
    }
    
    func runout(_ times: Int) {
        let cardsToCome = flopCardOne == "blank" ? 5 : (turnCard == "blank" && riverCard == "blank") ? 2 : 1
        
        let runoutCards = RunoutSimulator.simulateRunout(numOfTimes: times, numOfCards: cardsToCome, takenCards: allSelectedCardStrings)
        
        let cardStringsA = [firstHoleCardA, secondHoleCardA, flopCardOne, flopCardTwo, flopCardThree, turnCard, riverCard]
        let cardStringsB = [firstHoleCardB, secondHoleCardB, flopCardOne, flopCardTwo, flopCardThree, turnCard, riverCard]
        
        var results = [Runout]()
        
        for cards in runoutCards {
            let combinedA = cardStringsA + cards
            let combinedB = cardStringsB + cards
            
            let cardsA = Card.createCards(combinedA)
            let cardsB = Card.createCards(combinedB)
            
            let handA = HandEvaluator.besthand(from: cardsA)
            let handB = HandEvaluator.besthand(from: cardsB)
            
            if handA == handB {
                results.append(Runout(cards: cards, winner: "Split pot"))
            } else {
                (handA > handB) ?
                    results.append(Runout(cards: cards, winner: "Player one")) :
                    results.append(Runout(cards: cards, winner: "Player two"))
            }
        }
        
        runoutResults = results
    }
}
