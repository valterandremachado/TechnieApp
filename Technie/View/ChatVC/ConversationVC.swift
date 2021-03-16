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
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupViews()
        fetchConvo()
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
        startListeningForConversations()
    }
        
    /// Fetches currentUser's convos (get's currentUser email from userDefaullts in order to differ between sender and receiver)
    private func startListeningForConversations() {
        guard let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }
        
        let userPersistedEmail = getUsersPersistedInfo.email
        
        print("userPersistedEmail: " + userPersistedEmail)
        
        print("starting conversation fetch...")
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: userPersistedEmail)
        
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
                
                self?.noConversationsLabel.isHidden = true
                self?.tableView.isHidden = false
                self?.tableView.reloadData()
            
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
        let conversationDetail = conversations[indexPath.row]
        cell.textLabel?.text =  conversationDetail.name//users[indexPath.row]["name"]

      
        cell.detailTextLabel?.textColor = .systemGray
        cell.textLabel?.font = .boldSystemFont(ofSize: 16)
        cell.accessoryType = .disclosureIndicator

        let messageType = conversationDetail.latestMessage.messageType
        let sender = conversationDetail.latestMessage.sender
        let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo")
        let currentUserSafeEmail = getUsersPersistedInfo?.email
        
        if currentUserSafeEmail == sender {

            let latestMessage = conversationDetail.latestMessage.message
            let modifiedLatestMessage = messageType != "text" ? ("You sent a " + messageType) : ("You: " + latestMessage)
//            customDetailText = modifiedLatestMessage
            cell.detailTextLabel?.text = modifiedLatestMessage

        } else {
            let latestMessage = conversationDetail.latestMessage.message

            let modifiedLatestMessage = messageType != "text" ? ("Sent a " + messageType) : (latestMessage)
            cell.detailTextLabel?.text = modifiedLatestMessage

 
        }

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
            vc.otherUserEmail2 = DatabaseManager.unsafeEmail(emailAddress: userEmail) 
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

