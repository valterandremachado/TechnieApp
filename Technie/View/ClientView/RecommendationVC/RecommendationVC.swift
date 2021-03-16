//
//  RecommendationVC.swift
//  Technie
//
//  Created by Valter A. Machado on 2/8/21.
//

import UIKit
import MapKit

class RecommendationVC: UIViewController {

    
    var recommendedTechniciansModel = [TechnicianModel]()
    var userNotification: ClientNotificationModel?
    var jobPostKeyPath = ""
    var posts = [PostModel]()
    
    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.showsVerticalScrollIndicator = false
//        tv.rowHeight = 400
        // Set automatic dimensions for row height
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
        
        /// Fix extra padding space at the top of the section of grouped tableView
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tv.tableHeaderView = UIView(frame: frame)
        tv.tableFooterView = UIView(frame: frame)
//        tv.contentInsetAdjustmentBehavior = .never
        
        tv.delegate = self
        tv.dataSource = self
        // Register Custom Cells for each section
        tv.register(RecommendationCell.self, forCellReuseIdentifier: RecommendationCell.cellID)
        return tv
    }()
    
    let proficiencyInDecimal: [Double] = [0.25, 0.50, 0.75, 1.0]
    var workSpeed = 0
    var workQuality = 0
    var responseTime = 0
    
    private var indicator: ProgressIndicatorLarge!

    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        view.backgroundColor = .cyan
//        print("jobPostKeyPath: ", jobPostKeyPath)
        
        indicator = ProgressIndicatorLarge(inview: self.view, loadingViewColor: UIColor.clear, indicatorColor: UIColor.gray, msg: "")
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        if recommendedTechniciansModel.count == 0 {
            indicator.start()
        }
        
        fetchUserPosts()
        fetchRecommendedTechnicians()
        setupViews()
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [tableView, indicator].forEach {view.addSubview($0)}
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        NSLayoutConstraint.activate([
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            indicator.heightAnchor.constraint(equalToConstant: 50),
            indicator.widthAnchor.constraint(equalToConstant: 50),
        ])
        
        setupNavBar()
    }
    
    fileprivate func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
//        navBar.clearNavBarAppearance()
        navBar.topItem?.title = "Recommended"
//        navBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .automatic
        let leftNavBarButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(leftNavBarBtnTapped))

        self.navigationItem.leftBarButtonItem = leftNavBarButton
