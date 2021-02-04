//
//  AboutVC.swift
//  Technie
//
//  Created by Valter A. Machado on 2/4/21.
//

import UIKit

class AboutVC: UIViewController {

    // MARK: - Properties
    static let shared = AboutVC()
    var customView = UIView()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .yellow
        
//        tv.isScrollEnabled = false
//        tv.showsVerticalScrollIndicator = false
//        tv.rowHeight = 40
        // Set automatic dimensions for row height
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
//        tv.layer.cornerRadius = 18
//        tv.clipsToBounds = true

//        var frame = CGRect.zero
//        frame.size.height = .leastNormalMagnitude
//        tv.tableHeaderView = UIView(frame: frame)
//        tv.tableFooterView = UIView(frame: frame)
//        tv.contentInsetAdjustmentBehavior = .never
        
        tv.delegate = self
        tv.dataSource = self
        tv.register(AboutCell.self, forCellReuseIdentifier: AboutCell.cellID)
        return tv
    }()
    
    var sectionSetter = [SectionHandler]()

    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
//            setupViews()
            print("viewDidLoad")

        sectionSetter.append(SectionHandler(title: "Summary", detail: ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus elit nisi, tempor at rhoncus id, porta tincidunt metus. Nulla dictum faucibus justo. Quisque non urna nec tortor cursus lobortis. Proin quis nunc nibh. Curabitur consequat gravida augue, vitae vestibulum sem eleifend ac. Maecenas facilisis molestie vehicula. Fusce pulvinar nisi a orci iaculis bibendum."]))
        sectionSetter.append(SectionHandler(title: "Skills", detail: ["skill", "skill", "skill", "skill", "skill"]))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }
    
    // MARK: - Methods
    func setupViews() {
        [tableView].forEach {view.addSubview($0)}
//        customView.addSubview(tableView)
//        view.bringSubviewToFront(tableView)
//        customView.backgroundColor = .cyan
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
//        tableView.anchor(top: customView.topAnchor, leading: customView.leadingAnchor, bottom: customView.bottomAnchor, trailing: customView.trailingAnchor)
        
//        NSLayoutConstraint.activate([
//            customView.widthAnchor.constraint(equalToConstant: 100),
//            customView.heightAnchor.constraint(equalToConstant: 100),
//            customView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            customView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//
////            customView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//        ])
    }
    
    // MARK: - Selectors

    
}

// MARK: - TableViewDelegateAndDataSource Extension
extension AboutVC: TableViewDataSourceAndDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionSetter.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionSetter[section].sectionDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AboutCell.cellID, for: indexPath) as! AboutCell
        let detailText = sectionSetter[indexPath.section].sectionDetail[indexPath.row]
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = detailText
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionSetter[section].sectionTitle
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
