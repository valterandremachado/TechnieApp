//
//  SummaryVC.swift
//  Technie
//
//  Created by Valter A. Machado on 3/11/21.
//

import UIKit
import FirebaseDatabase

class SummaryVC: UIViewController, UITextViewDelegate {

    let database = Database.database().reference()
    
    // MARK: - Properties
//    lazy var txtLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.translatesAutoresizingMaskIntoConstraints = false
//        lbl.text = "SUMMARY"
//        lbl.font = .systemFont(ofSize: 18)
//        lbl.numberOfLines = 0
//        lbl.isHidden = true
//        return lbl
//    }()
    
    lazy var placeHolderLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Summary..."
        lbl.textColor = .systemGray
        lbl.font = .systemFont(ofSize: 15)
        lbl.isHidden = true
        return lbl
    }()
    
    lazy var summaryTextField: UITextView = {
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
        txtView.isHidden = true
        return txtView
    }()
    
    private var indicator: ProgressIndicatorLarge!
    private var technicianModel: TechnicianModel?
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        indicator = ProgressIndicatorLarge(inview: self.view, loadingViewColor: UIColor.clear, indicatorColor: UIColor.gray, msg: "")
        indicator.translatesAutoresizingMaskIntoConstraints = false

        getTechnicianInfo()
        setupViews()
    }
    
    // MARK: - Methods
    private func setupViews() {
        [summaryTextField, placeHolderLabel, indicator].forEach {view.addSubview($0)}
        
//        txtLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20), size: CGSize(width: 0, height: 0))
        
        summaryTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20), size: CGSize(width: 0, height: 0))
        
        placeHolderLabel.anchor(top: summaryTextField.topAnchor, leading: view.leadingAnchor, bottom: summaryTextField.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        
        NSLayoutConstraint.activate([
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            indicator.heightAnchor.constraint(equalToConstant: 50),
            indicator.widthAnchor.constraint(equalToConstant: 50),
        ])
        
        setupNavBar()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Summary"
        
        let leftNavBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(leftNavBarBtnTapped))
        let rightNavBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(rightNavBarBtnTapped))
        
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        self.navigationItem.rightBarButtonItem = rightNavBarButton
    }
    
    private func getTechnicianInfo() {
        indicator.start()

        guard let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }
        let technicianKeyPath = getUsersPersistedInfo.uid

        DatabaseManager.shared.getSpecificTechnician(technicianKeyPath: technicianKeyPath) { result in
            switch result {
            case .success(let technicianInfo):
                self.technicianModel = technicianInfo
                
                UIView.animate(withDuration: 0.5) { [self] in
                    indicator.stop()
                    summaryTextField.isHidden = false
                    placeHolderLabel.fadeOut()
//                    placeHolderLabel.isHidden = false
//                    txtLabel.isHidden = false
                    summaryTextField.text = technicianInfo.profileInfo.profileSummary
//                    view.layoutIfNeeded()
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if !textView.text.replacingOccurrences(of: " ", with: "").isEmpty {
            placeHolderLabel.fadeOut()
            placeHolderLabel.isHidden = true
        } else {
            placeHolderLabel.isHidden = false
            placeHolderLabel.fadeIn()
        }
    }
    
    // MARK: - Selectors
    @objc fileprivate func leftNavBarBtnTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func rightNavBarBtnTapped() {
        
        guard let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }
        guard let updatedSummary = summaryTextField.text else { return }
        let technicianKeyPath = getUsersPersistedInfo.uid
        
        let updateElement = [
            "profileSummary": updatedSummary
        ] as [String : Any]
        
        
        let childPath = "users/technicians/\(technicianKeyPath)/profileInfo"
        database.child(childPath).updateChildValues(updateElement, withCompletionBlock: { error, _ in
            guard error == nil else {
                return
            }
        })
        
        dismiss(animated: true, completion: nil)
    }
}
