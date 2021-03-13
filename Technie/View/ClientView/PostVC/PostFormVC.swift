//
//  PostFormVC.swift
//  Technie
//
//  Created by Valter A. Machado on 12/29/20.
//

import UIKit
import NotificationBannerSwift
import FirebaseDatabase
import CodableFirebase

struct Keys {
    static let pickerStoredIndex = "pickerIndex"
    static let selectedSkills = "selectedSkillsUserDefaults"
}

class PostFormVC: UIViewController {
    private let tableCellID = "cellID"
    var sections = [SectionHandler]()
    var database = Database.database().reference()
    
    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.tableFooterView = UIView()
        // Set automatic dimensions for row height
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
        tv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //        tv.isScrollEnabled = false
        tv.showsVerticalScrollIndicator = false
//        tv.rowHeight = 40
        //        tv.layer.cornerRadius = 18
        //        tv.clipsToBounds = true
        
        tv.delegate = self
        tv.dataSource = self
        // Register Custom Cells for each section
        tv.register(PostFormCell.self, forCellReuseIdentifier: tableCellID)
        tv.register(PostFormProjectTypeCell.self, forCellReuseIdentifier: PostFormProjectTypeCell.cellID)
        tv.register(PostFormBudgetCell.self, forCellReuseIdentifier: PostFormBudgetCell.cellID)
        tv.register(PostFormSkillCell.self, forCellReuseIdentifier: PostFormSkillCell.cellID)
        
        
        return tv
    }()
    
    lazy var customLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .boldSystemFont(ofSize: 18)
        //        lbl.backgroundColor = .cyan
        lbl.textAlignment = .right
        lbl.text = "PHP"
        return lbl
    }()
    
    lazy var budgetPickerBtn: UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        //        btn.backgroundColor = UIColor(displayP3Red: 235/255, green: 51/255, blue: 72/255, alpha: 0.2)
        //        btn.backgroundColor = .brown
        btn.setTitle("₱200 - ₱800 / hour", for: .normal)
        //        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        //        btn.tintColor = .systemPink
        btn.contentHorizontalAlignment = .left
        //        btn.isHidden = true
        //        btn.withWidth(80)
        //        btn.addTarget(self, action: #selector(loginBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var stackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [budgetPickerBtn, customLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 0
        //        sv.alignment = .center
        sv.distribution = .fillEqually
        //        sv.addBackground(color: .lightGray)
        
        return sv
    }()
    
    var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.barStyle = .black
        
        //        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))
        //        let spaceBetweenItems = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(onDoneButtonTapped))
        //        toolBar.items = [cancelBtn, spaceBetweenItems, doneBtn]
        return toolBar
    }()
    
    lazy var budgetPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        return picker
    }()
    
    lazy var pickerCustomView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        
        cv.addSubview(budgetPicker)
        //        picker.backgroundColor = .brown
        budgetPicker.anchor(top: nil, leading: cv.leadingAnchor, bottom: cv.bottomAnchor, trailing: cv.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: 105))
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBtnTapped))
        let spaceBetweenItems = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnTapped))
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: 0, width: UIScreen.main.bounds.size.width, height: 35))
        toolBar.items = [cancelBtn, spaceBetweenItems, doneBtn]
        cv.addSubview(toolBar)
        cv.fadeOut()
        return cv
    }()
    
    var isPicking = false
    
    var customArray: [String] = ["₱200 - ₱300 / hour", "₱300 - ₱400 / hour", "₱400 - ₱500 / hour"]
    let handymanSectionArray = ["Plumbing Installation/Leaking Plumbing", "Drywall Installation", "Fixture Replacement", "Painting for the Interior and Exterior", "Power Washing", "Tile Installation", "Deck/Door/Window Repair", "Carpenter", "Cabinetmaker", "Others"]
    
    var finalPick = ""
    var pickerIndex = 0
    let userDefaults = UserDefaults.standard
    //    lazy var pickerStoredIndex = userDefaults.integer(forKey: Keys.pickerStoredIndex)
    
    var imageDataArray = [Data]()
    var imageNameArray = [String]()
    lazy var attachedFileArray = ["imageData" : imageDataArray, "imageName": imageNameArray] as [String : Any]
    
    var initialSelectedSkill = [""]
    
    let singleton = SkillSelectionVC()//.shared
    
    var serviceField = ""
    var selectedArea = ""
    
    var postModel: PostModel?
    var isComingFromPostHistory = false
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .cyan
//        singleton.delegate = self
        fetchData()
        setupViews()
        populateSection()
        
        if isComingFromPostHistory == true {
            let index = customArray.firstIndex(of: postModel?.budget ?? "")
//            budgetPicker.selectedRow(inComponent: index!)
            finalPick = postModel?.budget ?? ""
            budgetPicker.selectRow(index!, inComponent: 0, animated: true)
            budgetPickerBtn.setTitle(finalPick, for: .normal)
        }
        print("viewDidLoad")
        self.hideKeyboardWhenTappedAround()
    }
    
    override func loadView() {
        super.loadView()
        print("loadView")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Reset userDefaults
        userDefaults.removeObject(forKey: Keys.pickerStoredIndex)
//        userDefaults.removeObject(forKey: Keys.selectedSkills)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
////        hideBackText()
//    }
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
    
    // MARK: - Methods
    fileprivate func setupViews() {
        [tableView].forEach {view.addSubview($0)}
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(UpdateDefaultsArrayObserver), name: NSNotification.Name("UpdateDefaultsArrayNotification"), object: nil)
//        NotificationCenter.default.removeObserver(self)
        
        setupNavBar()
    }
    
