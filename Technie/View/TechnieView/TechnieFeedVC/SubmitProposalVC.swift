//
//  SubmitProposalVC.swift
//  Technie
//
//  Created by Valter A. Machado on 1/31/21.
//

import UIKit
import FirebaseDatabase
import CodableFirebase

class SubmitProposalVC: UIViewController, UITextViewDelegate {

    var postID = ""
    var numberOfProposals: Int = 0
    
    var postModel: PostModel!

    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .systemBackground
        tv.showsVerticalScrollIndicator = false
        // Set automatic dimensions for row height
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
        
        /// Fix extra padding space at the top of the section of grouped tableView
//        var frame = CGRect.zero
//        frame.size.height = .leastNormalMagnitude
//        tv.tableHeaderView = UIView(frame: frame)
//        tv.tableFooterView = UIView(frame: frame)
//        tv.contentInsetAdjustmentBehavior = .never
        
        tv.delegate = self
        tv.dataSource = self
        tv.register(SubmitProposalCell.self, forCellReuseIdentifier: SubmitProposalCell.cellID)
        return tv
    }()
    
    lazy var txtLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Increase your chance to secure this job by writing the reason why you should be selected for this job."
        lbl.font = .systemFont(ofSize: 12)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var placeHolderLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Write a cover letter..."
        lbl.textColor = .systemGray
        lbl.font = .systemFont(ofSize: 15)
        return lbl
    }()
    
    lazy var coverLetterTextField: UITextView = {
        let txtView = UITextView()
        txtView.delegate = self
        txtView.font = .systemFont(ofSize: 15)
        txtView.textAlignment = .natural
//        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.backgroundColor = UIColor(named: "textViewBackgroundColor")
        txtView.clipsToBounds = true
        txtView.layer.cornerRadius = 10
        txtView.isEditable = true
        txtView.isScrollEnabled = false
        return txtView
    }()
    
    lazy var proposalBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Submit", for: .normal)
        btn.setTitleColor(.white, for: .normal)

//        btn.contentHorizontalAlignment = .left
        btn.layer.cornerRadius = 10
        btn.clipsToBounds = true
        btn.backgroundColor = .systemPink
//        btn.withWidth(view.frame.width - 100)
        btn.addTarget(self, action: #selector(proposalBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        self.tabBarController?.setTabBar(hidden: true, animated: true, along: nil)
    }
    
    // MARK: - Methods
    func setupViews() {
        [tableView].forEach { view.addSubview($0)}
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        setupNavBar()
    }

    fileprivate func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//        navBar.setBackgroundImage(UIImage(), for: .default)
        navigationItem.title = "Submission"
    }
    
    func presentDoneSubmissionAlertSheet() {
        let actionController = UIAlertController(title: "Submitted Successfully", message: "Your proposal was submitted to the post owner. Please wait for the client's feedback.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        actionController.addAction(okAction)
        present(actionController, animated: true)
    }
    
    // MARK: - Selectors
    private let database = Database.database().reference()

    @objc fileprivate func proposalBtnPressed() {
        guard let coverLetter = coverLetterTextField.text else { return }
        guard !coverLetter.replacingOccurrences(of: " ", with: "").isEmpty else { return}
        guard let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }
        let technicianEmail = getUsersPersistedInfo.email
        let technicianName = getUsersPersistedInfo.name
        let technicanUID = getUsersPersistedInfo.uid
        guard let clientKeyPath = postModel.postOwnerInfo?.keyPath else { return }
        guard let jobTitle = postModel.title as? String else { return }
        
        numberOfProposals += 1
        
        let updateElement = [
            "numberOfProposals": numberOfProposals,
        ] as [String : Any] //as? [AnyHashable: Any]
        
        
        let childPath = "posts/\(postID)"
        database.child(childPath).updateChildValues(updateElement, withCompletionBlock: { error, _ in
            self.database.child("\(childPath)/proposals").observeSingleEvent(of: .value, with: { snapshot in
                
                if var postsCollection = snapshot.value as? [[String: Any]] {
                    // append to user dictionary
                    let newElement = [
                        [
                            "technicianUID": technicanUID,
                            "technicianEmail": technicianEmail,
                            "coverLetter": coverLetter
                        ]
                    ]
                    
                    postsCollection.append(contentsOf: newElement)
                    self.database.child("\(childPath)/proposals").setValue(postsCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            return
                        }
                        
                        let clientNotificationModel = ClientNotificationModel(id: "nil",
                                                                              type: "Proposal",
                                                                              title: "Proposal",
                                                                              description: "\(technicianName) sent a proposal for \(jobTitle) job, please take a look on his cover letter.",
                                                                              dateTime: PostFormVC.dateFormatter.string(from: Date()))
                        DatabaseManager.shared.insertClientNotification(with: clientNotificationModel, with: clientKeyPath, completion: { _ in })
                        
                    })
                } else {
                    // create that array
                    let newElement = [
                        [
                            "technicianUID": technicanUID,
                            "technicianEmail": technicianEmail,
                            "coverLetter": coverLetter
                        ]
                    ]
                    
                    let clientNotificationModel = ClientNotificationModel(id: "nil",
                                                                          type: ClientNotificationType.proposal.rawValue,
                                                                          title: ClientNotificationType.proposal.rawValue,
                                                                          description: "\(technicianName) sent a proposal for \(jobTitle) job, please take a look on his cover letter.",
                                                                          dateTime: PostFormVC.dateFormatter.string(from: Date()))
                    DatabaseManager.shared.insertClientNotification(with: clientNotificationModel, with: clientKeyPath, completion: { _ in })
                    
                    self.database.child("\(childPath)/proposals").setValue(newElement, withCompletionBlock: { error, _ in
                    })
                }
            })
        })
        
        presentDoneSubmissionAlertSheet()
    }
    

}

