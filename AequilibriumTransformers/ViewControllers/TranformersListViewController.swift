//
//  TranformersListViewController.swift
//  AequilibriumTransformers
//
//  Created by Lucas Skierkowski on 30/12/2020.
//

import UIKit

/**
 Protocol for datasource of `TranformersListViewController`
 Loads initial data and returns items for presentation. Allows modification of items in datasource.
 */
protocol TranformersListViewControllerDataSource: class {
    func loadData(completion: @escaping () -> Void)
    func numberOfItems() -> Int
    func itemForRow(row: Int) -> Transformer
    func deleteItem(row: Int, completion: @escaping () -> Void)
    func addEditTransformer(transformer: Transformer, completion: @escaping () -> Void)
    func allItems() -> [Transformer]
}

/**
 Presents list of transformers from the datasource.
 On initial load the loading indicator will be shown allowing async load from API datasource. 
 */
class TranformersListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startButton: UIButton!
    
    var indicatorBackground = UIView()
    
    var dataSource: TranformersListViewControllerDataSource? = TransformersListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        activityStartAnimating()
        dataSource?.loadData {[weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.activityStopAnimating()
            }
        }
    }
    
    ///Setups navigation, tableview, start battle button and loading view
    private func setupViews() {
        title = "Transformers"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTransformer))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TransformerTableViewCell", bundle: nil), forCellReuseIdentifier: "TransformerTableViewCell")
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        tableView.tableFooterView = UIView()
        
        startButton.layer.cornerRadius = 5
        
        view.addSubview(indicatorBackground)
        indicatorBackground.frame = CGRect.init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        indicatorBackground.backgroundColor = view.backgroundColor
        
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = view.center
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.startAnimating()
        indicatorBackground.addSubview(activityIndicator)
        
        indicatorBackground.isHidden = true
    }
    
    private func activityStartAnimating() {
        view.isUserInteractionEnabled = false
        indicatorBackground.isHidden = false
    }

    private func activityStopAnimating() {
        indicatorBackground.isHidden = true
        view.isUserInteractionEnabled = true
    }
    
    @objc func addTransformer() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEditTransformerViewController") as! AddEditTransformerViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func startBattle(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TransformersBattleViewController") as! TransformersBattleViewController
        vc.dataSource = TransformersBattleViewModel(transformers: dataSource?.allItems() ?? [])
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension TranformersListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfItems() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransformerTableViewCell") as! TransformerTableViewCell
        if let transformer = dataSource?.itemForRow(row: indexPath.row) {
            cell.setupCell(transformer: transformer)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let transformer = dataSource?.itemForRow(row: indexPath.row) {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEditTransformerViewController") as! AddEditTransformerViewController
            vc.transformer = transformer
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            activityStartAnimating()
            dataSource?.deleteItem(row: indexPath.row, completion: {[weak self] in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.activityStopAnimating()
                }
            })
        }
    }
}

extension TranformersListViewController: AddEditTransformerViewControllerDelegate {
    func transformerEditingFinished(transformer: Transformer) {
        activityStartAnimating()
        dataSource?.addEditTransformer(transformer: transformer, completion: {[weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.activityStopAnimating()
            }
        })
    }
}
