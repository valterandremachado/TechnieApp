//
//  TechnieRankingCell.swift
//  Technie
//
//  Created by Valter A. Machado on 12/17/20.
//
import UIKit
import LBTATools

class TechnieRankingCell: UICollectionViewCell {
    
    private let innerCellID = "innerCellID"
    // MARK: - Properties
    lazy var technieRankingCollectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.minimumLineSpacing = 10
        collectionLayout.minimumInteritemSpacing = 5
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        
        cv.register(TechnieRankingInnerCell.self, forCellWithReuseIdentifier: innerCellID)
        return cv
    }()
    var indexPath: IndexPath = IndexPath(item: 0, section: 0)
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white
        setupViews()
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [technieRankingCollectionView].forEach {self.addSubview($0)}

        technieRankingCollectionView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
    }
    
    // MARK: - Selectors

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - TechnieRankingCell Extension
extension TechnieRankingCell: CollectionDataSourceAndDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: innerCellID, for: indexPath) as! TechnieRankingInnerCell

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        return CGSize(width: screenSize.width/1.8, height: frame.height - 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexPath = indexPath
        let vc = RankedTechnieVC()
//        vc.modalTransitionStyle = .crossDissolve
        vc.stringPrint = "\(indexPath.item)"
        
        guard let presentVCFromCell = UIApplication.cellDidPresentViewController() else { return }
//        presentVCFromCell.navigationController?.show(rankedTechnieVC, sender: nil)
        
        let vcWithEmbeddedNav = UINavigationController(rootViewController: vc)
//        vcWithEmbeddedNav.modalPresentationStyle = .fullScreen
        presentVCFromCell.present(vcWithEmbeddedNav, animated: true)

//        print("IndexPath: \(indexPath.item)")
    }
    
    
}


// MARK: - InnerCell of the TechnieRankingCell
class TechnieRankingInnerCell: UICollectionViewCell {
    
    // MARK: - Properties
//    lazy var saveBtn: UIButton = {
//        let config = UIImage.SymbolConfiguration(pointSize: CGFloat(20))
////        var image = UIImage(systemName: "bookmark", withConfiguration: config)?.withTintColor(.blue, renderingMode: .alwaysOriginal)
//
//        let btn = UIButton(type: .system)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.setTitle("Save", for: .normal)
////        btn.setImage(image, for: .normal)
////        btn.backgroundColor = .red
////        btn.withSize(CGSize(width: 50, height: 50))
////        btn.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
//        return btn
//    }()
    
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.withSize(CGSize(width: 80, height: 80))
        iv.layer.cornerRadius = iv.frame.size.height/2
        iv.layer.masksToBounds = false
        iv.clipsToBounds = true
//        iv.backgroundColor = .brown
        iv.image = UIImage(named: "technieDummyPhoto")
        return iv
    }()
    
    lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Valter A. Machado"
        lbl.textAlignment = .center
        lbl.withHeight(25)
//        lbl.backgroundColor = .brown
        lbl.numberOfLines = 0
        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")
        return lbl
    }()
    
    lazy var detailLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .lightGray
//        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
//        lbl.withHeight(80)
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 15)
//        lbl.backgroundColor = .yellow

        lbl.text = "Best worker of this week"
        return lbl
    }()
    
    lazy var numberOfServiceLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = UIColor.systemPink.withAlphaComponent(0.5)
        lbl.layer.cornerRadius = 15
        lbl.clipsToBounds = true
        lbl.text = "300 services"
        lbl.textAlignment = .center
        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")

        lbl.withWidth(140)
        lbl.withHeight(33)
        return lbl
    }()
    
    lazy var ratingLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "4.9"
        lbl.font = .systemFont(ofSize: 15)
        lbl.textAlignment = .center
        lbl.numberOfLines = .zero
        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")
//        lbl.backgroundColor = .blue
//        lbl.withWidth(35)
        return lbl
    }()
    
    lazy var reviewLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "300" //Reviews
        lbl.font = .systemFont(ofSize: 15)
        lbl.numberOfLines = .zero
        lbl.textAlignment = .left
        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")
