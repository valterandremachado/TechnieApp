//
//  SkillSelectionVC2.swift
//  Technie
//
//  Created by Valter A. Machado on 1/10/21.
//

import UIKit
import TaggerKit

class SkillSelectionVC2: UIViewController {

//    var tagCollection = TKCollectionView()
    lazy var tagCollection: TKCollectionView = {
        let tag = TKCollectionView()
        tag.action = .removeTag
        tag.customBackgroundColor = .systemBlue
        return tag
    }()
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .yellow
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupViews()
    }
    
    func setupViews() {
        [containerView].forEach { view.addSubview($0) }
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15))
        add(tagCollection, toView: containerView)
//        containerView.addSubview(tagCollection.view)
        tagCollection.tags = ["Some", "Tag", "For", "You", "Tag", "For", "You", "Tag", "For", "You"]

    }

}
