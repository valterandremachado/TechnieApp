//
//  PhotoCollectionVC.swift
//  Technie
//
//  Created by Valter A. Machado on 1/29/21.
//

import UIKit
import SDWebImage

class PhotoCollectionViewerVC: UIViewController {

    var convoSharedPhotoArray = [String]()

    // MARK: - Properties
    lazy var collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumLineSpacing = 3
        collectionLayout.minimumInteritemSpacing = 2
//        collectionLayout.estimatedItemSize = .zero
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Avoid collectionView to self adjust its size
//        cv.contentInsetAdjustmentBehavior = .never
        
        cv.delegate = self
        cv.dataSource = self
//        cv.collectionViewLayout.invalidateLayout()
        // Registration of the cell
        cv.register(PhotoCollectionViewerCell.self, forCellWithReuseIdentifier: PhotoCollectionViewerCell.cellID)
        return cv
    }()
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupViews()
    }

    // MARK: - Methods
    func setupViews() {
//        title = "Shared Photos"
        [collectionView].forEach {view.addSubview($0)}
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        setupNavBar()
    }
    
    func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    // MARK: - Selectors


}

// MARK: - Extension
extension PhotoCollectionViewerVC: CollectionDataSourceAndDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return convoSharedPhotoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewerCell.cellID, for: indexPath) as! PhotoCollectionViewerCell
        cell.backgroundColor = .red
        
        let photosUrl = URL(string: convoSharedPhotoArray[indexPath.item])
        cell.imageView.sd_setImage(with: photosUrl, completed: nil)
        return cell
    }
    
    // CollectionView layouts
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 3

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow))
                flowLayout.sectionInset.left = 0
                flowLayout.sectionInset.right = 0
        
        let size = ((collectionView.bounds.width) - totalSpace) / CGFloat(noOfCellsInRow)
        let finalSize = CGSize(width: size, height: size)
        
        return finalSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photosUrl = URL(string: convoSharedPhotoArray[indexPath.item]) else { return }
        let vc = PhotoViewerVC(with: photosUrl)
        navigationController?.pushViewController(vc, animated: true)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        let collectionViewEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        return collectionViewEdgeInsets
//    }
    
}
