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
    var allTechnicians = [TechnicianModel]()
    var filteredRanking = [TechnicianModel]()
    var sortedRanking = [TechnicianModel]()
    var userPostModel: [PostModel] = []
    
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
        backgroundColor = .systemBackground
        fetchAllTechnician()
        listenToRankChanges()
        print("TechnieRankingCell")
        setupViews()
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [technieRankingCollectionView].forEach {self.addSubview($0)}

        technieRankingCollectionView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    let proficiencyInDecimal: [Double] = [0.25, 0.50, 0.75, 1.0]
    var workSpeed = 0
    var workQuality = 0
    var responseTime = 0
    
    fileprivate func fetchAllTechnician()  {
        
        DatabaseManager.shared.getAllTechnicians(completion: {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let technician):
                self.allTechnicians.append(technician)
                print("allTechnicians")

//                let delay = 0.03 + 1.25
//                Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
                self.buildTechniciansRanking(technician: technician)
//                }
            case .failure(let error):
                print("Failed to get technicians: \(error.localizedDescription)")
            }
        })
    }
    
    fileprivate func buildTechniciansRanking(technician: TechnicianModel) {
//        Efficiency = 65%(not lesser) “ranking standard” ✅
//        Rating = 4 stars up ✅
        
        var allTechniciansModel: [TechnicianModel] = []
        allTechniciansModel.append(technician)
        for index in 0..<allTechniciansModel.count {

            let model = allTechniciansModel[index]
            // append only technicians with review history and rating of 4 and above
            self.workSpeed = Int(model.clientsSatisfaction?.workSpeedAvrg.rounded(.toNearestOrAwayFromZero) ?? 0.0)
            self.workQuality = Int(model.clientsSatisfaction?.workQualityAvrg.rounded(.toNearestOrAwayFromZero) ?? 0.0)
            self.responseTime = Int(model.clientsSatisfaction?.responseTimeAvrg.rounded(.toNearestOrAwayFromZero) ?? 0.0)

//            let proficiencyInPercentage = "\(String(format:"%.0f", sum/3 * 100))%"
            let sum = proficiencyInDecimal[workSpeed] + proficiencyInDecimal[workQuality] + proficiencyInDecimal[responseTime]
            let efficiency = sum/3 * 100
            guard let technicianRatingAvrg = model.clientsSatisfaction?.ratingAvrg else { return }
            
            if (efficiency >= 65 && technicianRatingAvrg >= 4) {

                guard self.filteredRanking.filter({ $0.profileInfo.id.contains(model.profileInfo.id) }).isEmpty else { return }
                self.filteredRanking.append(model)
                let sortedArray = self.filteredRanking.sorted(by: {
                    let satisAvrOne = $0.clientsSatisfaction!.workSpeedAvrg + $0.clientsSatisfaction!.workQualityAvrg + $0.clientsSatisfaction!.responseTimeAvrg
                    let satisAvrTwo = $1.clientsSatisfaction!.workSpeedAvrg + $1.clientsSatisfaction!.workQualityAvrg + $1.clientsSatisfaction!.responseTimeAvrg
                    return satisAvrOne > satisAvrTwo
                })
                sortedRanking = sortedArray
                self.technieRankingCollectionView.reloadData()
                DatabaseManager.shared.insertTechnieRanking(withSortedRank: sortedRanking) { _ in
                }

            }

        } // End of loop
       
    }
    
    fileprivate func listenToRankChanges() {
        DatabaseManager.shared.listenToTechnieRankChanges { [self] succcess in
            if succcess {
                print("listenToRankChanges")
                filteredRanking.removeAll()
                sortedRanking.removeAll()
                fetchAllTechnician()
                self.technieRankingCollectionView.reloadData()
            }
        }
    }
    
    // MARK: - Selectors

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - TechnieRankingCell Extension
extension TechnieRankingCell: CollectionDataSourceAndDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedRanking.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: innerCellID, for: indexPath) as! TechnieRankingInnerCell
        let technieRank = sortedRanking[indexPath.item]
        cell.technieRankModel = technieRank
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        return CGSize(width: screenSize.width/2.35, height: screenSize.width/1.86)// frame.height/1.35
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexPath = indexPath
        let model = sortedRanking[indexPath.item]
        
        let vc = RankedTechnieVC()
        vc.technicianModel = model
        vc.userPostModel = userPostModel
        vc.technicianCoverPicture.sd_setImage(with: URL(string: model.profileInfo.profileImage ?? ""))
        let nameDelimiter = " "
        let nameSlicedString = model.profileInfo.name.components(separatedBy: nameDelimiter)

        vc.technicianNameLabel.text = "\(nameSlicedString[0])\n\(nameSlicedString[1])"
        vc.briefSummaryLabel.text = model.profileInfo.profileSummary
        vc.rankingLabel.text = "• Technie Rank: \(indexPath.item + 1)/\(sortedRanking.count)"
        vc.technicianExperienceLabel.text = "• \(model.profileInfo.experience) year of Exp."
        
        let delimiter = "at"
        let slicedString = model.profileInfo.membershipDate.components(separatedBy: delimiter)[0]
        vc.memberShipDateLabel.text = "• Member since " + slicedString