//    private func hideBackText() {
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithDefaultBackground()
//
//        let backButtonAppearance = UIBarButtonItemAppearance()
//        backButtonAppearance.normal.titleTextAttributes = [.font: UIFont(name: "Arial", size: 0)!]
//        appearance.backButtonAppearance = backButtonAppearance
//
//        navigationItem.standardAppearance = appearance
//        navigationItem.scrollEdgeAppearance = appearance
//        navigationItem.compactAppearance = appearance
//    }
    
    fileprivate func setupNavBar() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        guard let navBar = navigationController?.navigationBar else { return }
//        navBar.setBackgroundImage(UIImage(), for: .default)
//        navBar.hideNavBarSeperator()
        navBar.topItem?.backBarButtonItem = backButton

//        navBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .automatic
        if isComingFromPostHistory == true {
            title = "Edit Post"

            let rightNavBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(updatePostDetails))
            let leftNavBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeEditPostVC))

            self.navigationItem.leftBarButtonItem = leftNavBarButton
            self.navigationItem.rightBarButtonItem = rightNavBarButton
        } else {
            title = "Post A Job"
            let rightNavBarButton = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(rightNavBarItemPostBtnTapped))
            self.navigationItem.rightBarButtonItem = rightNavBarButton
        }
        
//        let rightNavBarButton = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(rightNavBarItemPostBtnTapped))
//        self.navigationItem.rightBarButtonItem = rightNavBarButton
        navigationItem.largeTitleDisplayMode = .never
    }
    
    @objc func updatePostDetails() {
//        guard let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }
//        guard let updatedSummary = summaryTextField.text else { return }
//        let technicianKeyPath = getUsersPersistedInfo.uid
        guard let postKeyPath = postModel?.id else { return }
        
        postTitle = titleTextField.text
        postDescription = descriptionTextField.text
        postProjectType = chosenItem
        postBudget = finalPick
        
        let removeWhiteSpace = initialSelectedSkill.firstIndex(of: "") ?? 400
        if removeWhiteSpace != 400 {
            initialSelectedSkill.remove(at: removeWhiteSpace)
        }
        postRequiredSkills = initialSelectedSkill
        
        let updateElement = [
            "title": postTitle,
            "description": postDescription,
            "projectType": postProjectType,
            "budget": postBudget,
            "requiredSkills": postRequiredSkills,

        ] as [String : Any]


        let childPath = "posts/\(postKeyPath)"
        database.child(childPath).updateChildValues(updateElement, withCompletionBlock: { error, _ in
            guard error == nil else {
                return
            }
        })
        
//        print("postTitle: ", postTitle, ", postDescription: ", postDescription, ", postProjectType: ", postProjectType, ", postBudget: ", postBudget, ", postRequiredSkills:", postRequiredSkills)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func closeEditPostVC() {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func populateSection() {

        if isComingFromPostHistory == false {
            switch serviceField {
            case "Handyman":
                initialSelectedSkill.removeAll()
                initialSelectedSkill.append("")
                initialSelectedSkill.insert(selectedArea, at: 0)
                
            case "Repairer":
                initialSelectedSkill.removeAll()
                initialSelectedSkill.append("")
                initialSelectedSkill.insert(selectedArea, at: 0)
                
            default:
                break
            }
        }
        
        sections.append(SectionHandler(title: "Project Title & Description", detail: ["0", "1", ""]))
        sections.append(SectionHandler(title: "Project Type", detail: ["0"]))
        sections.append(SectionHandler(title: "Project Budget", detail: ["0"]))
        sections.append(SectionHandler(title: "Preferred Skills", detail: initialSelectedSkill))
        tableView.reloadData()
    }
    
    fileprivate func addSkillData(_ skillTitle: String?) {
        guard let skill = skillTitle else { return }
        let existingSkill = self.sections[3].sectionDetail.first
        
        if skill != existingSkill && skill != "" {
            // Insert items instead of append to give a smooth reload transition
            self.sections[3].sectionDetail.insert(skill, at: 0)
            // Reloads items from the top (beginUpdates & endUpdates are be called because an insertion is happening)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 3)], with: .top)
            self.tableView.endUpdates()
        } else {
            print("existing Name")
        }
    }
    
    fileprivate func presentActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: "Attach file (jpeg, png)", preferredStyle: .actionSheet)
        
        let gallery = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
        actionSheet.addAction(gallery)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
        actionSheet.fixActionSheetConstraintsError()
    }
    
    func handleTitleTextFieldPlaceHolder(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
        
        if !textView.text.replacingOccurrences(of: " ", with: "").isEmpty && !titleTextField.text.replacingOccurrences(of: " ", with: "").isEmpty{
            titlePlaceHolderLabel.fadeOut()
            titlePlaceHolderLabel.isHidden = true
        } else {
            titlePlaceHolderLabel.isHidden = false
            titlePlaceHolderLabel.fadeIn()
        }
    }
    
    func handleDescriptionTextFieldPlaceHolder(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
        
        if !textView.text.replacingOccurrences(of: " ", with: "").isEmpty && !descriptionTextField.text.replacingOccurrences(of: " ", with: "").isEmpty{
            descriptionPlaceHolderLabel.fadeOut()
            descriptionPlaceHolderLabel.isHidden = true
        } else {
            descriptionPlaceHolderLabel.isHidden = false
            descriptionPlaceHolderLabel.fadeIn()
        }
    }
    
    public static let dateFormatter: DateFormatter = {
        let formattre = DateFormatter()
        formattre.dateStyle = .medium
        formattre.timeStyle = .long
        formattre.locale = .current
        return formattre
    }()
    
    var postTitle: String = ""
    var postDescription: String = ""
    var postProjectType: String = ""
    var postBudget: String = ""
    var postRequiredSkills = [String]()
    var postAttachments = [String]()
    // Auto Initializers
    var postAvailabilityStatus: Bool = true
    var postNumberOfProposals: Int = 0
    var postNumberOfInvitesSent: Int = 0
    var postNumberOfUnansweredInvites: Int = 0
    var postDateTime = Date()
    var postHiringStatus: Bool = false
    var fieldOfService = ""
    
    var items = [String]()
    var chosenItem: String = "Long Term"
    // MARK: - Selectors
    @objc fileprivate func rightNavBarItemPostBtnTapped() {
        ProgressHUD.colorAnimation = .systemBlue
        ProgressHUD.colorProgress = .systemBlue
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.show("Posting...", interaction: false)
        
        let dateString = PostFormVC.dateFormatter.string(from: postDateTime)

        postTitle = titleTextField.text
        postDescription = descriptionTextField.text
        postProjectType = chosenItem
        postBudget = finalPick
        serviceField != "Others" ? (fieldOfService = serviceField) : (fieldOfService = "Not Specified")

        let removeWhiteSpace = initialSelectedSkill.firstIndex(of: "") ?? 400
        if removeWhiteSpace != 400 {
            initialSelectedSkill.remove(at: removeWhiteSpace)
        }
        postRequiredSkills = initialSelectedSkill

        print(postTitle)
        print(postDescription)
        print(postProjectType)
        print(postBudget)
        print(postRequiredSkills)
//        print(postAttachments)

        guard !postTitle.replacingOccurrences(of: " ", with: "").isEmpty,
              !postDescription.replacingOccurrences(of: " ", with: "").isEmpty,
              !postProjectType.replacingOccurrences(of: " ", with: "").isEmpty,
              !postBudget.replacingOccurrences(of: " ", with: "").isEmpty,
              !postRequiredSkills.isEmpty,
              !imageDataArray.isEmpty
        else { return }
        
        guard let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }
        let clientEmail = getUsersPersistedInfo.email
        let clientName = getUsersPersistedInfo.name
        let clientLocation = getUsersPersistedInfo.location
        let clientUID = getUsersPersistedInfo.uid

        var postsImageUrl = [String]()
        StorageManager.shared.uploadPostImages(with: imageDataArray, with: imageNameArray, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let downloadUrl):
                postsImageUrl.append(downloadUrl)

                if postsImageUrl.count == self.imageDataArray.count {
                    self.postAttachments = postsImageUrl
//                    print("download url returned: \(postsImageUrl), count: \(postsImageUrl.count)")

                    let postOwnerInfo = PostOwnerInfo(name: clientName, email: clientEmail, location: clientLocation, keyPath: clientUID, profileImage: nil)

                    let post = PostModel(id: nil,
                                         title: self.postTitle,
                                         description: self.postDescription,
                                         attachments: self.postAttachments,
                                         projectType: self.postProjectType,
                                         budget: self.postBudget,
                                         location: nil,
                                         requiredSkills: self.postRequiredSkills,
                                         availabilityStatus: self.postAvailabilityStatus,
                                         isCompleted: false,
                                         numberOfProposals: self.postNumberOfProposals,
                                         numberOfInvitesSent: self.postNumberOfInvitesSent,
                                         numberOfUnansweredInvites: self.postNumberOfUnansweredInvites,
                                         dateTime: dateString,
                                         field: self.fieldOfService,
                                         postOwnerInfo: postOwnerInfo,
                                         hiringStatus: nil,
                                         proposals: nil)

                    DatabaseManager.shared.insertPost2(with: post, completion: { success in
                        if success {
                          
                            ProgressHUD.colorAnimation = .systemBlue
                            ProgressHUD.colorProgress = .systemBlue
                            ProgressHUD.showSucceed()
                            
                            let delay = 0.03 + 1.25
                            Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                            
                            print("success")
                        } else {
                            ProgressHUD.colorAnimation = .systemRed
                            ProgressHUD.colorProgress = .systemRed
                            ProgressHUD.showFailed("Something went wrong.")
                            print("failed")
                        }
                    }, completionOnPostID: { result in
                        switch result {
                        case .success(let postUID):
                            if self.userDefaults.bool(forKey: "recommendationEngineOnOff") == true {
                                self.showRecommendationBanner(jobPostKeyPath: postUID)
                            }
                        case .failure(let error):
                            print(error)
                        }
                    })

                    return // Get out of this function
                }
            case .failure(let error):
                print("Storage maanger error: \(error)")
            }
        })
       
    }
    
    var recommendedTechniciansModel = [TechnicianModel]()
    
    fileprivate func fetchData()  {
        DatabaseManager.shared.getAllTechnicians(completion: {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let technicians):
                self.recommendedTechniciansModel.append(technicians)
            case .failure(let error):
                print("Failed to get technicians: \(error.localizedDescription)")
            }
        })
    }
        
    fileprivate func showRecommendationBanner(jobPostKeyPath: String) {
        print("jobPostKeyPath: \(jobPostKeyPath)")
        guard !recommendedTechniciansModel.isEmpty else { return }
        guard let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }
        let clientKeyPath = getUsersPersistedInfo.uid
        
        let updateElement = try! FirebaseEncoder().encode(recommendedTechniciansModel)

        let childPath = "\(jobPostKeyPath)/recommendedTechnicians"
        database.child(childPath).setValue(updateElement, withCompletionBlock: { error, _ in
            guard error == nil else {
                return
            }
        })
        
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        let wiredProfileImage = UIImage(systemName: "chevron.forward.circle.fill", withConfiguration: config)?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = wiredProfileImage
        let banner = FloatingNotificationBanner(title: "Recommendation",
                                                subtitle: "Check the best fit technicians nearby your area for the job you just posted.",
                                                rightView: imageView,
                                                style: .info)
        
