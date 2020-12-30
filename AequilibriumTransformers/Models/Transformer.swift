//
//  Transformer.swift
//  AequilibriumTransformers
//
//  Created by Lucas Skierkowski on 30/12/2020.
//

import Foundation

/**
 Team enum used in `Transformer` structs. Helpful also for team checks in battle logic.
 */
enum TransformerTeam: String, Codable {
    case Autobot = "A"
    case Decepticon = "D"
    
    init(withName: String) {
        if withName == "Autobot" {
            self = .Autobot
        } else {
            self = .Decepticon
        }
    }
    
    func name() -> String {
        switch self {
        case .Autobot:
            return "Autobot"
        case .Decepticon:
            return "Decepticon"
        }
    }
}

/**
 Main transformer struct used for parsing of the API data and passed around the app.
 */
struct Transformer: Codable, Equatable  {
    var id: String?
    var name: String
    var team: TransformerTeam
    var strength: Int
    var intelligence: Int
    var speed: Int
    var endurance: Int
    var rank: Int
    var courage: Int
    var firepower: Int
    var skill: Int
    var teamIcon: String?
    
    func overallRating() -> Int {
        return strength + intelligence + speed + endurance + firepower
    }
}

extension Transformer {
    init(id: String? = nil, name: String, team: TransformerTeam, rank: Int, parametersValue: Int) {
        self.id = id
        self.name = name
        self.team = team
        self.rank = rank
        strength = parametersValue
        intelligence = parametersValue
        speed = parametersValue
        endurance = parametersValue
        courage = parametersValue
        firepower = parametersValue
        skill = parametersValue
    }
}