//        self.navigationItem.rightBarButtonItem = rightNavBarButton
    }
    
    fileprivate func fetchRecommendedTechnicians() {
        
        DatabaseManager.shared.getRecommendedTechnicians(postChildPath: jobPostKeyPath) { [self] result in
            switch result {
            case .success(let recommendedTechnicians):
//                self.recommendedTechniciansModel = recommendedTechnicians
                
//                let delay = 0.03 + 1.25
//                Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
                    self.getRecommendedTechnicians(model: recommendedTechnicians)
                    self.indicator.stop()
                   
//                }
                
               
//                recommendedTechnicians.forEach { technician in
//                    // append only technicians with review history and rating of 4 and above
//                    workSpeed = Int(technician.clientsSatisfaction?.workSpeedAvrg.rounded(.toNearestOrAwayFromZero) ?? -1)
//                    workQuality = Int(technician.clientsSatisfaction?.workQualityAvrg.rounded(.toNearestOrAwayFromZero) ?? -1)
//                    responseTime = Int(technician.clientsSatisfaction?.responseTimeAvrg.rounded(.toNearestOrAwayFromZero) ?? -1)
//                    if workSpeed != -1 && workSpeed != -1 && workSpeed != -1 {
//                        // Avoid duplicated items
//                        if self.recommendedTechniciansModel.count > 0 {
//
//                            self.recommendedTechniciansModel.forEach { technicians in
//                                if technicians.profileInfo.email != technician.profileInfo.email {
//                                    self.recommendedTechniciansModel.append(technician)
//                                    self.tableView.reloadData()
//                                }
//                            }
//
//                        } else {
//                            self.recommendedTechniciansModel.append(technician)
//                            self.tableView.reloadData()
//                        }
//
//                    }
//                }
                

            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func getRecommendedTechnicians(model: [TechnicianModel]) {
        guard let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }

//        Recommendation Engine ✅
//        Nearby = 7km and lesser ✅
//        Efficiency = 65% up ✅
//        Rating = 4 stars up ✅
      
        for index in 0..<model.count {

            let model = model[index]
            // append only technicians with review history and rating of 4 and above
            self.workSpeed = Int(model.clientsSatisfaction?.workSpeedAvrg.rounded(.toNearestOrAwayFromZero) ?? 0.0)
            self.workQuality = Int(model.clientsSatisfaction?.workQualityAvrg.rounded(.toNearestOrAwayFromZero) ?? 0.0)
            self.responseTime = Int(model.clientsSatisfaction?.responseTimeAvrg.rounded(.toNearestOrAwayFromZero) ?? 0.0)

            let sum = proficiencyInDecimal[workSpeed] + proficiencyInDecimal[workQuality] + proficiencyInDecimal[responseTime]
            let efficiency = sum/3 * 100
            
            let clientLat = getUsersPersistedInfo.location.lat
            let clientLong = getUsersPersistedInfo.location.long
            let technicianLat = model.profileInfo.location?.lat ?? 0.0
            let technicianLong = model.profileInfo.location?.long ?? 0.0

            // Client location
            let clientLocation = CLLocation(latitude: clientLat, longitude: clientLong) //baguio
            //  Technician location
            let technicianLocation = CLLocation(latitude: technicianLat, longitude: technicianLong) //la trinidad
            //Finding my distance to my next destination (in km)
            let distance = clientLocation.distance(from: technicianLocation) / 1000
            
            if (efficiency >= 65 && model.clientsSatisfaction?.ratingAvrg ?? 0.0 >= 4 && distance <= 7) {
                if self.recommendedTechniciansModel.filter({ $0.profileInfo.id.contains(model.profileInfo.id) }).isEmpty {
                    self.recommendedTechniciansModel.append(model)
                    self.tableView.reloadData()
                }
            }

        } // End of loop
    }
    
    fileprivate func fetchUserPosts()  {
        DatabaseManager.shared.getAllClientPosts(completion: { [self] result in
            switch result {
            case .success(let userPosts):
                posts = userPosts
            case .failure(let error):
                print(error)
            }
        })
    }
    
    // MARK: - Selectors
    
    @objc fileprivate func leftNavBarBtnTapped() {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - TableViewDataSourceAndDelegate Extension
extension RecommendationVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendedTechniciansModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecommendationCell.cellID, for: indexPath) as! RecommendationCell
        let recommendedTechnicians = recommendedTechniciansModel[indexPath.row]
        cell.recommendedTechniciansModel = recommendedTechnicians
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recommendedTechnicians = recommendedTechniciansModel[indexPath.row]

        let vc = TechnicianProfileDetailsVC()
        vc.technicianModel = recommendedTechnicians
        vc.userPostModel = posts
        vc.profileImageView.sd_setImage(with: URL(string: recommendedTechnicians.profileInfo.profileImage ?? "")) 
        vc.nameLabel.text = recommendedTechnicians.profileInfo.name
        vc.locationLabel.text = recommendedTechnicians.profileInfo.location?.address
        vc.technicianExperienceLabel.text = "• \(recommendedTechnicians.profileInfo.experience) Year of Exp."
        
        let delimiter = "at"
        let slicedString = recommendedTechnicians.profileInfo.membershipDate.components(separatedBy: delimiter)[0]
        vc.memberShipDateLabel.text = "• Member since " + slicedString
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // remove bottom extra 20px space.
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // remove bottom extra 20px space.
        return .leastNormalMagnitude
    }
    
    
}

// MARK: - RecommendationVCPreviews
import SwiftUI

struct RecommendationVCPreviews: PreviewProvider {
    
    static var previews: some View {
        let vc = RecommendationVC()
        return vc.liveViewController
    }
    
}
