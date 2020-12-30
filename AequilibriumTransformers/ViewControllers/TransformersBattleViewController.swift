//
//  TransformersBattleViewController.swift
//  AequilibriumTransformers
//
//  Created by Lucas Skierkowski on 30/12/2020.
//

import UIKit

/**
 Datasource protocol for `TransformersBattleViewController`.
 Responsible for providing information about battle results.
 */
protocol TransformersBattleViewControllerDataSource: class {
    func numberOfBattles() -> Int 
    func winningTeam() -> TransformerTeam?
    func survivingDecepticons() -> [Transformer]
    func survivingAutobots() -> [Transformer]
}

/**
 View which presents transformer battle results.
 Presents winning team icon (if there is any) and labels containing:
 - number of battles
 - winning team name and survivors
 - losing team name and survivors
 In case of tie there will be two labels containing survivors from both sides.
 */
class TransformersBattleViewController: UIViewController {
    @IBOutlet weak var extraLabel: UILabel!
    @IBOutlet weak var losingTeamLabel: UILabel!
    @IBOutlet weak var winningTeamLabel: UILabel!
    @IBOutlet weak var battleLabel: UILabel!
    @IBOutlet weak var winnerImageView: UIImageView!
    
    var dataSource: TransformersBattleViewControllerDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        let battles = dataSource?.numberOfBattles() ?? 0
        var autobotsString = ""
        if dataSource?.survivingAutobots().count ?? 0 > 0 {
            autobotsString = " \(dataSource?.survivingAutobots().compactMap({$0.name}).joined(separator: ", ") ?? "")"
        }
        var decepticonsString = ""
        if dataSource?.survivingDecepticons().count ?? 0 > 0 {
            decepticonsString = " \(dataSource?.survivingDecepticons().compactMap({$0.name}).joined(separator: ", ") ?? "")"
        }
        battleLabel.text = "\(battles) battle\(battles == 1 ? "" : "s")"
        
        switch dataSource?.winningTeam() {
        case .none:
            winnerImageView.image = nil
            winningTeamLabel.text = "Tie"
            losingTeamLabel.text = "Survivors (Autobots):\(autobotsString)"
            extraLabel.text = "Survivors (Decepticons):\(decepticonsString)"
        case .Autobot:
            if let url = URL(string: dataSource?.survivingAutobots().first?.teamIcon ?? "") {
                winnerImageView.sd_setImage(with: url, completed: nil)
            }
            winningTeamLabel.text = "Winning team (Autobots):\(autobotsString)"
            losingTeamLabel.text = "Survivors from the losing team (Decepticons):\(decepticonsString)"
            extraLabel.text = ""
        case .Decepticon:
            if let url = URL(string: dataSource?.survivingDecepticons().first?.teamIcon ?? "") {
                winnerImageView.sd_setImage(with: url, completed: nil)
            }
            winningTeamLabel.text = "Winning team (Decepticons):\(decepticonsString)"
            losingTeamLabel.text = "Survivors from the losing team (Autobots):\(autobotsString)"
            extraLabel.text = ""
        }
    }
}
