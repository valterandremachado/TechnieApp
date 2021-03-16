//
//  JobsFromSameClientVC.swift
//  Technie
//
//  Created by Valter A. Machado on 3/16/21.
//

import UIKit

class JobsFromSameClientVC: UIViewController {

    var userPostModel = [PostModel]()
    var exactUserPostModel = [PostModel]()

    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.showsVerticalScrollIndicator = false
//        tv.rowHeight = 40
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
        tv.delegate = self
        tv.dataSource = self
        
        /// Fix extra padding space at the top of the section of grouped tableView
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tv.tableHeaderView = UIView(frame: frame)
        tv.tableFooterView = UIView(frame: frame)
        tv.contentInsetAdjustmentBehavior = .never
        
        tv.register(JobsFromSameClientCell.self, forCellReuseIdentifier: JobsFromSameClientCell.cellID)
        return tv
    }()
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        userPostModel.forEach { post in
            guard self.exactUserPostModel.filter({ $0.id!.contains(post.id!) }).isEmpty else { return }
            self.exactUserPostModel.append(post)
        }
        
        setupViews()
        navigationItem.title = "Jobs"
    }
 
    // MARK: - Methods
    fileprivate func setupViews() {
        [tableView].forEach { view.addSubview($0) }
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    // MARK: - Selectors


}

// MARK: - Extension

extension JobsFromSameClientVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exactUserPostModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: JobsFromSameClientCell.cellID, for: indexPath) as! JobsFromSameClientCell
        
        cell = JobsFromSameClientCell(style: .subtitle, reuseIdentifier: JobsFromSameClientCell.cellID)
        cell.userPostModel = exactUserPostModel[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = exactUserPostModel[indexPath.row]
        let vc = JobDetailsVC()
        vc.postModel = model
        vc.navBarViewSubtitleLbl.text = "posted \(view.calculateTimeFrame(initialTime: model.dateTime))"
        vc.isComingFromServiceVC = true
        self.navigationController?.pushViewController(vc, animated: true)
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
