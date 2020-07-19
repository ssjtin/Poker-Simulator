//
//  ValueEnum.swift
//  Hold'em Simulator
//
//  Created by Hoang Luong on 18/7/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

enum Value: Int, CaseIterable {
    case Two = 2
    case Three
    case Four
    case Five
    case Six
    case Seven
    case Eight
    case Nine
    case Ten
    case Jack
    case Queen
    case King
    case Ace
    
    var id: String {
        return String(self.rawValue)
    }
    
    var stringDescriber: String {
        switch self {
        case .Two: return "2"
        case .Three: return "3"
        case .Four: return "4"
        case .Five: return "5"
        case .Six: return "6"
        case .Seven: return "7"
        case .Eight: return "8"
        case .Nine: return "9"
        case .Ten: return "10"
        case .Jack: return "J"
        case .Queen: return "Q"
        case .King: return "K"
        case .Ace: return "A"
        }
    }
    
    init?(string: String) {
        switch string.lowercased() {
        case "2": self = .Two
        case "3": self = .Three
        case "4": self = .Four
        case "5": self = .Five
        case "6": self = .Six
        case "7": self = .Seven
        case "8": self = .Eight
        case "9": self = .Nine
        case "10": self = .Ten
        case "j": self = .Jack
        case "q": self = .Queen
        case "k": self = .King
        case "a": self = .Ace
        default: return nil
        }
    }
}