//        banner.autoDismiss = false
//        banner.autoDismiss = true
        banner.titleLabel?.textColor = .black
        banner.subtitleLabel?.textColor = .systemGray

        banner.backgroundColor = UIColor.rgb(red: 237, green: 237, blue: 237)
        banner.subtitleLabel?.font = .systemFont(ofSize: 13)
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return }
        
        let randomNumber = Int.random(in: Int(6)...10)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(randomNumber)) { //[self] in
            DispatchQueue.main.async {
                banner.show(queuePosition: .front,
                            bannerPosition: .bottom,
                            edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: tabHeight - 15, right: 10),
                            cornerRadius: 10)
                // Add the recommendation to the user's notification list
                let clientNotificationModel = ClientNotificationModel(id: "nil",
                                                                      type: ClientNotificationType.recommendation.rawValue,
                                                                      title: ClientNotificationType.recommendation.rawValue,
                                                                      description: "We think you might want to consider these technicians nearby you as hiring candidates for the job you just posted.",
                                                                      dateTime: PostFormVC.dateFormatter.string(from: Date()),
                                                                      wasAccepted: nil,
                                                                      jobPostKeyPath: jobPostKeyPath,
                                                                      technicianInfo: nil)
                
                DatabaseManager.shared.insertClientNotification(with: clientNotificationModel, with: clientKeyPath, completion: { _ in })
            }
        }
        
        banner.onTap = {
            let vc = RecommendationVC()
            let vcEmbeddedToNavController = UINavigationController(rootViewController: vc)
            vc.jobPostKeyPath = jobPostKeyPath
            guard let topViewController = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController else { return }

            DispatchQueue.main.async {
                topViewController.present(vcEmbeddedToNavController, animated: true)
                banner.dismiss()
            }
        }
        
    }
    
    @objc func addSkillsBtnTapped() {
        let vc = SkillSelectionVC()
        vc.skillSelectionVCDelegate = self // set delegate in order to have access of the data used in the SkillSelectionVC
        vc.serviceField = serviceField
        
        if initialSelectedSkill.last == "" && initialSelectedSkill.count == 1 {
            print("array is empty")
        } else {
            print("array is not empty")
            // GCD Schedule is being used as timer in order to get fully access of the used VC on time (avoiding error/crash)
            print("checked removed skill 1: \(initialSelectedSkill)")
            DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(20)) {
                // UI components must be in the main Grand Center Dispatch (GCD)
                DispatchQueue.main.async { [self] in
                    for skills in initialSelectedSkill {
                        if skills != "" {
                            vc.sections[0].sectionDetail.insert(skills, at: 0)
                            vc.tableView.beginUpdates()
                            vc.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
                            vc.tableView.endUpdates()
                            vc.updateAddButtonState()
//                            print(vc.sections[0].sectionDetail)
                        } else {
//                            let indexToDelete = vc.sections[0].sectionDetail.firstIndex(of: skills) ?? 400
                            print("its iqual that")
//                            vc.sections[0].sectionDetail.remove(at: indexToDelete)
//                            vc.sections[0].sectionDetail.removeAll()
//                            vc.sections[0].sectionDetail.append(contentsOf: initialSelectedSkill)
//                            vc.tableView.deleteRows(at: [IndexPath(row: 0, section: 3)], with: .fade)
                        }
                    }
                }
            }
        }
        
        let vcWithEmbeddedNav = UINavigationController(rootViewController: vc)
