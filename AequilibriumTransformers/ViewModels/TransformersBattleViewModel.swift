//
//  TransformersBattleViewModel.swift
//  AequilibriumTransformers
//
//  Created by Lucas Skierkowski on 30/12/2020.
//

import Foundation

/**
 Class responsible for the logic of the transformer battles. Implements `TransformersBattleViewControllerDataSource`.
 On init accepts an array of `Transformer`. Based on data provided battle methods will be resolved. 
 */
class TransformersBattleViewModel: TransformersBattleViewControllerDataSource {
    private var data: [Transformer]
    private var decepticonsSorted: [Transformer]
    private var autobotsSorted: [Transformer]
    private var survivorsDecepticons: [Transformer]
    private var survivorsAutobots: [Transformer]
    private var battleCounter = 0
    
    private let predakingString = "Predaking"
    private let optimusString = "Optimus Prime"
    private let strengthLevel = 3
    private let courageLevel = 4
    private let skillLevel = 3
    
    ///Resolves transformer battle based on provided transformer list
    ///- parameter transformers: accepts an array of `Transformer` used in battle
    init(transformers: [Transformer]) {
        data = transformers
        decepticonsSorted = transformers.filter { $0.team == .Decepticon }.sorted(by: { $0.rank > $1.rank })
        autobotsSorted = transformers.filter { $0.team == .Autobot }.sorted(by: { $0.rank > $1.rank })
        survivorsDecepticons = []
        survivorsAutobots = []
        battle()
    }
    
    ///Main battle resolver, checks which team has smaller number of warriors and resolves that amount of battles
    private func battle() {
        var allKilled = false
        if decepticonsSorted.count < autobotsSorted.count {
            for (index, decepticon) in decepticonsSorted.enumerated() {
                if battleCheck(autobot: autobotsSorted[index], decepticon: decepticon) {
                    allKilled = true
                    break
                }
            }
            if !allKilled {
                survivorsAutobots.append(contentsOf: autobotsSorted.suffix(autobotsSorted.count - decepticonsSorted.count))
            }
        } else {
            for (index, autobot) in autobotsSorted.enumerated() {
                if battleCheck(autobot: autobot, decepticon: decepticonsSorted[index]) {
                    allKilled = true
                    break
                }
            }
            if !allKilled {
                survivorsDecepticons.append(contentsOf: decepticonsSorted.suffix(decepticonsSorted.count - autobotsSorted.count))
            }
        }
    }
    
    ///Helper which resolves battle between two transformes. Contains main logic checks for a fight between two warriors.
    ///- parameter autobot: autobot `Transformer` used in battle
    ///- parameter decepticon: decepticon `Transformer` used in battle
    private func battleCheck(autobot: Transformer, decepticon: Transformer) -> Bool {
        battleCounter += 1
        if (autobot.name == predakingString || autobot.name == optimusString) &&
            (decepticon.name == predakingString || decepticon.name == optimusString) {
            survivorsDecepticons = []
            survivorsAutobots = []
            return true
        }
        
        if (autobot.name == predakingString || autobot.name == optimusString) &&
            (decepticon.name != predakingString || decepticon.name != optimusString) {
            survivorsAutobots.append(autobot)
            return false
        }
        
        if (autobot.name != predakingString || autobot.name != optimusString) &&
            (decepticon.name == predakingString || decepticon.name == optimusString) {
            survivorsDecepticons.append(decepticon)
            return false
        }
        
        if autobot.strength >= decepticon.strength + strengthLevel && autobot.courage >= decepticon.courage + courageLevel {
            survivorsAutobots.append(autobot)
            return false
        }
        
        if decepticon.strength >= autobot.strength + strengthLevel && decepticon.courage >= autobot.courage + courageLevel {
            survivorsDecepticons.append(decepticon)
            return false
        }
        
        if autobot.skill >= decepticon.skill + skillLevel {
            survivorsAutobots.append(autobot)
            return false
        }
        
        if decepticon.skill >= autobot.skill + skillLevel {
            survivorsDecepticons.append(decepticon)
            return false
        }
        
        if autobot.overallRating() > decepticon.overallRating() {
            survivorsAutobots.append(autobot)
            return false
        }
        
        if decepticon.overallRating() > autobot.overallRating() {
            survivorsDecepticons.append(decepticon)
            return false
        }
        
        return false
    }
    
    ///Returns the number of fights which happened between team members
    func numberOfBattles() -> Int {
        return battleCounter
    }
    
    ///Returns team which won the battle (killed the most of opposite team members).
    ///In case there is a tie then nil value will be returned (no winning team)
    func winningTeam() -> TransformerTeam? {
        let eliminatedAutobots = autobotsSorted.count - survivorsAutobots.count
        let eliminatedDecepticons = decepticonsSorted.count - survivorsDecepticons.count
        if eliminatedDecepticons > eliminatedAutobots {
            return .Autobot
        } else if eliminatedAutobots > eliminatedDecepticons {
            return .Decepticon
        } else {
            return nil
        }
    }
    
    ///Returns an array of decepticons which survived the battle
    func survivingDecepticons() -> [Transformer] {
        return survivorsDecepticons
    }
    
    ///Returns an array of autobots which survived the battle
    func survivingAutobots() -> [Transformer] {
        return survivorsAutobots
    }
}
