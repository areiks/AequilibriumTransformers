//
//  AddEditTransformerViewController.swift
//  AequilibriumTransformers
//
//  Created by Lucas Skierkowski on 30/12/2020.
//

import UIKit

/**
 Enum represeting transformer parameter. Used for setup of parameter cells.
 */
enum TransformerParameter {
    case name(String?)
    case team(TransformerTeam?)
    case strength(Int?)
    case intelligence(Int?)
    case speed(Int?)
    case endurance(Int?)
    case rank(Int?)
    case courage(Int?)
    case firepower(Int?)
    case skill(Int?)
}

/**
 Delegate which notifies previous controller that editing of transformer has finished.
 */
protocol AddEditTransformerViewControllerDelegate: class {
    func transformerEditingFinished(transformer: Transformer)
}

/**
 Main edit transformer view. Used on creating new transformer and editing existing one.
 */
class AddEditTransformerViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var scrollToRow: Int?
    
    var transformer: Transformer = Transformer(id: nil, name: "", team: .Autobot, strength: 1, intelligence: 1, speed: 1, endurance: 1, rank: 1, courage: 1, firepower: 1, skill: 1, teamIcon: nil)
    
    weak var delegate: AddEditTransformerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    ///Setups navigation and tableview
    private func setupViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(doneEditing))
        title = transformer.id != nil ? "Edit" : "New"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AddEditTransformerParameterTableViewCell", bundle: nil), forCellReuseIdentifier: "AddEditTransformerParameterTableViewCell")
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        
        if let id = scrollToRow {
            tableView.scrollToRow(at: IndexPath(row: id, section: 0), at: .bottom, animated: true)
            scrollToRow = nil
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    ///Called when editing has finished. Initially checks if name of transformer was provided (the only parameter not filled by default for a new transformer).
    @objc func doneEditing() {
        view.endEditing(true)
        if transformer.name.count < 1 {
            let alertController = UIAlertController(title: nil, message: "Please provide name", preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(actionOK)
            present(alertController, animated: true, completion: nil)
        } else {
            delegate?.transformerEditingFinished(transformer: transformer)
            navigationController?.popViewController(animated: true)
        }
    }
}

extension AddEditTransformerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddEditTransformerParameterTableViewCell") as! AddEditTransformerParameterTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.setupCell(with: .name(transformer.name), cellID: 0)
        case 1:
            cell.setupCell(with: .team(transformer.team), cellID: 1)
        case 2:
            cell.setupCell(with: .strength(transformer.strength), cellID: 2)
        case 3:
            cell.setupCell(with: .intelligence(transformer.intelligence), cellID: 3)
        case 4:
            cell.setupCell(with: .speed(transformer.speed), cellID: 4)
        case 5:
            cell.setupCell(with: .endurance(transformer.endurance), cellID: 5)
        case 6:
            cell.setupCell(with: .rank(transformer.rank), cellID: 6)
        case 7:
            cell.setupCell(with: .courage(transformer.courage), cellID: 7)
        case 8:
            cell.setupCell(with: .firepower(transformer.firepower), cellID: 8)
        case 9:
            cell.setupCell(with: .skill(transformer.skill), cellID: 9)
        default:
            return cell
        }
        
        cell.delegate = self
        return cell
    }
}

extension AddEditTransformerViewController: AddEditTransformerParameterTableViewCellDelegate {
    func parameterUpdated(parameter: TransformerParameter, value: String) {
        switch parameter {
        case .name:
            transformer.name = value
        case .team:
            transformer.team = TransformerTeam.init(withName: value)
        case .strength:
            transformer.strength = Int(value) ?? 1
        case .intelligence:
            transformer.intelligence = Int(value) ?? 1
        case .speed:
            transformer.speed = Int(value) ?? 1
        case .endurance:
            transformer.endurance = Int(value) ?? 1
        case .rank:
            transformer.rank = Int(value) ?? 1
        case .courage:
            transformer.courage = Int(value) ?? 1
        case .firepower:
            transformer.firepower = Int(value) ?? 1
        case .skill:
            transformer.skill = Int(value) ?? 1
        }
    }
    
    func editStarted(id: Int) {
        scrollToRow = id
    }
}
