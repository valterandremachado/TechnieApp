//
//  ReviewTechnicianVC.swift
//  Technie
//
//  Created by Valter A. Machado on 3/4/21.
//

import UIKit
import Cosmos


protocol ReviewTechnicianVCDismissalDelegate: class {
    func ReviewTechnicianVCDismissalSingleton(tappedRow: Int)
}

class ReviewTechnicianVC: UIViewController, UITextViewDelegate {

    var userPostModel: PostModel!
    var satisfactionAvrg: ClientsSatisfaction?
    var reviews = [Review]()
    var notificationRow = -1
    
    weak var dismissalDelegate: ReviewTechnicianVCDismissalDelegate?
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        
//        tv.isScrollEnabled = false
        tv.showsVerticalScrollIndicator = false
        // Set automatic dimensions for row height
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
        tv.clipsToBounds = true
//        tv.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)

        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tv.tableHeaderView = UIView(frame: frame)
        tv.tableFooterView = UIView(frame: frame)
//        tv.contentInsetAdjustmentBehavior = .never
        
        tv.delegate = self
        tv.dataSource = self
        tv.register(ReviewTechnicianCell.self, forCellReuseIdentifier: ReviewTechnicianCell.cellID)
        return tv
    }()
    
    lazy var ratingView: CosmosView = {
        let view = CosmosView()
//        view.backgroundColor = .red
        view.settings.starMargin = 5
        view.settings.starSize = 20
        view.settings.fillMode = .half

//        view.didFinishTouchingCosmos = { rating in
//            print("rating: \(rating)")
//        }

        return view
    }()
    
    lazy var reviewCommentTextField: UITextView = {
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
    
    lazy var placeHolderLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Write a review comment..."
        lbl.textColor = .systemGray
        lbl.font = .systemFont(ofSize: 15)
        return lbl
    }()
    
    var sectionSetter = [SectionHandler]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        self.tableView.separatorColor = .clear
        sectionSetter.append(SectionHandler(title: "Work Speed", detail: [""]))
        sectionSetter.append(SectionHandler(title: "Work Quality", detail: [""]))
        sectionSetter.append(SectionHandler(title: "Response Time", detail: [""]))
        sectionSetter.append(SectionHandler(title: "Rating", detail: [""]))

        getClientSatisfaction()
        setupViews()
        