//        vcWithEmbeddedNav.modalPresentationStyle = .fullScreen
//        vcWithEmbeddedNav.modalTransitionStyle = .crossDissolve
        present(vcWithEmbeddedNav, animated: true, completion: nil)
    }
    
    @objc func attachFileBtnTapped() {
        presentActionSheet()
    }
    
   lazy var descriptionPlaceHolderLabel: UILabel = {
       let lbl = UILabel()
       lbl.translatesAutoresizingMaskIntoConstraints = false
       lbl.text = "Description"
       lbl.textColor = .systemGray
       lbl.font = .systemFont(ofSize: 15)
       return lbl
   }()
   
    lazy var descriptionTextField: UITextView = {
        let txtView = UITextView()
        txtView.delegate = self
        txtView.font = .systemFont(ofSize: 15)
        txtView.textAlignment = .natural

        //        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.backgroundColor = .systemBackground//UIColor(named: "textViewBackgroundColor")
        txtView.clipsToBounds = true
        //                    txtView.layer.cornerRadius = 10
        txtView.isEditable = true
        txtView.isScrollEnabled = false
        return txtView
    }()
    

    lazy var titlePlaceHolderLabel: UILabel = {
       let lbl = UILabel()
       lbl.translatesAutoresizingMaskIntoConstraints = false
       lbl.text = "Title"
       lbl.textColor = .systemGray
       lbl.font = .systemFont(ofSize: 15)
       return lbl
   }()
   
    lazy var titleTextField: UITextView = {
        let txtView = UITextView()
        txtView.delegate = self
        txtView.font = .systemFont(ofSize: 15)
        txtView.textAlignment = .natural
        //        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.backgroundColor = .systemBackground//UIColor(named: "textViewBackgroundColor")
        txtView.clipsToBounds = true
        //                    txtView.layer.cornerRadius = 10
        txtView.isEditable = true
        txtView.isScrollEnabled = false
        return txtView
    }()
}