// MARK: - Extension
extension SubmitProposalVC: TableViewDataSourceAndDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        if !textView.text.replacingOccurrences(of: " ", with: "").isEmpty {
            placeHolderLabel.fadeOut()
            placeHolderLabel.isHidden = true
        } else {
            placeHolderLabel.isHidden = false
            placeHolderLabel.fadeIn()
        }
    }
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubmitProposalCell.cellID, for: indexPath) as! SubmitProposalCell
        switch indexPath.row {
        case 0:
            [txtLabel, coverLetterTextField, placeHolderLabel].forEach{cell.contentView.addSubview($0)}
            
            txtLabel.anchor(top: cell.contentView.topAnchor, leading: cell.contentView.leadingAnchor, bottom: nil, trailing: cell.contentView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20), size: CGSize(width: 0, height: 0))
            
            coverLetterTextField.anchor(top: txtLabel.bottomAnchor, leading: cell.contentView.leadingAnchor, bottom: cell.contentView.bottomAnchor, trailing: cell.contentView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20), size: CGSize(width: 0, height: 0))
            
            placeHolderLabel.anchor(top: coverLetterTextField.topAnchor, leading: cell.contentView.leadingAnchor, bottom: coverLetterTextField.bottomAnchor, trailing: cell.contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        case 1:
            cell.contentView.addSubview(proposalBtn)
//            proposalBtn.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor).isActive = true
//            proposalBtn.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
////            proposalBtn.heightAnchor.constraint(equalToConstant: view.frame.width - 100).isActive = true
//            proposalBtn.widthAnchor.constraint(equalToConstant: view.frame.width - 100).isActive = true
            
            proposalBtn.anchor(top: cell.contentView.topAnchor, leading: cell.contentView.leadingAnchor, bottom: cell.contentView.bottomAnchor, trailing: cell.contentView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20), size: CGSize(width: 0, height: 35))
        default:
            break
        }
    
//        proposalBtn.anchor(top: coverLetterTextField.bottomAnchor, leading: cell.contentView.leadingAnchor, bottom: cell.contentView.bottomAnchor, trailing: cell.contentView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20), size: CGSize(width: 0, height: 0))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 55
        }

        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Aditional details"
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // remove bottom extra 20px space.
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // remove bottom extra 20px space.
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
}

// MARK: - SubmitProposalVCPreviews
import SwiftUI

struct SubmitProposalVCPreviews: PreviewProvider {
    
    static var previews: some View {
        let vc = SubmitProposalVC()
        return vc.liveViewController
    }
    
}
