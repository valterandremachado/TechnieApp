//
//  RecommendationVC.swift
//  Technie
//
//  Created by Valter A. Machado on 2/8/21.
//

import UIKit

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
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        view.backgroundColor = .cyan
        DatabaseManager.shared.getRecommendedTechnicians(postChildPath: jobPostKeyPath) { result in
            switch result {
            case .success(let recommendedTechnicians):
                self.recommendedTechniciansModel = recommendedTechnicians
                print("recommendedTechnicians success")
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
        setupViews()
    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [tableView].forEach {view.addSubview($0)}
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
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
        let vc = TechnicianProfileDetailsVC()
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
