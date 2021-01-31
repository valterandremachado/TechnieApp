//
//  ConversationVC.swift
//  Technie
//
//  Created by Valter A. Machado on 1/19/21.
//

import UIKit
import FirebaseAuth

class ConversationVC: UIViewController {
    
    private var conversations = [Conversation]()

    public var completion: ((SearchResult) -> (Void))?

//    private let spinner = JGProgressHUD(style: .dark)

    private var users = [[String: String]]()

    private var results = [SearchResult]()

    private var loginObserver: NSObjectProtocol?

//    private var hasFetched = false
    
    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tv = UITableView()//(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.isHidden = true
        tv.tableFooterView = UIView()
        tv.showsVerticalScrollIndicator = false
        
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
        
        tv.delegate = self
        tv.dataSource = self
        tv.register(ConversationsTVCell.self, forCellReuseIdentifier: ConversationsTVCell.cellID)
        return tv
    }()
    
    private let noConversationsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Conversations!"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    private var messages = [Message]()

    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupViews()
        fetchConvo()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        // Do any additional setup after loading the view.
//        self.tabBarController?.setTabBar(hidden: true, animated: true, along: nil)
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        // Do any additional setup after loading the view.
//        self.tabBarController?.setTabBar(hidden: false, animated: true, along: nil)
//    }
    var messageInfo = [[String: Any]]()
    var senderEmail = ""
    var customDetailText = ""
    private func listenForMessages(id: String) {
        DatabaseManager.shared.getAllMessagesForConversation(with: id, completion: { [weak self] result in
            switch result {
            case .success(let messages):
                print("success in getting messages: ")//\(messages)
                guard !messages.isEmpty else {
                    print("messages are empty")
                    return
                }
                // Populate messages array
                self?.messages = messages
                self?.updateSender(message: messages)
                
//                self?.messageInfo.append(["senderEmail": lastMessage.flatMap {$0.sender_email} ?? "", "receiverName": lastMessage.flatMap {$0.name} ?? "", "contentType": lastMessage.flatMap {$0.type} ?? ""])
//                print("Display: \(lastMessage?.sender_email)")
            case .failure(let error):
                print("failed to get messages: \(error)")
            }
        })
    }
    
    func updateSender(message: [Message]) {
        guard let lastMessage = messages.last else { return }
        let lastUserDefaultsMessage = UserDefaults.standard.value(forKey: "lastMessage") as? String ?? ""

        let userEmail = UserDefaults.standard.value(forKey: "email") as? String ?? ""
        let currentUserSafeEmail = DatabaseManager.safeEmail(emailAddress: userEmail)
        
        let messageType = lastMessage.kind.messageKindString

        if currentUserSafeEmail == lastMessage.sender_email {
//            senderEmail = lastMessage.sender_email
//            print("name: " + conversations.last!.name)

            guard let latestMessage = conversations.first?.latestMessage.message else { return }
            let modifiedLatestMessage = messageType != "text" ? ("You sent a " + messageType) : ("You: " + latestMessage)
            customDetailText = modifiedLatestMessage
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            UserDefaults.standard.setValue(latestMessage, forKey: "lastMessage")
        } else {
            
            guard let latestMessage = conversations.first?.latestMessage.message else { return }
            let modifiedLatestMessage = messageType != "text" ? ("Sent a " + messageType) : (latestMessage)
            latestMessage != lastUserDefaultsMessage ? (customDetailText = modifiedLatestMessage): (customDetailText = "...")
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            print("they're the different")
        }

    }
    
    // MARK: - Methods
    func setupViews() {
        [tableView, noConversationsLabel].forEach { view.addSubview($0) }
        tableView.frame = view.bounds
        noConversationsLabel.frame = view.bounds
        setupNavBar()
    }
    
    func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.prefersLargeTitles = true
        navigationItem.title = "Chats"
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    func fetchConvo() {
        tableView.isHidden = false
        if Auth.auth().currentUser?.uid != nil {
            //user is logged in
            print("user is logged in")
//            getAllUsers()
            startListeningForConversations()
        } else {
            //user is not logged in
            print("user is signed in")
            insertUser()
            getAllUsers()
        }
    }
    
    func createNewConvo() {
//        let vc = ChatVC(with: email)
//        vc.title = "Valter Machado"
//        vc.navigationItem.largeTitleDisplayMode = .never
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Fetches currentUser's convos (get's currentUser email from userDefaullts in order to differ between sender and receiver)
    private func startListeningForConversations() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }

//        if let observer = loginObserver {
//            NotificationCenter.default.removeObserver(observer)
//        }

        print("starting conversation fetch...")

        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)

        DatabaseManager.shared.getAllConversations(for: safeEmail, completion: { [weak self] result in
            switch result {
            case .success(let conversations):
                print("successfully got conversation models: \(conversations)")
                guard !conversations.isEmpty else {
                    self?.tableView.isHidden = true
                    self?.noConversationsLabel.isHidden = false
                    return
                }
                
                self?.conversations = conversations
                guard let id =  self?.conversations.first?.id else { return }

                self?.noConversationsLabel.isHidden = true
                self?.tableView.isHidden = false
                self?.listenForMessages(id: id)

//                DispatchQueue.main.async {
//                    self?.tableView.reloadData()
//                }
                
            case .failure(let error):
                self?.tableView.isHidden = true
                self?.noConversationsLabel.isHidden = false
                print("failed to get convos: \(error)")
            }
        })
    }

    
    private func createNewConversation(resultEmail: String, resultName: String) {
        let name = resultName
        let email = DatabaseManager.safeEmail(emailAddress: resultEmail)

        // check in datbase if conversation with these two users exists
        // if it does, reuse conversation id
        // otherwise use existing code

        DatabaseManager.shared.conversationExists(with: email, completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let convoId):
                let vc = ChatVC(with: email, id: convoId)
                vc.isNewConvo = false
                vc.title = name
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            case .failure(_):
                let vc = ChatVC(with: email, id: nil)
                vc.isNewConvo = true
                vc.title = name
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
    
    func getAllUsers() {
        DatabaseManager.shared.getAllUsers(completion: { [weak self] result in
            switch result {
            case .success(let usersCollection):
//                self?.hasFetched = true
                self?.users = usersCollection
//                guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
//                self?.users.forEach { userDic in
//                    guard let user = userDic["name"] else { return }
//                    if user == currentUserUID {
//                        print("the same: "+user+" ,"+currentUserUID)
//                    } else {
//                        print("different: "+user+" ,"+currentUserUID)
//                    }
//
//                }
//                print("users: \(usersCollection)")
//                self?.filterUsers(with: query)
                self?.tableView.reloadData()
            case .failure(let error):
                print("Failed to get usres: \(error)")
            }
        })
    }
    
    func insertUser() {
        Auth.auth().signInAnonymously { (result, error) in
            if let error = error {
                print("error sign in: "+error.localizedDescription)
                return
            }
            
            print("signed In")
            guard let userUID = result?.user.uid else { return }
            let firstName = userUID
            let lastName = userUID
            let email = userUID+"@gmail.com"

            let chatUser = ChatAppUser(firstName: firstName,
                                      lastName: lastName,
                                      emailAddress: email)
            
//            let safeEmail = DatabaseManager.safeEmail(emailAddress: email)

            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set(firstName, forKey: "name")

            let name = UserDefaults.standard.value(forKey: "name") as? String ?? "NA"
            print("defaults name: "+name)
            
            DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
                if success {
                    // upload image
//                    guard let image = strongSelf.imageView.image,
//                        let data = image.pngData() else {
//                            return
//                    }
//                    let filename = chatUser.profilePictureFileName
//                    StorageManager.shared.uploadProfilePicture(with: data, fileName: filename, completion: { result in
//                        switch result {
//                        case .success(let downloadUrl):
//                            UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
//                            print(downloadUrl)
//                        case .failure(let error):
//                            print("Storage maanger error: \(error)")
//                        }
//                    })
                }
            })
        }
    }
}