//        print("print that post: \(userPostModel)")
    }
    
    func setupViews() {
        [tableView].forEach {view.addSubview($0)}
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        setupNavBar()
    }
    
    fileprivate func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        
        let leftNavBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(leftNavBarBtnTapped))
        
        navigationItem.title = "Review"
        self.navigationItem.leftBarButtonItem = leftNavBarButton
    }

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
    
    var workReview = [0, 0, 0]
    
    @objc fileprivate func leftNavBarBtnTapped() {
//        print("rating2: \(ratingView.rating)")
        let rating = ratingView.rating
        let jobTitle = userPostModel.title
        let dateOfReview = PostFormVC.dateFormatter.string(from: Date())
        
        guard let dateOfHiring = userPostModel.hiringStatus?.date else { return }
        guard let clientName = userPostModel.postOwnerInfo?.name else { return }
        guard let technicianKeyPath = userPostModel.hiringStatus?.technicianKeyPath else { return }

        guard let reviewComment = reviewCommentTextField.text else { return }
        
        if reviews.count >= 1 {
//            print("reviews > 1")
            let divisor = Double(reviews.count + 1)
            let workSpeedAvrg = calculateMeanAverage(dividend: satisfactionAvrg!.workSpeedAvrg + Double(workReview[0]), divisor: divisor)
            let workQualityAvrg = calculateMeanAverage(dividend: satisfactionAvrg!.workQualityAvrg + Double(workReview[1]), divisor: divisor)
            let responseTimeAvrg = calculateMeanAverage(dividend: satisfactionAvrg!.responseTimeAvrg + Double(workReview[2]), divisor: divisor)
            let ratingAvrg = calculateMeanAverage(dividend: satisfactionAvrg!.ratingAvrg + rating, divisor: divisor)

            let clientsSatisfaction = ClientsSatisfaction(workSpeedAvrg: workSpeedAvrg,
                                                          workQualityAvrg: workQualityAvrg,
                                                          responseTimeAvrg: responseTimeAvrg,
                                                          ratingAvrg: ratingAvrg)

            let clientReview = Review(jobTitle: jobTitle,
                                      reviewComment: reviewComment,
                                      clientName: clientName,
                                      dateOfReview: dateOfReview,
                                      dateOfHiring: dateOfHiring,
                                      workSpeed: workReview[0],
                                      workQuality: workReview[1],
                                      responseTime: workReview[2],
                                      rating: rating)

            DatabaseManager.shared.insertClientSatisfaction(with: clientsSatisfaction, with: clientReview, with: technicianKeyPath) { success in
                if success {
                    self.dismissalDelegate?.ReviewTechnicianVCDismissalSingleton(tappedRow: self.notificationRow)
                    self.dismiss(animated: true, completion: nil)
                }
            }

        } else {
//            print("reviews == 0")
            let clientsSatisfaction = ClientsSatisfaction(workSpeedAvrg: Double(workReview[0]),
                                                          workQualityAvrg: Double(workReview[1]),
                                                          responseTimeAvrg: Double(workReview[2]),
                                                          ratingAvrg: rating)

            let clientReview = Review(jobTitle: jobTitle,
                                      reviewComment: reviewComment,
                                      clientName: clientName,
                                      dateOfReview: dateOfReview,
                                      dateOfHiring: dateOfHiring,
                                      workSpeed: workReview[0],
                                      workQuality: workReview[1],
                                      responseTime: workReview[2],
                                      rating: rating)

            DatabaseManager.shared.insertClientSatisfaction(with: clientsSatisfaction, with: clientReview, with: technicianKeyPath) { success in
                if success {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }

        self.dismissalDelegate?.ReviewTechnicianVCDismissalSingleton(tappedRow: self.notificationRow)
        self.dismiss(animated: true, completion: nil)
    }
    
    func calculateMeanAverage(dividend: Double, divisor: Double) -> Double {
        let result = (dividend)/divisor
        return result
    }
    
    func getClientSatisfaction() {
        guard let technicianKeyPath = userPostModel.hiringStatus?.technicianKeyPath else { return }

        DatabaseManager.shared.getAllClientSatisfactionWithReviews(with: technicianKeyPath) { result in
            
            switch result {
            case .success(let satisfactionAvrg):
                self.satisfactionAvrg = satisfactionAvrg
            case .failure(let error):
                print(error)
            }
        } onReviewCompletion: { result in
            
            switch result {
            case .success(let reviews):
                self.reviews = reviews
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
}

extension ReviewTechnicianVC: TableViewDataSourceAndDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionSetter.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionSetter[section].sectionDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTechnicianCell.cellID, for: indexPath) as! ReviewTechnicianCell
        cell.segment.tag = indexPath.section
        cell.segment.addTarget(self, action: #selector(segmentPressed), for: .valueChanged)

        if indexPath.section == 3 {
            cell.segment.isHidden =  true
            
            [ratingView, reviewCommentTextField, placeHolderLabel].forEach{cell.contentView.addSubview($0)}
            
            ratingView.anchor(top: cell.contentView.topAnchor, leading: cell.contentView.leadingAnchor, bottom: nil, trailing: cell.contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20), size: CGSize(width: 0, height: 20))

            reviewCommentTextField.anchor(top: ratingView.bottomAnchor, leading: cell.contentView.leadingAnchor, bottom: cell.contentView.bottomAnchor, trailing: cell.contentView.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 20, bottom: 10, right: 20), size: CGSize(width: 0, height: 0))
            
            placeHolderLabel.anchor(top: reviewCommentTextField.topAnchor, leading: cell.contentView.leadingAnchor, bottom: reviewCommentTextField.bottomAnchor, trailing: cell.contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        }
        
        return cell
    }
    
    @objc func segmentPressed(_ sender: UISegmentedControl) {
        let index = sender.tag
        let selectedItem = sender.selectedSegmentIndex
        switch index {
        case 0:
            workReview[0] = selectedItem
        case 1:
            workReview[1] = selectedItem
        case 2:
            workReview[2] = selectedItem
        default:
            break
        }
        print("Selected Item: \(selectedItem), section number: \(index)")
        print("workReview: \(workReview)")

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return sectionSetter[section].sectionTitle
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
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

// MARK: - ReviewTechnicianVCPreviews
import SwiftUI

struct ReviewTechnicianVCPreviews: PreviewProvider {
    
    static var previews: some View {
        let vc = ReviewTechnicianVC()
        return vc.liveViewController
    }
    
}
