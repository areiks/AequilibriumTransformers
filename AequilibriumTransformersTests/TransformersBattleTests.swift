//
//  TransformersBattleTests.swift
//  AequilibriumTransformersTests
//
//  Created by Lucas Skierkowski on 30/12/2020.
//

import XCTest
@testable import AequilibriumTransformers

class TransformersBattleTests: XCTestCase {
    func testOptimusPredaking() {
        let optimus = Transformer(name: "Optimus Prime", team: .Autobot, rank: 10, parametersValue: 10)
        let predaking = Transformer(name: "Predaking", team: .Decepticon, rank: 10, parametersValue: 10)
        
        let transformers = [optimus, predaking]
        let vm = TransformersBattleViewModel(transformers: transformers)
        
        XCTAssertEqual(vm.winningTeam(), nil)
        XCTAssertEqual(vm.numberOfBattles(), 1)
        XCTAssertEqual(vm.survivingAutobots().count, 0)
        XCTAssertEqual(vm.survivingDecepticons().count, 0)
    }
    
    func testOptimusOptimus() {
        let optimus = Transformer(name: "Optimus Prime", team: .Autobot, rank: 10, parametersValue: 10)
        let optimusDecepticon = Transformer(name: "Optimus Prime", team: .Decepticon, rank: 10, parametersValue: 10)
        
        let transformers = [optimus, optimusDecepticon]
        let vm = TransformersBattleViewModel(transformers: transformers)
        
        XCTAssertEqual(vm.winningTeam(), nil)
        XCTAssertEqual(vm.numberOfBattles(), 1)
        XCTAssertEqual(vm.survivingAutobots().count, 0)
        XCTAssertEqual(vm.survivingDecepticons().count, 0)
    }
    
    func testPredakingOther() {
        let other = Transformer(name: "Other", team: .Autobot, rank: 10, parametersValue: 10)
        let predaking = Transformer(name: "Predaking", team: .Decepticon, rank: 10, parametersValue: 10)
        
        let transformers = [other, predaking]
        let vm = TransformersBattleViewModel(transformers: transformers)
        
        XCTAssertEqual(vm.winningTeam(), .Decepticon)
        XCTAssertEqual(vm.numberOfBattles(), 1)
        XCTAssertEqual(vm.survivingAutobots().count, 0)
        XCTAssert(vm.survivingDecepticons().contains(predaking))
        XCTAssertEqual(vm.survivingDecepticons().first?.name, "Predaking")
    }
    
    func testBattle() {
        let autobot1 = Transformer(name: "Autobot1", team: .Autobot, rank: 7, parametersValue: 7)
        let autobot2 = Transformer(name: "Autobot2", team: .Autobot, rank: 6, parametersValue: 6)
        let autobot3 = Transformer(name: "Autobot3", team: .Autobot, rank: 5, parametersValue: 5)
        let decepticon1 = Transformer(name: "Decepticon1", team: .Decepticon, rank: 8, parametersValue: 8)
        let decepticon2 = Transformer(name: "Decepticon2", team: .Decepticon, rank: 6, parametersValue: 6)
        
        let transformers = [autobot1, autobot2, autobot3, decepticon1, decepticon2]
        let vm = TransformersBattleViewModel(transformers: transformers)
        
        XCTAssertEqual(vm.winningTeam(), .Decepticon)
        XCTAssertEqual(vm.numberOfBattles(), 2)
        XCTAssert(vm.survivingAutobots().contains(autobot3))
        XCTAssert(vm.survivingDecepticons().contains(decepticon1))
    }
    
    func testTie() {
        let autobot1 = Transformer(name: "Autobot1", team: .Autobot, rank: 7, parametersValue: 7)
        let autobot2 = Transformer(name: "Autobot2", team: .Autobot, rank: 6, parametersValue: 6)
        let autobot3 = Transformer(name: "Autobot3", team: .Autobot, rank: 5, parametersValue: 5)
        let decepticon1 = Transformer(name: "Decepticon1", team: .Decepticon, rank: 7, parametersValue: 7)
        let decepticon2 = Transformer(name: "Decepticon2", team: .Decepticon, rank: 6, parametersValue: 6)
        let decepticon3 = Transformer(name: "Decepticon2", team: .Decepticon, rank: 5, parametersValue: 5)
        
        let transformers = [autobot1, autobot2, autobot3, decepticon1, decepticon2, decepticon3]
        let vm = TransformersBattleViewModel(transformers: transformers)
        
        XCTAssertEqual(vm.winningTeam(), nil)
        XCTAssertEqual(vm.numberOfBattles(), 3)
        XCTAssertEqual(vm.survivingAutobots().count, 0)
        XCTAssertEqual(vm.survivingDecepticons().count, 0)
    }
    
    func testCourageStrengthComparison() {
        let autobot1 = Transformer(id: nil, name: "Autobot1", team: .Autobot, strength: 10, intelligence: 1, speed: 1, endurance: 1, rank: 1, courage: 10, firepower: 1, skill: 1, teamIcon: nil)
        let decepticon1 = Transformer(id: nil, name: "Decepticon1", team: .Decepticon, strength: 7, intelligence: 10, speed: 10, endurance: 10, rank: 10, courage: 6, firepower: 10, skill: 10, teamIcon: nil)
        
        let transformers = [autobot1, decepticon1]
        let vm = TransformersBattleViewModel(transformers: transformers)
        
        XCTAssertEqual(vm.winningTeam(), .Autobot)
        XCTAssertEqual(vm.numberOfBattles(), 1)
        XCTAssert(vm.survivingAutobots().contains(autobot1))
        XCTAssertEqual(vm.survivingDecepticons().count, 0)
    }
    
    func testSkillComparison() {
        let autobot1 = Transformer(id: nil, name: "Autobot1", team: .Autobot, strength: 10, intelligence: 1, speed: 1, endurance: 1, rank: 1, courage: 10, firepower: 1, skill: 10, teamIcon: nil)
        let decepticon1 = Transformer(id: nil, name: "Decepticon1", team: .Decepticon, strength: 10, intelligence: 10, speed: 10, endurance: 10, rank: 10, courage: 10, firepower: 10, skill: 7, teamIcon: nil)
        
        let transformers = [autobot1, decepticon1]
        let vm = TransformersBattleViewModel(transformers: transformers)
        
        XCTAssertEqual(vm.winningTeam(), .Autobot)
        XCTAssertEqual(vm.numberOfBattles(), 1)
        XCTAssert(vm.survivingAutobots().contains(autobot1))
        XCTAssertEqual(vm.survivingDecepticons().count, 0)
    }
    
    func testOverallRating() {
        let autobot1 = Transformer(name: "Autobot1", team: .Autobot, rank: 10, parametersValue: 10)
        let decepticon1 = Transformer(name: "Decepticon1", team: .Decepticon, rank: 9, parametersValue: 9)
        
        XCTAssertEqual(autobot1.overallRating(), 50)
        
        let transformers = [autobot1, decepticon1]
        let vm = TransformersBattleViewModel(transformers: transformers)
        
        XCTAssertEqual(vm.winningTeam(), .Autobot)
        XCTAssertEqual(vm.numberOfBattles(), 1)
        XCTAssert(vm.survivingAutobots().contains(autobot1))
        XCTAssertEqual(vm.survivingDecepticons().count, 0)
    }
}
