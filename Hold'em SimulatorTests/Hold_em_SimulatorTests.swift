//
//  Hold_em_SimulatorTests.swift
//  Hold'em SimulatorTests
//
//  Created by Hoang Luong on 13/7/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

import XCTest
@testable import Hold_em_Simulator

class Hold_em_SimulatorTests: XCTestCase {
    
    var cards = [Card]()

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        cards.removeAll()
        handType = nil
    }
    
    func testBestHandDetection() {
        cards = Card.createCards(["ah", "kd", "8d", "ad", "as", "5d", "3h"])
        XCTAssertEqual(HandEvaluator.besthand(from: cards), HandType.Trips(tripValue: Value.Ace, firstKicker: Value.King, secondKicker: Value.Eight))
        
        cards = Card.createCards(["ah", "kd", "8d", "jd", "4s", "10s", "qh"])
        XCTAssertEqual(HandEvaluator.besthand(from: cards), HandType.Straight(highcard: Value.Ace))
    }
    
    func testDetectStraightFlush() {
        cards = Card.createCards(["6d", "7d", "8d", "9d", "10h"])
        
        XCTAssertNil(HandEvaluator.detectStraightFlush(from: cards))
        
        cards = Card.createCards(["6d", "7d", "10d", "9d", "8d"])
        
        XCTAssertNotNil(HandEvaluator.detectStraightFlush(from: cards))
    }
    
    func testDetectQuads() {
        cards = Card.createCards(["6d", "6s", "6c", "6h", "10h", "ac", "ad"])
        if case let .Quads(value, kicker) = HandEvaluator.detectQuads(from: cards) {
            XCTAssertEqual(value, Value.Six)
            XCTAssertEqual(kicker, Value.Ace)
        } else {
            assertionFailure("Failed to detect quads")
        }
    }
    
    func testDetectFullHouse() {
        cards = Card.createCards(["6d", "10s", "6c", "10h", "6s", "ad", "10c"])
        
        if case let .FullHouse(tripValue, pairValue) = HandEvaluator.detectFullHouse(from: cards) {
            XCTAssertEqual(tripValue, Value.Ten)
            XCTAssertEqual(pairValue, Value.Six)
        } else {
            assertionFailure("Failed to detect full house")
        }
    }
    
    func testHighestTripsDetection() {
        cards = Card.createCards(["6d", "6s", "6c", "10h", "ac", "ad"])
        
        XCTAssertEqual(HandEvaluator.detectHighestTrips(from: cards), Value.Six)
    }

    
    func testStraightDetection() {
        cards = Card.createCards(["6d", "7d", "8d"])
        
        XCTAssertNil(HandEvaluator.detectStraight(cards: cards))
        
        cards = Card.createCards(["6d", "7d", "8d", "9s", "10h"])
        
        XCTAssertNotNil(HandEvaluator.detectStraight(cards: cards))
    }
    
    func testCardInitializer() {
        let cards = Card.createCards(["4s", "10h"])
        XCTAssertEqual(cards.count, 2)
        XCTAssertTrue(cards.contains(Card(suit: .Heart, value: .Ten)))
    }
    
    func testFlushDetection() {
        cards = Card.createCards(["7s", "10s", "2s", "ac", "9s"])
        
        XCTAssertNil(HandEvaluator.detectFlush(from: cards))
        
        cards = Card.createCards(["7s", "10s", "2s", "as", "9s"])
        
        XCTAssertNotNil(HandEvaluator.detectFlush(from: cards))
    }
    
    func testTwoPairOrWorseDetection() {
        
        cards = Card.createCards(["7s", "10s", "10c", "ac", "7d"])
        
        if case let .TwoPair(highPair, lowPair, kicker) = HandEvaluator.detectTwoPairOrWorse(from: cards) {
            XCTAssertEqual(highPair, Value.Ten)
            XCTAssertEqual(lowPair, Value.Seven)
            XCTAssertEqual(kicker, Value.Ace)
        } else {
            assertionFailure("Failed to detect quads")
        }
        
        cards = Card.createCards(["7s", "2s", "3h", "9d", "10s", "kd", "ac", "7d"])
        
        if case let .OnePair(pair, first, second, third) = HandEvaluator.detectTwoPairOrWorse(from: cards) {
            XCTAssertEqual(pair, Value.Seven)
            XCTAssertEqual(first, Value.Ace)
            XCTAssertEqual(second, Value.King)
            XCTAssertEqual(third, Value.Ten)
        } else {
            assertionFailure("Failed to detect quads")
        }
        
        cards = Card.createCards(["7s", "2s", "qh", "9d", "10s", "kd", "ac"])
        
        if case let .HighCard(first, second, third, fourth, fifth) = HandEvaluator.detectTwoPairOrWorse(from: cards) {
            XCTAssertEqual(first, Value.Ace)
            XCTAssertEqual(second, Value.King)
            XCTAssertEqual(third, Value.Queen)
            XCTAssertEqual(fourth, Value.Ten)
            XCTAssertEqual(fifth, Value.Nine)
        } else {
            assertionFailure("Failed to detect quads")
        }
        
    }
    
}