// MARK: - SkillSelectionVCSingleton Extension
extension PostFormVC: SkillSelectionVCDelegate {
    
    fileprivate func arrayOfStringContains(_ item: String)  -> Bool {
        let arrayOfString = initialSelectedSkill
        return arrayOfString.contains { $0 == item }
    }
    
    func fetchSelectedSkills(skills: [String], didDelete: Bool) {
//        print("workingggg: \(skills), \(didDelete)")
        
        if !skills.isEmpty {
            for skill in skills {
                //                if !arrayOfStringContains(skill) || didDelete == false {
                //                    initialSelectedSkill.append(skill)
                //                    let uniqueItems = initialSelectedSkill.uniqueItemInTheArray{$0}
                //                    initialSelectedSkill.removeAll()
                //                    initialSelectedSkill.append(contentsOf: uniqueItems)
                //                    self.sections[3].sectionDetail.insert(skill, at: 0)
                //                    self.tableView.beginUpdates()
                //                    self.tableView.insertRows(at: [IndexPath(row: 0, section: 3)], with: .top)
                //                    self.tableView.endUpdates()
                //
                //                    if uniqueItems.count < self.sections[3].sectionDetail.count {
                //                        self.sections[3].sectionDetail.removeAll()
                //                        self.sections[3].sectionDetail.append(contentsOf: uniqueItems)
                //                        self.tableView.deleteRows(at: [IndexPath(row: 0, section: 3)], with: .fade)
                //                    }
                // MARK: WORKING
                //                    initialSelectedSkill.append(skill)
                var uniqueItems = skills.uniqueItemInTheArray{$0}
                initialSelectedSkill.removeAll()
                //                    uniqueItems.removeAll()
                //                    uniqueItems.append(contentsOf: skills)
                uniqueItems.insert("", at: uniqueItems.count)
                initialSelectedSkill.append(contentsOf: uniqueItems)
                self.sections[3].sectionDetail.removeAll()
                self.sections[3].sectionDetail.insert(contentsOf: uniqueItems, at: 0)
                self.tableView.beginUpdates()
                self.tableView.reloadSections(IndexSet(integersIn: 3...3), with: .none) // reloads solely section 3
//                //                self.tableView.insertRows(at: [IndexPath(row: 0, section: 3)], with: .fade)
                self.tableView.endUpdates()
//                tableView.reloadData()
                print("new item: \(self.sections[3].sectionDetail)")
                
                
                //                } else {
                //                    print("inside else")
                //                    let indexToDelete = initialSelectedSkill.firstIndex(of: skill) ?? 400
                //                    initialSelectedSkill.remove(at: indexToDelete)
                //                    self.sections[3].sectionDetail.removeAll()
                //                    self.sections[3].sectionDetail.append(contentsOf: initialSelectedSkill)
                //                    self.tableView.deleteRows(at: [IndexPath(row: 0, section: 3)], with: .fade)
                
                //                    initialSelectedSkill.append(skill)
                //                    var uniqueItems = initialSelectedSkill.uniqueItemInTheArray{$0}
                //                    initialSelectedSkill.removeAll()
                //                    uniqueItems.removeAll()
                //                    uniqueItems.append(contentsOf: skills)
                //                    uniqueItems.insert("", at: uniqueItems.count)
                //                    initialSelectedSkill.append(contentsOf: uniqueItems)
                //                    self.sections[3].sectionDetail.removeAll()
                //                    self.sections[3].sectionDetail.insert(contentsOf: uniqueItems, at: 0)
                ////                    self.tableView.beginUpdates()
                ////                    self.tableView.insertRows(at: [IndexPath(row: 0, section: 3)], with: .top)
                ////                    self.tableView.endUpdates()
                //                    tableView.reloadData()
                
//                                    if uniqueItems.count < self.sections[3].sectionDetail.count {
                //                        self.sections[3].sectionDetail.removeAll()
                //                        self.sections[3].sectionDetail.append(contentsOf: uniqueItems)
                //                        self.tableView.deleteRows(at: [IndexPath(row: 0, section: 3)], with: .fade)
                //                        print("hahaha")
                //                    }
                //                    print(skills)
                //                    print(initialSelectedSkill)
                //                    print(sections[3].sectionDetail)
                
                //                    initialSelectedSkill.forEach { skilll in
                //
                //                        if skill == skilll || skilll == "" {
                //                            print("good")
                //                        } else {
                //                        if initialSelectedSkill.uniqueItemInTheArray(map: {$0}).count < self.sections[3].sectionDetail.count {
                //                                self.sections[3].sectionDetail.removeAll()
                //                                self.sections[3].sectionDetail.append(contentsOf: initialSelectedSkill.uniqueItemInTheArray{$0})
                //                                self.tableView.deleteRows(at: [IndexPath(row: 0, section: 3)], with: .fade)
                //                            print("hahaha")
                //                            }
                //                            if skill != initialSelectedSkill.first && skill != "" {
                //                                print("new item 2")
                //                                let indexToDelete = initialSelectedSkill.firstIndex(of: skill) ?? 400
                //                                //                            print("item already exists: \(indexToDelete)")
                //                                //                            print("item already exists: \(initialSelectedSkill)")
                //                                //                            print("item already exists: \(initialSelectedSkill.count)")
                //
                //                                initialSelectedSkill.remove(at: indexToDelete)
                //                                self.sections[3].sectionDetail.removeAll()
                //                                self.sections[3].sectionDetail.append(contentsOf: initialSelectedSkill)
                //                                self.tableView.deleteRows(at: [IndexPath(row: 0, section: 3)], with: .fade)
                //                            } else {
                //
                //                            }
                //                        }
                //                    }
            } // End of first inner conditional statement
//            } // End of loop
        } else {
            
            initialSelectedSkill.forEach { skill in
                if skill != "" {
                    let indexToDelete = initialSelectedSkill.firstIndex(of: skill) ?? 400
                    initialSelectedSkill.remove(at: indexToDelete)
                    self.sections[3].sectionDetail.removeAll()
                    self.sections[3].sectionDetail.append(contentsOf: initialSelectedSkill)
                    self.tableView.deleteRows(at: [IndexPath(row: 0, section: 3)], with: .fade)
                } // End of second inner conditional statement
            } // End of loop
        } // End of the main conditional statement
        
    } // End of fetchSelectedSkills method
    
} // End of SkillSelectionVCSingleton Extension

