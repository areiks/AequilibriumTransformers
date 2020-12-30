//
//  AddEditTransformerParameterTableViewCell.swift
//  AequilibriumTransformers
//
//  Created by Lucas Skierkowski on 30/12/2020.
//

import UIKit

/**
 Delegate of `AddEditTransformerParameterTableViewCell`.
 Called on each update of the parameter. Also notifies controller that edit has started.
 */
protocol AddEditTransformerParameterTableViewCellDelegate: class {
    func parameterUpdated(parameter: TransformerParameter, value: String)
    func editStarted(id: Int)
}

/**
 Parameter cell for `AddEditTransformerViewController`.
 Responsible for presentation of the parameter and allows its edition
 */
class AddEditTransformerParameterTableViewCell: UITableViewCell {

    @IBOutlet weak var parameterTextField: UITextField!
    @IBOutlet weak var parameterNameLabel: UILabel!
    
    private let pickerView = UIPickerView()
    private var parameter: TransformerParameter = .name(nil)
    private let pickerIntValues = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    private let pickerTeamValues = [TransformerTeam.Autobot, TransformerTeam.Decepticon]
    private var id = 0
    
    weak var delegate: AddEditTransformerParameterTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneEditing))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        parameterTextField.inputAccessoryView = toolBar
    }

    ///Setup of the cell for the given transformer parameter
    ///- parameter with: parameter which will be handled by the cell
    ///- parameter cellID: id used for notification of started modification of the parameter
    func setupCell(with: TransformerParameter, cellID: Int) {
        parameter = with
        parameterTextField.delegate = self
        pickerView.delegate = self
        parameterTextField.inputView = pickerView
        id = cellID
        
        switch parameter {
        case .name(let nameString):
            parameterNameLabel.text = "Name"
            parameterTextField.text = nameString
            parameterTextField.inputView = nil
        case .team(let team):
            parameterNameLabel.text = "Team"
            parameterTextField.text = team?.name()
        case .strength(let value):
            parameterNameLabel.text = "Strength"
            if let value = value {
                parameterTextField.text = String(value)
            }
        case .intelligence(let value):
            parameterNameLabel.text = "Intelligence"
            if let value = value {
                parameterTextField.text = String(value)
            }
        case .speed(let value):
            parameterNameLabel.text = "Speed"
            if let value = value {
                parameterTextField.text = String(value)
            }
        case .endurance(let value):
            parameterNameLabel.text = "Endurance"
            if let value = value {
                parameterTextField.text = String(value)
            }
        case .rank(let value):
            parameterNameLabel.text = "Rank"
            if let value = value {
                parameterTextField.text = String(value)
            }
        case .courage(let value):
            parameterNameLabel.text = "Courage"
            if let value = value {
                parameterTextField.text = String(value)
            }
        case .firepower(let value):
            parameterNameLabel.text = "Firepower"
            if let value = value {
                parameterTextField.text = String(value)
            }
        case .skill(let value):
            parameterNameLabel.text = "Skill"
            if let value = value {
                parameterTextField.text = String(value)
            }
        }
    }
    
    override func prepareForReuse() {
        parameterNameLabel.text = nil
        parameterTextField.text = nil
    }
    
    @objc func doneEditing() {
        contentView.endEditing(true)
    }
}

extension AddEditTransformerParameterTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.parameterUpdated(parameter: parameter, value: textField.text ?? "")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch parameter {
        case .team:
            return string == TransformerTeam.Autobot.name() || string == TransformerTeam.Decepticon.name() 
        case .name:
            return true
        default:
            return pickerIntValues.contains(string)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.editStarted(id: id)
    }
}

extension AddEditTransformerParameterTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch parameter {
        case .team:
            return pickerTeamValues.count
        default:
            return pickerIntValues.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch parameter {
        case .team:
            return pickerTeamValues[row].name()
        default:
            return pickerIntValues[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch parameter {
        case .team:
            parameterTextField.text = pickerTeamValues[row].name()
        default:
            parameterTextField.text = pickerIntValues[row]
        }
    }
}
