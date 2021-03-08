//
//  TechnieStatsCell.swift
//  Technie
//
//  Created by Valter A. Machado on 2/23/21.
//

import UIKit

class TechnieStatsCell: UITableViewCell {
    static let cellID = "TechnieStatsCellID"
    
//    let workSpeedBar = UIView()
//    let workQualityBar = UIView()
    
    lazy var workSpeedBarLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Work speed: 80%"
        lbl.font = .systemFont(ofSize: 12)
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var workQualityBarLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Work quality: 70%"
        lbl.font = .systemFont(ofSize: 12)
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var responseTimeBarLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Response time: 70%"
        lbl.font = .systemFont(ofSize: 12)
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var workSpeedBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .cyan
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.withHeight(30)
//        view.withWidth(60)
        plotBarOneChart(bar: view)

        view.addSubview(workSpeedBarLabel)
        workSpeedBarLabel.anchor(top: view.topAnchor,
                                 leading: view.leadingAnchor,
                                 bottom: view.bottomAnchor,
                                 trailing: view.trailingAnchor,
                                 padding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        return view
    }()
    lazy var workQualityBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemPink
        view.layer.cornerRadius = 5
        view.withHeight(30)
//        view.withWidth(40)
        plotBarTwoChart(bar: view)

        view.addSubview(workQualityBarLabel)
        workQualityBarLabel.anchor(top: view.topAnchor,
                                 leading: view.leadingAnchor,
                                 bottom: view.bottomAnchor,
                                 trailing: view.trailingAnchor,
                                 padding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        return view
    }()
    
    lazy var responseTimeBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemPink
        view.layer.cornerRadius = 5
        view.withHeight(30)
//        view.withWidth(40)
        plotBarThreeChart(bar: view)

        view.addSubview(responseTimeBarLabel)
        responseTimeBarLabel.anchor(top: view.topAnchor,
                                 leading: view.leadingAnchor,
                                 bottom: view.bottomAnchor,
                                 trailing: view.trailingAnchor,
                                 padding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        return view
    }()
    
    lazy var barStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [workSpeedBar, workQualityBar, responseTimeBar])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        sv.alignment = .leading
        sv.spacing = 5
        return sv
    }()
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        /// Adding tableView right indicator
//        self.accessoryType = .disclosureIndicator
        /// Changing selection style
//        self.selectionStyle = .none
//        backgroundColor = UIColor.rgb(red: 235, green: 235, blue: 235)
        setupViews()
    }
    
    func setupViews() {
        addSubview(barStackView)
        barStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
    }
    
    func plotBarOneChart(bar: UIView) {
        let barOneWidth = CGFloat.random(in: 120..<(frame.width))

        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(10)) {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5) {
                    bar.withWidth(barOneWidth)
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    func plotBarTwoChart(bar: UIView) {
        let barTwoWidth = CGFloat.random(in: 120..<(frame.width))

        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(10)) {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5) {
                    bar.withWidth(barTwoWidth)
                    self.layoutIfNeeded()
                }
            }
        }
        
    }
    
    func plotBarThreeChart(bar: UIView) {
        let barTwoWidth = CGFloat.random(in: 120..<(frame.width))

        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(10)) {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5) {
                    bar.withWidth(barTwoWidth)
                    self.layoutIfNeeded()
                }
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