// MARK: - TableViewDataSourceAndDelegate Extension
extension PostFormVC: TableViewDataSourceAndDelegate, UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        handleDescriptionTextFieldPlaceHolder(textView)
        handleTitleTextFieldPlaceHolder(textView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].sectionDetail.count//handymanSectionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let titles =  sections[indexPath.section]
        let title = titles.sectionDetail[indexPath.row]
        
        //        if indexPath.section == 0 && indexPath.row == 0 {
        ////            tableView.rowHeight = 90
        //            let viewC = UIView()
        ////            viewC.translatesAutoresizingMaskIntoConstraints = false
        ////            viewC.backgroundColor = .brown
        //            cell.addSubview(viewC)
        //            viewC.anchor(top: cell.topAnchor, leading: cell.leadingAnchor, bottom: cell.bottomAnchor, trailing: cell.trailingAnchor)
        //        }
        //        cell.textLabel?.text = title //handymanSectionArray[indexPath.row]
      
        switch indexPath.section {
        case 0:
            // PostFormCell
            let cell = tableView.dequeueReusableCell(withIdentifier: tableCellID, for: indexPath) as! PostFormCell
            cell.backgroundColor = .white
            
            cell.textLabel?.text = title
            
//            let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
//            let lastIndex = lastRowIndex - 1
//
            if indexPath.row >= 3 {
                cell.setupNewViews()
//                cell.textLabel?.font = .systemFont(ofSize: 11.4)
//                cell.textLabel?.text = imageNameArray[indexPath.row - 3]
//                cell.imageView?.image = UIImage(data: imageDataArray[indexPath.row - 3])
                cell.textLabel?.isHidden = true
                cell.imageView?.isHidden = true
                cell.customLabel2.text = imageNameArray[indexPath.row - 3]
                cell.customImageView.image = UIImage(data: imageDataArray[indexPath.row - 3])
            }
//            else {
//                cell.stackView.isHidden = false
//                cell.setupViews()
//                cell.attachFileBtn.addTarget(self, action: #selector(attachFileBtnTapped), for: .touchUpInside)
//            }
            
//            print("indexPath: \(indexPath.row)")
//            print("lastIndex: \(lastIndex)")

            switch indexPath.row {
            case 0:
                [titleTextField, titlePlaceHolderLabel].forEach{cell.contentView.addSubview($0)}
                titleTextField.anchor(top: cell.contentView.topAnchor, leading: cell.contentView.leadingAnchor, bottom: cell.contentView.bottomAnchor, trailing: cell.contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: cell.separatorInset.left, bottom: 0, right: cell.separatorInset.right + 15))
                
                titlePlaceHolderLabel.anchor(top: titleTextField.topAnchor, leading: titleTextField.leadingAnchor, bottom: titleTextField.bottomAnchor, trailing: cell.contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0))
                                
            case 1:
               
                [descriptionTextField, descriptionPlaceHolderLabel].forEach{cell.contentView.addSubview($0)}
                descriptionTextField.anchor(top: cell.contentView.topAnchor, leading: cell.contentView.leadingAnchor, bottom: cell.contentView.bottomAnchor, trailing: cell.contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: cell.separatorInset.left, bottom: 0, right: cell.separatorInset.right + 15))
                
                descriptionPlaceHolderLabel.anchor(top: descriptionTextField.topAnchor, leading: descriptionTextField.leadingAnchor, bottom: descriptionTextField.bottomAnchor, trailing: cell.contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0))
                
            case 2:
                cell.setupViews()
                cell.attachFileBtn.addTarget(self, action: #selector(attachFileBtnTapped), for: .touchUpInside)
                if isComingFromPostHistory == true {
                    cell.attachFileBtn.isEnabled = false
                }
                
            default:
                break
            }
            
            return cell
        case 1:
            // PostFormProjectTypeCell
            let cell = tableView.dequeueReusableCell(withIdentifier: PostFormProjectTypeCell.cellID, for: indexPath) as! PostFormProjectTypeCell
            cell.setupViews()
            cell.projectTypeSwitcher.addTarget(self, action: #selector(projectTypeSegmentPressed), for: .valueChanged)
            items = cell.items
            if isComingFromPostHistory == true {
                let itemIndex = cell.items.firstIndex(of: postModel?.projectType ?? "nil")
                chosenItem = postModel?.projectType ?? "nil"
                cell.projectTypeSwitcher.selectedSegmentIndex = itemIndex!
            }
            return cell
        case 2:
            // PostFormBudgetCell
            let cell = tableView.dequeueReusableCell(withIdentifier: PostFormBudgetCell.cellID, for: indexPath) as! PostFormBudgetCell
            [stackView].forEach {cell.contentView.addSubview($0)}
            stackView.anchor(top: cell.contentView.topAnchor, leading: cell.contentView.safeAreaLayoutGuide.leadingAnchor, bottom: cell.contentView.bottomAnchor, trailing: cell.contentView.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 0, left: cell.separatorInset.left + 5, bottom: 0, right: cell.separatorInset.right + 15))
            //            cell.setupViews()
            budgetPickerBtn.addTarget(self, action: #selector(budgetPickerBtnTapped), for: .touchUpInside)
            return cell
        case 3:
            // PostFormSkillCell
            let cell = tableView.dequeueReusableCell(withIdentifier: PostFormSkillCell.cellID, for: indexPath) as! PostFormSkillCell
            
            let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections - 1)
            let lastIndex = lastRowIndex - 1
           
            if indexPath.row == lastIndex {
//                cell.textLabel?.isHidden = true
                cell.setupViews()
                cell.addSkillsBtn.backgroundColor = .white
                cell.addSkillsBtn.addTarget(self, action: #selector(addSkillsBtnTapped), for: .touchUpInside)
            } else {
                cell.textLabel?.text = title
                cell.addSkillsBtn.isHidden = true
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    @objc func projectTypeSegmentPressed(_ sender: UISegmentedControl) {
        let item = items[sender.selectedSegmentIndex]
        chosenItem = item
        print("Index: \(sender.selectedSegmentIndex), item: \(item)")
    }
    
    @objc func UpdateDefaultsArrayObserver() {
//        tableView.reloadData()
        print("workin")

        let selectedSkill2 = userDefaults.stringArray(forKey: Keys.selectedSkills) ?? [String]()
        print(selectedSkill2)
        if selectedSkill2.first != "" || !selectedSkill2.isEmpty {
            print("56")
//            let selectedSkill = userDefaults.stringArray(forKey: Keys.selectedSkills) ?? [String]() // retrieve
//            sections.append(SectionHandler(title: "Skills Required", detail: selectedSkill))
//            sections[3].sectionDetail.append(contentsOf: selectedSkill2)
//            sections[3].sectionDetail += selectedSkill
            tableView.reloadData()
//            let uniquePosts = selectedSkill2.unique{$0 ?? ""}

            print(selectedSkill2.filter { $0 != $0})
            for skills in selectedSkill2 {
                self.sections[3].sectionDetail.insert(skills, at: 0)
                print("try: \(self.sections[3].sectionDetail)")
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 3)], with: .top)
                self.tableView.endUpdates()
            }
//            tableView.reloadData()

        } else {
            print("67")

            userDefaults.set(initialSelectedSkill, forKey: Keys.selectedSkills) // save
            let selectedSkill = userDefaults.stringArray(forKey: Keys.selectedSkills) ?? [String]() // retrieve
            sections[3].sectionDetail.append(contentsOf: selectedSkill)
            tableView.reloadData()

        }

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section > 0 {
            return sections[section].sectionTitle
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.section {
        case 0:
            if indexPath.row >= 3 {
                return 60
            }
            return UITableView.automaticDimension
        case 1:
            return 60
        case 2:
            return 40
        default:
            return 40
        }

    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Gives the slide delete feature to the section 0 (but not the 2nd cell in it) and 3 (but not the last cell in it) cells
        switch indexPath.section {
        case 0:
            if indexPath.row <= 2 {
                return false
            } else {
                return true
            }
        case 3:
            let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
            let lastIndex = lastRowIndex - 1
            if indexPath.row == lastIndex {
                return false
            } else {
                return true
            }
        default:
            break
        }
        return false
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)

            switch indexPath.section {
            case 0:
                // Delete item in the arrays
                imageDataArray.remove(at: indexPath.row - 3)
                imageNameArray.remove(at: indexPath.row - 3)
                attachedFileArray["imageData"] = imageDataArray
                attachedFileArray["imageName"] = imageNameArray
                //
                sections[0].sectionDetail.remove(at: indexPath.row)
                // Reload smoothly the cells after removal of an item in the array (beginUpdates & endUpdates are be called because an deletion is happening)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .left)
                tableView.endUpdates()
                
                print(self.sections[0].sectionDetail)
                print("attachedFileArray2: \(attachedFileArray)")
            case 3:
                let check = sections[3].sectionDetail[indexPath.row]
                let indexOfTappedItem = initialSelectedSkill.firstIndex(of: check) ?? 400
//                self.sections[0].sectionDetail.remove(at: index)
//                self.tableView.beginUpdates()
//                self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)
//                self.tableView.endUpdates()
                initialSelectedSkill.remove(at: indexOfTappedItem)
                sections[3].sectionDetail.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .left)
                tableView.endUpdates()
                print("checked removed skill: \(initialSelectedSkill)")
                print("checked removed section: \(sections[3].sectionDetail)")

            default:
                break
            }
            
           
        }
    }
    
}

