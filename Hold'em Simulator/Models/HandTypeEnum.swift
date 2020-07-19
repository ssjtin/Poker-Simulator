//
//  HandTypeEnum.swift
//  Hold'em Simulator
//
//  Created by Hoang Luong on 18/7/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

enum HandType: Comparable, Equatable {
    
    case StraightFlush(highcard: Value)
    case Quads(value: Value, kicker: Value)
    case FullHouse(tripValue: Value, pairValue: Value)
    case Flush(first: Value, second: Value, third: Value, fourth: Value, fifth: Value)
    case Straight(highcard: Value)
    case Trips(tripValue: Value, firstKicker: Value, secondKicker: Value)
    case TwoPair(highPair: Value, lowPair: Value, kicker: Value)
    case OnePair(pairValue: Value, firstKicker: Value, secondKicker: Value, thirdKicker: Value)
    case HighCard(firstKicker: Value, secondKicker: Value, thirdKicker: Value, fourthKicker: Value, fifthKicker: Value)
    
    var comparisonValue: Int {
        
        var handValue = 0
        
        switch self {
            
        case .StraightFlush(let value):
            handValue += 2_000_000
            handValue += value.rawValue
            
        case .Quads(let value, let kicker):
            
            handValue += 1_600_000
            handValue += (value.rawValue * 15 + kicker.rawValue)
            
        case .FullHouse(let tripValue, let pairValue):
            handValue += 1_500_000
            handValue += tripValue.rawValue * 15 + pairValue.rawValue
            
            //TODO: -> Fix flush valuation
        case .Flush(let first, let second, let third, let fourth, let fifth):
            handValue += 6000
            handValue += first.rawValue * 81000 + second.rawValue * 3000 + third.rawValue * 225 + fourth.rawValue * 15 + fifth.rawValue
            
        case .Straight(let highCard):
            handValue += 5500
            handValue += highCard.rawValue
            
        case .Trips(let tripValue, let first, let second):
            handValue += 5000
            handValue += (tripValue.rawValue * 30 + first.rawValue + second.rawValue)
            
        case .TwoPair(let highValue, let lowValue, let kicker):
            handValue += 700
            handValue += (highValue.rawValue * 225 + lowValue.rawValue * 15 + kicker.rawValue)
            
        case .OnePair(let pairValue, let first, let second, let third):
            handValue += 100
            handValue += (pairValue.rawValue * 40 + first.rawValue + second.rawValue + third.rawValue)
            
        case .HighCard(let first, let second, let third, let fourth, let fifth):
            handValue += (first.rawValue + second.rawValue + third.rawValue + fourth.rawValue + fifth.rawValue)
            
        }
        
        return handValue
    }
    
    static func ==(lhs: HandType, rhs: HandType) -> Bool {
        return lhs.comparisonValue == rhs.comparisonValue
    }
    
    static func <(lhs: HandType, rhs: HandType) -> Bool {
        return lhs.comparisonValue < rhs.comparisonValue
    }
}
