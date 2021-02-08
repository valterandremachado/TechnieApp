//
//  ClientPostVC.swift
//  Technie
//
//  Created by Valter A. Machado on 12/16/20.
//

import UIKit

class ClientPostVC: UIViewController {
    private let cellID = "cellID"
    
    // MARK: - Properties
    lazy var collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumLineSpacing = 8
        collectionLayout.minimumInteritemSpacing = 8
        collectionLayout.estimatedItemSize = .zero
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Avoid collectionView to self adjust its size
        //        cv.contentInsetAdjustmentBehavior = .never
        
        cv.delegate = self
        cv.dataSource = self
        // Registration of the cell
        cv.register(ClientPostCell.self, forCellWithReuseIdentifier: cellID)
        return cv
    }()
    
    let professionArray = ["Handyman", "Electrician", "Repairer", "Others"]//Household Appliances Repairers

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupNavBar()
        setupViews()
    }
   
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationItem.title = ""
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        print("viewWillAppear")
//    }
    
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [collectionView].forEach{view.addSubview($0)}
        
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 8, bottom: 0, right: 8))
    }
    
    fileprivate func setupNavBar() {
        guard let nav = navigationController?.navigationBar else { return }
        nav.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Post Service"
    }
    
    // MARK: - Selectors
}

// MARK: - CollectionViewDelegateAndDataSource Extension
extension ClientPostVC: CollectionDataSourceAndDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return professionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ClientPostCell
        cell.backgroundColor = .gray
        cell.title.text = professionArray[indexPath.item]
        return cell
    }
    
    // CollectionView layouts
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 2
        /// changing sizeForItem when user switches through the segnment
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        //        flowLayout.sectionInset.left = 5
        //        flowLayout.sectionInset.right = 5
        
        let size = ((collectionView.bounds.width) - totalSpace) / CGFloat(noOfCellsInRow)
        let finalSize = CGSize(width: size, height: size)
        
//        let viewSize = view.frame.size
//        let collectionViewSize = CGSize(width: viewSize.width, height: 200)
//
//        if indexPath.item % 2 == 0 {
//            print("\(indexPath.item) is even number")
//            return finalSize
//          } else {
//            print("\(indexPath.item) is odd number")
//            return collectionViewSize
//          }
       
        
        return finalSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let collectionViewEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return collectionViewEdgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.item {
        case 1:
            print("index 0")
            let vc = PostFormVC()
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            print("index 3")
            let vc = PostFormVC()
            navigationController?.pushViewController(vc, animated: true)
        default:
            // present postSubSections
            let vc = PostSectionVC()
            vc.postSectionVCIndexPath = indexPath
//            vc.navigationItem.title = navigationItem.title
//            vc.navigationItem.backBarButtonItem?.title = ""
            vc.sectionTitle = professionArray[indexPath.item]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
