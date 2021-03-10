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
        lbl.text = "WORK SPEED:"
        lbl.font = .systemFont(ofSize: 11)
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var workQualityBarLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "WORK QUALITY:"
        lbl.font = .systemFont(ofSize: 11)
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var responseTimeBarLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "RESPONSE TIME:"
        lbl.font = .systemFont(ofSize: 11)
        lbl.textAlignment = .center
        return lbl
    }()
        
    lazy var workSpeedBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .rgb(red: 0, green: 205, blue: 205)//.cyan
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.withHeight(30)
//        view.withWidth(10)

//        plotBarOneChart(bar: view)

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
        view.backgroundColor = .rgb(red: 0, green: 238, blue: 238)//.systemPurple
        view.layer.cornerRadius = 5
        view.withHeight(30)
//        view.withWidth(10)
//        plotBarTwoChart(bar: view)

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
        view.backgroundColor = .rgb(red: 151, green: 255, blue: 255)//.systemTeal
        view.layer.cornerRadius = 5
        view.withHeight(30)
//        view.withWidth(10)

//        plotBarThreeChart(bar: view)

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
    
    let efficiencyInPercentage = [0.25, 0.50, 0.75, 1.0]
    let efficiencyItems = ["Poor", "Fair", "Good", "Excellent"]

    var workSpeed = 0
    var workQuality = 0
    var responseTime = 0
    
    var clientsSatisfaction: ClientsSatisfaction? {
        didSet {
            workSpeed = Int(clientsSatisfaction?.workSpeedAvrg.rounded(.toNearestOrAwayFromZero) ?? 0)
            workQuality = Int(clientsSatisfaction?.workQualityAvrg.rounded(.toNearestOrAwayFromZero) ?? 0)
            responseTime = Int(clientsSatisfaction?.responseTimeAvrg.rounded(.toNearestOrAwayFromZero) ?? 0)

            plotBarOneChart(bar: workSpeedBar)
            plotBarTwoChart(bar: workQualityBar)
            plotBarThreeChart(bar: responseTimeBar)
            
//            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(3)) {
//                DispatchQueue.main.async { [self] in
//                    UIView.animate(withDuration: 0.5) {
//                        responseTimeBar.withWidth(CGFloat(efficiencyInPercentage[workSpeed]))
//                        print(efficiencyInPercentage[workSpeed])
//                        self.layoutIfNeeded()
//                    }
//                }
//            }

        }
    }
    
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
//        print("workSpeed2: ", workSpeed)
       
        if workSpeed != 0 {
            let workSpeedInPercentage = efficiencyInPercentage[workSpeed]
            let barOneWidth = CGFloat(workSpeedInPercentage * Double(frame.width))//CGFloat.random(in: 120..<(frame.width))
            
            DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(10)) {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5) { [self] in
                        bar.withWidth(barOneWidth)
                        let workSpeedText = efficiencyItems[workSpeed]
                        workSpeedBarLabel.text = "WORK SPEED: \(workSpeedText) (\(String(format:"%.0f", workSpeedInPercentage * 100))%)"
                        self.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
    func plotBarTwoChart(bar: UIView) {
        
        let workQualityInPercentage = efficiencyInPercentage[workQuality]
        let barTwoWidth = CGFloat(workQualityInPercentage * Double(frame.width))//CGFloat.random(in: 120..<(frame.width))

        if workQuality != 0 {
            DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(10)) {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5) { [self] in
                        bar.withWidth(barTwoWidth)
                        let workSpeedText = efficiencyItems[workQuality]
                        workQualityBarLabel.text = "WORK QUALITY: \(workSpeedText) (\(String(format:"%.0f", workQualityInPercentage * 100))%)"

                        self.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
    func plotBarThreeChart(bar: UIView) {
       
        let responseTimeInPercentage = efficiencyInPercentage[responseTime]
        let barThreeWidth =  CGFloat(responseTimeInPercentage * Double(frame.width))//CGFloat.random(in: 120..<(frame.width))

        if workQuality != 0 {
            DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(10)) {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5) { [self] in
                        bar.withWidth(barThreeWidth)
                        let workSpeedText = efficiencyItems[responseTime]
                        responseTimeBarLabel.text = "RESPONSE TIME: \(workSpeedText) (\(String(format:"%.0f", responseTimeInPercentage * 100))%)"
                        self.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
