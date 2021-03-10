//
//  SummaryVC.swift
//  Technie
//
//  Created by Valter A. Machado on 3/11/21.
//

import UIKit

class SummaryVC: UIViewController, UITextViewDelegate {

    // MARK: - Properties
    lazy var txtLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "SUMMARY"
        lbl.font = .systemFont(ofSize: 12)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var placeHolderLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Summary..."
        lbl.textColor = .systemGray
        lbl.font = .systemFont(ofSize: 15)
        return lbl
    }()
    
    lazy var summaryTextField: UITextView = {
        let txtView = UITextView()
        txtView.delegate = self
//        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.backgroundColor = UIColor(named: "textViewBackgroundColor")
        txtView.clipsToBounds = true
        txtView.layer.cornerRadius = 10
        txtView.isEditable = true
        txtView.isScrollEnabled = false
        return txtView
    }()
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        setupViews()
    }
    
    // MARK: - Methods
    private func setupViews() {
        [txtLabel, summaryTextField, placeHolderLabel].forEach {view.addSubview($0)}
        
        txtLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20), size: CGSize(width: 0, height: 0))
        
        summaryTextField.anchor(top: txtLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20), size: CGSize(width: 0, height: 0))
        
        placeHolderLabel.anchor(top: summaryTextField.topAnchor, leading: view.leadingAnchor, bottom: summaryTextField.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        
        setupNavBar()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Summary"
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

}
