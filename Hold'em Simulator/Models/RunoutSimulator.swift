//
//  RunoutSimulator.swift
//  Hold'em Simulator
//
//  Created by Hoang Luong on 20/7/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

class RunoutSimulator {
    
    static func simulateRunout(numOfCards: Int, takenCards: [String]) -> [String] {
        var allCards = Set<String>()
        
        Suit.allCases.forEach { suit in
            Value.allCases.forEach { value in
                let suitLetter = String(String(describing: suit).first!).lowercased()
                let valueLetter = value.stringDescriber
                
                allCards.insert(valueLetter + suitLetter)
            }
        }
        
        allCards.subtract(Set(takenCards))
        var runout = [String]()
        
        for _ in 1...numOfCards {
            let randomCard = allCards.randomElement()!
            runout.append(randomCard)
            allCards.remove(randomCard)
        }
        
        return runout
    }
    
    static func simulateRunout(numOfTimes: Int, numOfCards: Int, takenCards: [String]) -> [[String]] {
        
        var runouts = [[String]]()
        
        var allCards = Set<String>()
        
        Suit.allCases.forEach { suit in
            Value.allCases.forEach { value in
                let suitLetter = String(String(describing: suit).first!).lowercased()
                let valueLetter = value.stringDescriber
                
                allCards.insert(valueLetter + suitLetter)
            }
        }
        
        allCards.subtract(Set(takenCards))
        
        for _ in 1...numOfTimes {
            var runout = [String]()
            for _ in 1...numOfCards {
                let randomCard = allCards.randomElement()!
                runout.append(randomCard)
                allCards.remove(randomCard)
            }
            runouts.append(runout)
            allCards.formUnion(Set(runout))
        }
        
        return runouts
    }
}
