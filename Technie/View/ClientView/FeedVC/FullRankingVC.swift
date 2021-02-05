//
//  FullRankingVC.swift
//  Technie
//
//  Created by Valter A. Machado on 12/19/20.
//

import UIKit

class FullRankingVC: UIViewController {

    // MARK: - Properties
    lazy var collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumLineSpacing = 4
        collectionLayout.minimumInteritemSpacing = 6
        collectionLayout.estimatedItemSize = .zero

        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Avoid collectionView to self adjust its size
        //        cv.contentInsetAdjustmentBehavior = .never
        
        cv.delegate = self
        cv.dataSource = self
        // Registration of the cell
        cv.register(FullRankingCell.self, forCellWithReuseIdentifier: FullRankingCell.cellID)
        return cv
    }()
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupViews()
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [collectionView].forEach {view.addSubview($0)}
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right:  0))
        setupNavBar()
    }
    
    fileprivate func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navigationItem.title = "Ranking"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: - Selectors

}

// MARK: - CollectionDataSourceAndDelegate Extension
extension FullRankingVC: CollectionDataSourceAndDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 21
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FullRankingCell.cellID, for: indexPath) as! FullRankingCell
        cell.layer.cornerRadius = 16
        cell.clipsToBounds = true
        return cell
    }
    
    // CollectionView layouts
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 3
        /// changing sizeForItem when user switches through the segnment
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow))
//            flowLayout.sectionInset.left = 5
//            flowLayout.sectionInset.right = 5
        
        let size = ((collectionView.bounds.width) - totalSpace) / CGFloat(noOfCellsInRow)
        let screenSize = UIScreen.main.bounds

        let finalSize = CGSize(width: size, height: screenSize.width/1.86)
                
       return finalSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let collectionViewEdgeInsets = UIEdgeInsets(top: 5, left: 3, bottom: 5, right: 3)
        return collectionViewEdgeInsets
    }
}
