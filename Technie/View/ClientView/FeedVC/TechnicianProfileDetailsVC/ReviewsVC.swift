//
//  ReviewsVC.swift
//  Technie
//
//  Created by Valter A. Machado on 2/4/21.
//

import UIKit

class ReviewsVC: UIViewController {

    lazy var ratingAndReviewsLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = " 4.5 | Reviews 40"//★
        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")

        return lbl
    }()
    
    lazy var ratingAndReviewsStackView: UIStackView = {
        let config = UIImage.SymbolConfiguration(pointSize: CGFloat(15))
        var wiredProfileImage = UIImage(systemName: "star.fill", withConfiguration: config)?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        
        let iconIV = UIImageView()
        iconIV.contentMode = .scaleAspectFit
        iconIV.image = wiredProfileImage
        
        let sv = UIStackView(arrangedSubviews: [iconIV, ratingAndReviewsLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 2
        sv.alignment = .center
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .red)
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupViews()
    }

    fileprivate func setupViews() {
        [ratingAndReviewsStackView].forEach {view.addSubview($0)}
        ratingAndReviewsStackView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil)

        NSLayoutConstraint.activate([
            ratingAndReviewsStackView.widthAnchor.constraint(equalToConstant: 155),
            ratingAndReviewsStackView.heightAnchor.constraint(equalToConstant: 30),
            ratingAndReviewsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            ratingAndReviewsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
//            ratingAndReviewsStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
        ])
//        ratingAndReviewsStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
    }
}