//        vc.modalTransitionStyle = .crossDissolve
        
        guard let presentVCFromCell = UIApplication.cellDidPresentViewController() else { return }
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
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.withSize(CGSize(width: 80, height: 80))
        iv.layer.cornerRadius = iv.frame.size.width/2
        iv.layer.masksToBounds = false
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray6
        iv.contentMode = .scaleAspectFill
//        iv.image = UIImage(named: "technieDummyPhoto")
        return iv
    }()
    
    lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Valter A. Machado"
        lbl.textAlignment = .center
//        lbl.withHeight(25)
        lbl.font = .boldSystemFont(ofSize: 12)
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
        lbl.font = .systemFont(ofSize: 12)
//        lbl.backgroundColor = .yellow

        lbl.text = "Expertise description"
        return lbl
    }()
    
    lazy var numberOfServiceLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = UIColor.systemPink.withAlphaComponent(0.5)
        lbl.layer.cornerRadius = 15
        lbl.clipsToBounds = true
        lbl.font = .systemFont(ofSize: 15)
        lbl.text = "300 services"
        lbl.textAlignment = .center
        lbl.textColor = UIColor(named: "LabelPrimaryAppearance")
        let screenSize = UIScreen.main.bounds
        lbl.withWidth(screenSize.width/2.35 - 50)
        lbl.withHeight(30)
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
        var wiredProfileImage = UIImage(systemName: "star.fill", withConfiguration: config)?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        
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
        let config = UIImage.SymbolConfiguration(pointSize: 13, weight: .bold, scale: .small)
        var wiredProfileImage = UIImage(named: "commentary" ,in: nil, with: config)?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        
        let iconIV = UIImageView()
        iconIV.contentMode = .scaleAspectFit
        iconIV.image = wiredProfileImage
//        iconIV.backgroundColor = .brown
        iconIV.withWidth(17)
        let sv = UIStackView(arrangedSubviews: [iconIV, reviewLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 2
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
    
    lazy var ratingAndReviewStackView: UIStackView = {
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
        sv.spacing = 2
        sv.distribution = .fillProportionally
        return sv
    }()
    
    lazy var stackView2: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [stackView1, numberOfServiceLabel])
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 10
        sv.distribution = .fillProportionally
        return sv
    }()
    
    var technieRankModel: TechnicianModel! {
        didSet {
            profileImageView.sd_setImage(with: URL(string: technieRankModel.profileInfo.profileImage ?? ""))
            nameLabel.text = technieRankModel.profileInfo.name
            detailLabel.text = "\(technieRankModel.profileInfo.skills.randomElement() ?? "")"
            let services = technieRankModel.numberOfServices
            var serviceLabel = ""
            services == 1 ? (serviceLabel = "service") : (serviceLabel = "services")
            numberOfServiceLabel.text = "\(services) \(serviceLabel)"
            ratingLabel.text = (String(format: "%.1f", technieRankModel.clientsSatisfaction?.ratingAvrg ?? 0))
            let reviewCount = String(technieRankModel.clientsSatisfaction?.numberOfReview ?? 0)
            reviewLabel.text = " \(reviewCount)"
        }
    }
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = UIColor.rgb(red: 235, green: 235, blue: 235)//.darkGray
        layer.cornerRadius = 16
        clipsToBounds = true
        setupViews()
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [stackView2, profileImageView, ratingAndReviewStackView].forEach {self.addSubview($0)}
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            profileImageView.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        stackView2.anchor(top: profileImageView.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10))
        
        ratingAndReviewStackView.anchor(top: stackView2.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10))
        
        
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