//        lbl.backgroundColor = .red
        return lbl
    }()
    
    lazy var ratingStackView: UIStackView = {
        let config = UIImage.SymbolConfiguration(pointSize: CGFloat(15))
        var wiredProfileImage = UIImage(systemName: "location.fill", withConfiguration: config)?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        
        let iconIV = UIImageView()
        iconIV.contentMode = .scaleAspectFit
        iconIV.image = wiredProfileImage
//        iconIV.backgroundColor = .brown
        iconIV.withWidth(20)
        let sv = UIStackView(arrangedSubviews: [iconIV, ratingLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 0
        sv.alignment = .center
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .lightGray)
//        sv.withWidth(110)
        return sv
    }()
    
    lazy var reviewStackView: UIStackView = {
        let config = UIImage.SymbolConfiguration(pointSize: CGFloat(15))
        var wiredProfileImage = UIImage(systemName: "location.fill", withConfiguration: config)?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        
        let iconIV = UIImageView()
        iconIV.contentMode = .scaleAspectFit
        iconIV.image = wiredProfileImage
//        iconIV.backgroundColor = .brown
        iconIV.withWidth(20)
        let sv = UIStackView(arrangedSubviews: [iconIV, reviewLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 1
        sv.alignment = .center
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .cyan)
//        sv.withWidth(110)
        return sv
    }()
    
    lazy var ratingCustomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .yellow
        return view
    }()
    
    lazy var reviewCustomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .brown
        return view
    }()
    
    lazy var ratingAndReviewtackView: UIStackView = {
        var separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .lightGray

        let sv = UIStackView(arrangedSubviews: [ratingCustomView, reviewCustomView])
        sv.translatesAutoresizingMaskIntoConstraints = false

        sv.axis = .horizontal
//        sv.alignment = .center
        sv.spacing = 0
        sv.distribution = .fillEqually
//        sv.addBackground(color: .gray)
        sv.withHeight(40)

        // Add stackView inside the views in the ratingAndReviewtackView
        ratingCustomView.addSubview(ratingStackView)
        NSLayoutConstraint.activate([
            ratingStackView.centerXAnchor.constraint(equalTo: ratingCustomView.centerXAnchor),
            ratingStackView.centerYAnchor.constraint(equalTo: ratingCustomView.centerYAnchor),
            ratingStackView.heightAnchor.constraint(equalToConstant: 40),
            ratingStackView.widthAnchor.constraint(equalToConstant: 44)
        ])
        
        reviewCustomView.addSubview(reviewStackView)
        NSLayoutConstraint.activate([
            reviewStackView.centerXAnchor.constraint(equalTo: reviewCustomView.centerXAnchor),
            reviewStackView.centerYAnchor.constraint(equalTo: reviewCustomView.centerYAnchor),
            reviewStackView.heightAnchor.constraint(equalToConstant: 40),
            reviewStackView.widthAnchor.constraint(equalToConstant: 57)
        ])
        
        sv.addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.centerXAnchor.constraint(equalTo: sv.centerXAnchor),
            separatorView.centerYAnchor.constraint(equalTo: sv.centerYAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 25),
            separatorView.widthAnchor.constraint(equalToConstant: 1)
        ])
        
        return sv
    }()
    
    lazy var stackView1: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameLabel, detailLabel])
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 5
        sv.distribution = .fillProportionally
        return sv
    }()
    
    lazy var stackView2: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [stackView1, numberOfServiceLabel])
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 25
        sv.distribution = .fillProportionally
        return sv
    }()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .darkGray
        layer.cornerRadius = 16
        clipsToBounds = true
        setupViews()
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [stackView2, profileImageView, ratingAndReviewtackView].forEach {self.addSubview($0)}
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            profileImageView.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        stackView2.anchor(top: profileImageView.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
        
        ratingAndReviewtackView.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        
        
    }
    
    // MARK: - Selectors
//    @objc func savePressed() {
//        print("123")
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - TechnieRankingCellPreviews
import SwiftUI

struct TechnieRankingCellPreviews: PreviewProvider {
   
    static var previews: some View {
        let cell = TechnieRankingCell()
        return cell.liveView
    }
}
