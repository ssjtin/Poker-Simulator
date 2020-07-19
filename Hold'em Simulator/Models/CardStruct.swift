//
//  CardStruct.swift
//  Hold'em Simulator
//
//  Created by Hoang Luong on 13/7/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

struct Card: Comparable {
    
    static func < (lhs: Card, rhs: Card) -> Bool {
        return lhs.value.rawValue < rhs.value.rawValue
    }
    
    let suit: Suit
    let value: Value
    
    var stringValue: String {
        let suitLetter = String(String(describing: suit).first!)
        let valueLetter = value.stringDescriber
        return valueLetter + suitLetter
    }
    
    /*
     Convenience initialize cards from array of string values
     Insert card as string of value + suit, e.g. ["4s", "kc", "9d"]
     */
    static func createCards(_ cardNames: [String]) -> [Card] {
        var createdCards = [Card]()
        
        for cardString in cardNames {
            let valueString = String(cardString.dropLast(1))
            
            if
                let value = Value(string: valueString),
                let suitChar = cardString.last,
                let suit = Suit(character: suitChar) {
                
                createdCards.append(Card(suit: suit, value: value))
            }

        }
        return createdCards
    }
    
}
