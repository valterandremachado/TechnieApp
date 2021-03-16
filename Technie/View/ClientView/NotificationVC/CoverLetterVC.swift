//
//  CoverLetterVC.swift
//  Technie
//
//  Created by Valter A. Machado on 3/4/21.
//

import UIKit

class CoverLetterVC: UIViewController {

    var technicianModel: TechnicianModel!
//    var model: TechnicianModel! {
//        didSet {
//            technicianModel = model
//        }
//    }
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "technician name cover letter"
//        lbl.backgroundColor = .red
        lbl.numberOfLines = 0
//        lbl.withHeight(20)
        lbl.textAlignment = .left
        lbl.font = .boldSystemFont(ofSize: 16)
        
        return lbl
    }()
    
    lazy var coverLetterLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .systemGray
        lbl.textAlignment = .left
        lbl.text = "technician name cover letter technician name cover letter technician name cover letter technician name cover lettertechnician name cover lettertechnician name cover letter technician name cover letter"
        lbl.numberOfLines = 0
//        lbl.backgroundColor = .blue
        return lbl
    }()
    
    lazy var viewProfileBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("View Profile", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .systemPink
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5
//        btn.withWidth(view.frame.width - 45)
        btn.withHeight(35)
        btn.addTarget(self, action: #selector(viewProfileBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var mainStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, coverLetterLabel, viewProfileBtn])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
//        sv.alignment = .fill
        sv.spacing = 15
        sv.distribution = .fill
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupViews()
    }
    
    func setupViews() {
        [mainStackView].forEach {view.addSubview($0)}
        mainStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15))
        
        setupNavBar()
    }
    
    func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        
        let leftNavBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(leftNavBarBtnTapped))
        
        navigationItem.title = "Cover Letter"
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
    }
    
    @objc func leftNavBarBtnTapped() {
        dismiss(animated: true)
    }
    
    @objc func viewProfileBtnPressed() {
        
        let vc = TechnicianProfileDetailsVC()
        vc.technicianModel = technicianModel
        vc.nameLabel.text = technicianModel.profileInfo.name
        vc.locationLabel.text = "\(technicianModel.profileInfo.location), Philippines"
        vc.technicianExperienceLabel.text = "• \(technicianModel.profileInfo.experience) Year of Exp."
        
        let delimiter = "at"
        let slicedString = technicianModel.profileInfo.membershipDate.components(separatedBy: delimiter)[0]
        vc.memberShipDateLabel.text = "• Member since " + slicedString
        navigationController?.pushViewController(vc, animated: true)
    }
    
//    func formatterWithMonthName(data: String) -> String {
//
//    }

}

// MARK: - CoverLetterVCPreviews
import SwiftUI

struct CoverLetterVCPreviews: PreviewProvider {
    
    static var previews: some View {
        let vc = CoverLetterVC()
        return vc.liveViewController
    }
    
}

extension NSMutableAttributedString {
    var fontSize:CGFloat { return 14 }
    var boldFont:UIFont { return UIFont(name: "AvenirNext-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont(name: "AvenirNext-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    func orangeHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.orange
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func blackHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func underlined(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
