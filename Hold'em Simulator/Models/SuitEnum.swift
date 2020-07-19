//
//  SuitEnum.swift
//  Hold'em Simulator
//
//  Created by Hoang Luong on 18/7/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

enum Suit: CaseIterable {
    case Diamond
    case Heart
    case Spade
    case Club
    
    init?(character: Character) {
        switch character.lowercased() {
        case "d": self = .Diamond
        case "h": self = .Heart
        case "s": self = .Spade
        case "c": self = .Club
        default: return nil
        }
    }
}