// MARK: - UIPickerViewDelegate Extension
extension PostFormVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return customArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //        print("\(customArray[row])")
        return customArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Store row index in order to use it outside of its method
        pickerIndex = row
        print("didselect: "+customArray[row])
        finalPick = customArray[row]
    }
    
    fileprivate func setupPickerView() {
        self.view.addSubview(pickerCustomView)
        NSLayoutConstraint.activate([
            pickerCustomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pickerCustomView.heightAnchor.constraint(equalToConstant: 140),
            pickerCustomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerCustomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        pickerCustomView.fadeIn()
    }
    
    @objc func budgetPickerBtnTapped(_ sender: UIButton) {
        setupPickerView()
    }
    
    @objc func doneBtnTapped() {
        pickerCustomView.removeFromSuperview()
        print("123: "+finalPick)
        userDefaults.set(pickerIndex, forKey: Keys.pickerStoredIndex)
        let pickerStoredIndex = userDefaults.integer(forKey: Keys.pickerStoredIndex)
        
        if finalPick != "" {
            budgetPicker.selectRow(pickerStoredIndex, inComponent: 0, animated: true)
            budgetPickerBtn.setTitle(finalPick, for: .normal)
        }
        pickerCustomView.fadeOut()
    }
    
    @objc func cancelBtnTapped() {
        pickerCustomView.fadeOut()
        pickerCustomView.removeFromSuperview()
        let pickerStoredIndex = userDefaults.integer(forKey: Keys.pickerStoredIndex)
        budgetPicker.selectRow(pickerStoredIndex, inComponent: 0, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate Extension
extension PostFormVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
            let fileName = fileUrl.lastPathComponent
            let fileType = fileUrl.pathExtension
            
            var selectedImage = Data()
            // Convert selectedImage into Data type
            fileType == "jpeg" ? (selectedImage = image.jpegData(compressionQuality: 0.4)!) : (selectedImage = image.pngData()!)

            imageDataArray.insert(selectedImage, at: 0)
            imageNameArray.insert(fileName, at: 0)
            attachedFileArray["imageData"] = imageDataArray
            attachedFileArray["imageName"] = imageNameArray
            
            self.sections[0].sectionDetail.insert(fileName, at: 3)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: 3, section: 0)], with: .top)
            self.tableView.endUpdates()
            
        
            print(self.sections[0].sectionDetail)
            print("attachedFileArray: \(attachedFileArray)")
        }
        
        print("did pick")
        // Insert items instead of append to give a smooth reload transition
//        self.sections[3].description.insert(skill, at: 0)
        // Reloads items from the top (beginUpdates & endUpdates are be called because an insertion is happening)
//        self.tableView.beginUpdates()
//        self.tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .top)
//        self.tableView.endUpdates()
//        tableView.reloadData()
        dismiss(animated: true, completion: nil)
        
    }
    
}


// MARK: - PostFormPreviews
import SwiftUI

struct PostFormPreviews: PreviewProvider {
    
    static var previews: some View {
        let vc = PostFormVC()
        return vc.liveViewController
    }
    
}
