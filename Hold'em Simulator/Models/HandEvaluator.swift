//
//  HandEvaluator.swift
//  Hold'em Simulator
//
//  Created by Hoang Luong on 18/7/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

class HandEvaluator {
    
    static func besthand(from cards: [Card]) -> HandType {
        
        if let straightFlush = detectStraightFlush(from: cards) {
            return straightFlush
        }
        
        if let quads = detectQuads(from: cards) {
            return quads
        }
        
        if let fullHouse = detectFullHouse(from: cards) {
            return fullHouse
        }
        
        if let flush = detectFlush(from: cards) {
            return flush
        }
        
        if let straight = detectStraight(cards: cards) {
            return straight
        }
        
        if let trips = detectTrips(from: cards) {
            return trips
        }
        
        return detectTwoPairOrWorse(from: cards)
    }
    
    static func detectStraightFlush(from cards: [Card]) -> HandType? {
        for suit in Suit.allCases {
            var suitedCards = cards.filter { $0.suit == suit }.sorted()
            suitedCards.reverse()
            if suitedCards.count >= 5, case let .Straight(highCard) = detectStraight(cards: suitedCards) {
                return HandType.StraightFlush(highcard: highCard)
            }
        }
        
        return nil
    }
    
    static func detectQuads(from cards: [Card]) -> HandType? {
        let values = cards.map { $0.value.rawValue }
        let ones = repeatElement(1, count: values.count)
        var countedValues = Dictionary(zip(values, ones), uniquingKeysWith: +)
        
        if let quadValue = countedValues.first(where: { $1 == 4 })?.key {
            countedValues[quadValue] = nil
            //  TODO => Forced unwraps
            return HandType.Quads(value: Value(rawValue: quadValue)!, kicker: Value(rawValue: countedValues.keys.max()!)!)
        }
        
        return nil
    }
    
    static func detectTwoPairOrWorse(from cards: [Card]) -> HandType {
        let values = cards.map { $0.value.rawValue }
        let ones = repeatElement(1, count: values.count)
        let countedValues = Dictionary(zip(values, ones), uniquingKeysWith: +)
        
        var pairValues = countedValues.filter { key, value in
            return value == 2
        }
        
        if let highest = pairValues.keys.max() {
            
            pairValues[highest] = nil
            if let secondHighest = pairValues.keys.max() {
                //  two pairs
                let kicker = values.filter { $0 != highest && $0 != secondHighest }.max()!
                return HandType.TwoPair(highPair: Value(rawValue: highest)!,
                                        lowPair: Value(rawValue: secondHighest)!,
                                        kicker: Value(rawValue: kicker)!)
            } else {
                // one pair
                let remainingCards = values.filter { $0 != highest }.sorted(by: { $0 > $1 })
                
                return HandType.OnePair(pairValue: Value(rawValue: highest)!,
                                        firstKicker: Value(rawValue: remainingCards[0])!,
                                        secondKicker: Value(rawValue: remainingCards[1])!,
                                        thirdKicker: Value(rawValue: remainingCards[2])!)
            }
        } else {
            let sortedValues = values.sorted(by: { $0 > $1 })
            
            return HandType.HighCard(firstKicker: Value(rawValue: sortedValues[0])!,
                                     secondKicker: Value(rawValue: sortedValues[1])!,
                                     thirdKicker: Value(rawValue: sortedValues[2])!,
                                     fourthKicker: Value(rawValue: sortedValues[3])!,
                                     fifthKicker: Value(rawValue: sortedValues[4])!)
        }
    }
    
    static func detectFullHouse(from cards: [Card]) -> HandType? {
        if let tripValue = detectHighestTrips(from: cards) {
            let remainingCards = cards.filter { $0.value != tripValue }
            if let pairValue = detectHighestPair(from: remainingCards) {
                return HandType.FullHouse(tripValue: tripValue, pairValue: pairValue)
            }
        }
        return nil
    }
    
    static func detectTrips(from cards: [Card]) -> HandType? {
        let values = cards.map { $0.value.rawValue }
        let ones = repeatElement(1, count: values.count)
        let countedValues = Dictionary(zip(values, ones), uniquingKeysWith: +)

        let tripValues = countedValues.filter { key, value in
            return value == 3
        }
        
        if let highest = tripValues.keys.max() {
            let remainingCards = values.filter { $0 != highest }.sorted(by: { $0 > $1 })
            return HandType.Trips(tripValue: Value(rawValue: highest)!,
                                  firstKicker: Value(rawValue: remainingCards[0])!,
                                  secondKicker: Value(rawValue: remainingCards[1])!)
        }
        
        return nil
    }
    
    //  Return only exactly trips
    static func detectHighestTrips(from cards: [Card]) -> Value? {
        let values = cards.map { $0.value.rawValue }
        let ones = repeatElement(1, count: values.count)
        let countedValues = Dictionary(zip(values, ones), uniquingKeysWith: +)

        let tripValues = countedValues.filter { key, value in
            return value == 3
        }
        
        if let highest = tripValues.keys.max() {
            return Value(rawValue: highest)!
        }
        
        return nil
    }
    
    //  Find highest possible pair, may be part of trips
    static func detectHighestPair(from cards: [Card]) -> Value? {
        let values = cards.map { $0.value.rawValue }
        let ones = repeatElement(1, count: values.count)
        let countedValues = Dictionary(zip(values, ones), uniquingKeysWith: +)

        let pairValues = countedValues.filter { key, value in
            return value >= 2
        }
        
        if let highest = pairValues.keys.max() {
            return Value(rawValue: highest)!
        }
        
        return nil
    }
    
    static func detectFlush(from cards: [Card]) -> HandType? {
        for suit in Suit.allCases {
            var suitedCards = cards.filter { $0.suit == suit }.sorted()
            suitedCards.reverse()
            if suitedCards.count >= 5 {
                return HandType.Flush(first: suitedCards[0].value, second: suitedCards[1].value, third: suitedCards[2].value, fourth: suitedCards[3].value, fifth: suitedCards[4].value)
            }
            
        }
        return nil
    }
    
    static func detectStraight(cards: [Card]) -> HandType? {
        let valueSet = Set(cards.map { $0.value.rawValue })
        
        let nums = [14, 13, 12, 11, 10, 9, 8, 7, 6]
        
        for highCard in nums {
            
            let straightRange = Set(highCard-4...highCard)
            
            if straightRange.isSubset(of: valueSet) {
                return HandType.Straight(highcard: Value(rawValue: highCard)!)
            }
        }
        
        if Set(arrayLiteral: 2, 3, 4, 5, 14).isSubset(of: valueSet) {
            return HandType.Straight(highcard: Value.Five)
        }
        
        return nil
    }

}
