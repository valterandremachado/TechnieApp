//
//  ConvoVC.swift
//  Technie
//
//  Created by Valter A. Machado on 1/18/21.
//

import UIKit

class ConvoVC: UIViewController {

    // MARK: - Properties

    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
//        tv.tableFooterView = UIView()
        tv.showsVerticalScrollIndicator = false
        
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
        
        tv.delegate = self
        tv.dataSource = self
        tv.register(MessageTVCell.self, forCellReuseIdentifier: MessageTVCell.cellID)
        return tv
    }()
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .gray
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentActionSheet()
    }
    // MARK: - Methods
    func setupViews() {
        [tableView].forEach { view.addSubview($0)}
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        setupNavBar()
    }
    
    func presentActionSheet() {
        let actionController = UIAlertController(title: "Create an user", message: nil, preferredStyle: .alert)
        
        var textField = UITextField()
        actionController.addTextField { actionControllerTextField in
            actionControllerTextField.placeholder = "username"
            textField = actionControllerTextField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let createUserAction = UIAlertAction(title: "Create", style: .default) { createBtn in
            print("create")
            print(textField.text)
//            Auth.auth().signInAnonymously(completion: nil)
        }
        
        actionController.addAction(cancelAction)
        actionController.addAction(createUserAction)
        present(actionController, animated: true)
    }
    
    func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navigationItem.title = "Convos"
        navBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    func fetchConvo() {
        
    }
    // MARK: - Selectors

}

// MARK: - MessageKitDelegateAndDataSource Extension
extension ConvoVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTVCell.cellID, for: indexPath) as! MessageTVCell
        return cell
    }
    
    
}