// MARK: - TableViewDataSourceAndDelegate
extension ConversationVC: TableViewDataSourceAndDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count//users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ConversationsTVCell.cellID, for: indexPath) as! ConversationsTVCell
        // Enables detailTextLabel visibility
        cell = ConversationsTVCell(style: .subtitle, reuseIdentifier: ConversationsTVCell.cellID)
        
        cell.textLabel?.text =  conversations[indexPath.row].name//users[indexPath.row]["name"]

        let userEmail = UserDefaults.standard.value(forKey: "email") as? String ?? ""
        let currentUserSafeEmail = DatabaseManager.safeEmail(emailAddress: userEmail)
        print("test: \(senderEmail)")
        cell.detailTextLabel?.textColor = .systemGray
        cell.textLabel?.font = .boldSystemFont(ofSize: 16)
//        senderEmail == currentUserSafeEmail ? (cell.detailTextLabel?.text = "You: " + conversations[indexPath.row].latestMessage.message) : (cell.detailTextLabel?.text = conversations[indexPath.row].latestMessage.message)
//        let lastMessage = UserDefaults.standard.value(forKey: "lastMessage") as? String ?? ""
//        UserDefaults.standard.removeObject(forKey: "lastMessage")
        
//        if senderEmail == currentUserSafeEmail {
//            print("senderEmail1: \(senderEmail), userEmail: \(currentUserSafeEmail)")
////            cell.detailTextLabel?.text = "You: " + conversations[indexPath.row].latestMessage.message
//            cell.detailTextLabel?.text = customDetailText
////            UserDefaults.standard.setValue(conversations[indexPath.row].latestMessage.message, forKey: "lastMessage")
//        } else {
////            cell.detailTextLabel?.text = customDetailText
////            print("senderEmail2: \(senderEmail), userEmail: \(currentUserSafeEmail)")
//            cell.detailTextLabel?.text = conversations[indexPath.row].latestMessage.message
////            UserDefaults.standard.setValue(conversations[indexPath.row].latestMessage.message, forKey: "lastMessage")
//        }
        
        cell.detailTextLabel?.text = customDetailText

        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        guard let userName = users[indexPath.row]["name"] else { return }
//        guard let userEmail = users[indexPath.row]["email"] else { return }
        
        let convosModel = conversations[indexPath.row]
        let userName = convosModel.name
        let userEmail = convosModel.otherUserEmail
//        let vc = ChatVC(with: userEmail, id: UUID().uuidString)
//        vc.isNewConvo = true
//        vc.title = userName
//        vc.navigationItem.largeTitleDisplayMode = .never
//        navigationController?.pushViewController(vc, animated: true)
        
       
        let currentConversations = self.conversations

        if let targetConversation = currentConversations.first(where: {
            $0.otherUserEmail == DatabaseManager.safeEmail(emailAddress: userEmail)
        }) {
            let vc = ChatVC(with: targetConversation.otherUserEmail, id: targetConversation.id)
            vc.isNewConvo = false
            vc.title = targetConversation.name
            vc.conversations = conversations
            vc.navigationItem.largeTitleDisplayMode = .never
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.createNewConversation(resultEmail: userEmail, resultName: userName)
        }
    }
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // begin delete
//            let conversationId = conversations[indexPath.row].id
//            tableView.beginUpdates()
//            self.conversations.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .left)
//
//            DatabaseManager.shared.deleteConversation(conversationId: conversationId, completion: { success in
//                if !success {
//                    // add model and row back and show error alert
//
//                }
//            })
//
//            tableView.endUpdates()
//        }
//    }
}

