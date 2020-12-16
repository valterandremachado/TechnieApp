//
//  ViewController.swift
//  Technie
//
//  Created by Valter A. Machado on 12/16/20.
//

import UIKit
import LBTATools

typealias collectionViewDelegateAndDataSource = UICollectionViewDelegateFlowLayout & UICollectionViewDataSource
typealias TableViewDelegateAndDataSource = UITableViewDelegate & UITableViewDataSource

class ClientFeedVC: UIViewController {

    // Cells ID
    private let feedCellID = "feedCellID"
    
    // MARK: - Properties
    lazy var clientFeedCollectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumLineSpacing = 5
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear 
        
        cv.delegate = self
        cv.dataSource = self
        
        cv.register(FeedCell.self, forCellWithReuseIdentifier: feedCellID)
        
        return cv
    }()
    
    // MARK: - Init
    override func loadView() {
        super.loadView()
        setupNavBar()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupViews()
    }

    // MARK: - Methods
    fileprivate func setupViews(){
        [clientFeedCollectionView].forEach {view.addSubview($0)}
        
        clientFeedCollectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    func setupNavBar(){
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.topItem?.title = "Technie"
    }
    
    // MARK: - Selectors


}

// MARK: - Extension
extension ClientFeedVC: collectionViewDelegateAndDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = clientFeedCollectionView.dequeueReusableCell(withReuseIdentifier: feedCellID, for: indexPath) as! FeedCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewSize = view.frame.size
        let collectionViewSize = CGSize(width: viewSize.width - 10, height: 150)
        
        return collectionViewSize
    }
}
