//
//  ChatVC.swift
//  Technie
//
//  Created by Valter A. Machado on 1/19/21.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import SDWebImage
import CoreLocation

typealias MessagesCollectionViewDelegateAndDataSource = MessagesLayoutDelegate & MessagesDataSource & MessagesDisplayDelegate

class ChatVC: MessagesViewController {
    
    // Shared variable from this vc to ChatInfo then to PhotoCollectionViewerVC
    private var convoSharedPhotoArray = [String]()
    private var convoSharedLocationArray = [String]()

    // MARK: - Properties
    private var conversations = [Conversation]()
    public var isNewConvo = false
    private var convoId: String?
    public let otherUserEmail: String
    
    private var senderPhotoURL: URL?
    private var otherUserPhotoURL: URL?
    
    public static let dateFormatter: DateFormatter = {
        let formattre = DateFormatter()
        formattre.dateStyle = .medium
        formattre.timeStyle = .long
        formattre.locale = .current
        return formattre
    }()
    
    private var messages = [Message]()
    
    private var selfSender: Sender? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        return Sender(photoURL: "",
                      senderId: safeEmail,
                      displayName: "Me")
    }
    
    lazy var sendMessageBarBtn: InputBarButtonItem = {
        let btn = InputBarButtonItem()
        btn.isEnabled = false
        btn.setSize(CGSize(width: 30, height: 30), animated: false)
        btn.setImage((UIImage(named: "send")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal))?.imageResized(to: CGSize(width: 23, height: 23)), for: .normal)
        btn.onTouchUpInside { [weak self] _ in
            self?.messagesCollectionView.scrollToLastItem()
            // add send func here
            self?.messageInputBar.didSelectSendButton()
            self?.messageInputBar.inputTextView.text = nil
        }
        return btn
    }()
    
    var customHeight: CGFloat = 0
    var isShowingKeyboard = false
    
    // MARK: - Inits
    init(with email: String, id: String?) {
        self.otherUserEmail = email
        self.convoId = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupInputBarButtons()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        view.backgroundColor = .white
        addKeyboardObservers()
        
        //        messages.append(Message(sender: selfSender, messageId: "0", sentDate: Date(), kind: .text("Heyy!!")))
        //        messages.append(Message(sender: selfSender, messageId: "0", sentDate: Date(), kind: .text("Heyy Heyy Heyy!!")))
        //        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        messageInputBar.inputTextView.becomeFirstResponder()
        
        if let conversationId = convoId {
            listenForMessages(id: conversationId, shouldScrollToBottom: true)
        }
        
        self.tabBarController?.setTabBar(hidden: true, animated: true, along: nil)
        setupNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Do any additional setup after loading the view.
        self.tabBarController?.setTabBar(hidden: false, animated: true, along: nil)
    }
    
    deinit {
        removeKeyboardObservers()
    }
    var scrollsToBottomOnKeybordBeginsEditing = false
    
    // MARK: - Methods
    func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        let rightNavBarButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(rightNavBarBtnTapped))
        navigationItem.rightBarButtonItem = rightNavBarButton
    }
    
    func getMessagesCollectionViewLastIndexPath() -> IndexPath? {
        for sectionIndex in (0..<messagesCollectionView.numberOfSections).reversed() {
            if messagesCollectionView.numberOfItems(inSection: sectionIndex) > 0 {
                return IndexPath.init(item: messagesCollectionView.numberOfItems(inSection: sectionIndex)-1, section: sectionIndex)
            }
        }
        
        return nil
    }
    
    fileprivate func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(customHandleKeyboardWillHideState), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(customHandleKeyboardDidChangeState), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(customHandleKeyboardDidChangeState), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(customHandleTextViewDidBeginEditing), name: UITextField.textDidBeginEditingNotification, object: messageInputBar.inputTextView)
    }
    
    fileprivate func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func setupInputBarButtons() {
        messageInputBar.inputTextView.placeholder = "Type a message..."
        
        //        self.isShowingKeyboard == false || self.customHeight > 50 ? (self.messagesCollectionView.contentInset.bottom =  (self.messageInputBar.frame.height) + 10) : (self.messagesCollectionView.contentInset.bottom =  self.customHeight + 10)
        
        let photoMessageBarBtn = InputBarButtonItem()
        photoMessageBarBtn.setSize(CGSize(width: 35, height: 35), animated: false)
        photoMessageBarBtn.setImage(UIImage(systemName: "photo.fill"), for: .normal)
        photoMessageBarBtn.onTouchUpInside { [weak self] _ in
            //            self?.presentInputActionSheet()
            self?.presentPhotoInputActionsheet()
        }
        
        let locationMessageBarBtn = InputBarButtonItem()
        locationMessageBarBtn.setSize(CGSize(width: 35, height: 35), animated: false)
        locationMessageBarBtn.setImage((UIImage(named: "location")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal))?.imageResized(to: CGSize(width: 18, height: 18)), for: .normal)
        locationMessageBarBtn.onTouchUpInside { [weak self] _ in
            self?.presentLocationPicker()
        }
        
        messageInputBar.setLeftStackViewWidthConstant(to: 70, animated: false)
        messageInputBar.setStackViewItems([photoMessageBarBtn, locationMessageBarBtn], forStack: .left, animated: false)
        //        messageInputBar.leftStackView.addBackground(color: .red)
        
        messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
        messageInputBar.setStackViewItems([sendMessageBarBtn], forStack: .right, animated: false)
    }
    
    private func presentInputActionSheet() {
        let actionSheet = UIAlertController(title: "Attach Media",
                                            message: "What would you like to attach?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoInputActionsheet()
        }))
        //        actionSheet.addAction(UIAlertAction(title: "Video", style: .default, handler: { [weak self]  _ in
        ////            self?.presentVideoInputActionsheet()
        //        }))
        //        actionSheet.addAction(UIAlertAction(title: "Audio", style: .default, handler: {  _ in
        //        }))
        actionSheet.addAction(UIAlertAction(title: "Location", style: .default, handler: { [weak self]  _ in
            self?.presentLocationPicker()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.fixActionSheetConstraintsError()
        present(actionSheet, animated: true)
    }
    
    private func presentPhotoInputActionsheet() {
        let actionSheet = UIAlertController(title: "Attach Photo",
                                            message: "Where would you like to attach a photo from",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.fixActionSheetConstraintsError()
        present(actionSheet, animated: true)
    }
    
    private func presentLocationPicker() {
        let vc = LocationPickerVC(coordinates: nil)
        vc.title = "Pick Location"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { [weak self] selectedCoorindates in
            
            guard let strongSelf = self else {
                return
            }
            
            guard let messageId = strongSelf.createMessageId(),
                  let conversationId = strongSelf.convoId,
                  let name = strongSelf.title,
                  let selfSender = strongSelf.selfSender else {
                return
            }
            
            let longitude: Double = selectedCoorindates.longitude
            let latitude: Double = selectedCoorindates.latitude
            
            print("long = \(longitude) | lat = \(latitude)")
            
            
            let location = Location(location: CLLocation(latitude: latitude, longitude: longitude),
                                    size: .zero)
            
            let message = Message(sender: selfSender,
                                  messageId: messageId,
                                  sentDate: Date(),
//                                  sender_email: self?.otherUserEmail ?? "nil",
                                  kind: .location(location))
            
            DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: strongSelf.otherUserEmail, name: name, newMessage: message, completion: { success in
                if success {
                    print("sent location message")
                }
                else {
                    print("failed to send location message")
                }
            })
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func listenForMessages(id: String, shouldScrollToBottom: Bool) {
        DatabaseManager.shared.getAllMessagesForConversation(with: id, completion: { [weak self] result in
            switch result {
            case .success(let messages):
                
                self?.messageInputBar.inputTextView.placeholder = "Type a message..."
                self?.sendMessageBarBtn.isEnabled = true
                //                self?.messageInputBar.inputTextView.isUserInteractionEnabled = true
                //                self?.messageInputBar.sendButton.stopAnimating()
                //                print("success in getting messages: \(messages)")
                guard !messages.isEmpty else {
                    print("messages are empty")
                    return
                }
                // Populate messages array
                self?.messages = messages
                
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadDataAndKeepOffset()
                    guard let wrappedHeight = self?.customHeight else { return }
                    print("customHeight: \(wrappedHeight)")
                    
                    if shouldScrollToBottom {
                        
                        self!.isShowingKeyboard == false ? (self?.messagesCollectionView.contentInset.bottom =  (self?.messageInputBar.frame.height)! + 10) : (self?.messagesCollectionView.contentInset.bottom =  wrappedHeight + 10)
                        self?.scrollsToBottomOnKeybordBeginsEditing = shouldScrollToBottom
                        self?.messagesCollectionView.scrollToLastItem()
                    }
                }
            case .failure(let error):
                print("failed to get messages: \(error)")
            }
        })
    }
    
    private func createMessageId() -> String? {
        // date, otherUesrEmail, senderEmail, randomInt
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        
        let safeCurrentEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)
        
        let dateString = Self.dateFormatter.string(from: Date())
        let newIdentifier = "\(otherUserEmail)_\(safeCurrentEmail)_\(dateString)"
        
        print("created message id: \(newIdentifier)")
        
        return newIdentifier
    }
    
    // MARK: - Selectors
    @objc func rightNavBarBtnTapped() {
        let vc = ChatInfoVC()
        vc.convoSharedPhotoArray = convoSharedPhotoArray
        vc.convoSharedLocationArray = convoSharedLocationArray
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func customHandleKeyboardDidChangeState(_ notification: Notification) {
        
        guard let keyboardEndFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        if (keyboardEndFrame.origin.y + keyboardEndFrame.size.height) > view.frame.size.height {
            // Hardware keyboard is found
            messagesCollectionView.contentInset.bottom = (view.frame.size.height - keyboardEndFrame.origin.y) + 10
        } else {
            //Software keyboard is found
            let bottomInset = keyboardEndFrame.height > messageInputBar.frame.height ? keyboardEndFrame.height + 10 : messageInputBar.frame.height + 10
            messagesCollectionView.contentInset.bottom = bottomInset
        }
        
        customHeight = keyboardEndFrame.height
        isShowingKeyboard = true
        var aRect = self.view.frame
        aRect.size.height -= keyboardEndFrame.height 
        if let indexPath = getMessagesCollectionViewLastIndexPath(), let activeField = messagesCollectionView.cellForItem(at: indexPath) {
            if (!aRect.contains(activeField.frame.origin) ) {
                messagesCollectionView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc func customHandleTextViewDidBeginEditing(_ notification: Notification) {
        messagesCollectionView.scrollToLastItem(animated: true)
    }
    
    @objc func customHandleKeyboardWillHideState(_ notification: Notification) {
        self.messagesCollectionView.contentInset.bottom =  (self.messageInputBar.frame.height) + 20
        //        self.messagesCollectionView.scrollToLastItem()
        //        isShowingKeyboard = false
    }
    
    
    //    @objc func handleKeyboardWillShow(notification: Notification) {
    //
    //        messagesCollectionView.scrollToItem(at: IndexPath(row: messages.count - 1, section: messages.count), at: .top, animated: false)
    //    }
    
}

// MARK: - UIImagePickerControllerDelegate Extension
extension ChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let messageId = createMessageId(),
              let conversationId = convoId,
              let name = self.title,
              let selfSender = selfSender else {
            return
        }
        
        if let image = info[.editedImage] as? UIImage, let imageData =  image.pngData() {
            let fileName = "photo_message_" + messageId.replacingOccurrences(of: " ", with: "-") + ".png"
            
            // Upload image
            
            StorageManager.shared.uploadMessagePhoto(with: imageData, fileName: fileName, completion: { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                
                switch result {
                case .success(let urlString):
                    // Ready to send message
                    print("Uploaded Message Photo: \(urlString)")
                    
                    guard let url = URL(string: urlString),
                          let placeholder = UIImage(systemName: "plus") else {
                        return
                    }
                    
                    let media = Media(url: url,
                                      image: nil,
                                      placeholderImage: placeholder,
                                      size: .zero)
                    
                    let message = Message(sender: selfSender,
                                          messageId: messageId,
                                          sentDate: Date(),
//                                          sender_email: self?.otherUserEmail ?? "nil",
                                          kind: .photo(media))
                    
                    DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: strongSelf.otherUserEmail, name: name, newMessage: message, completion: { success in
                        
                        if success {
                            print("sent photo message")
                        }
                        else {
                            print("failed to send photo message")
                        }
                        
                    })
                    
                case .failure(let error):
                    print("message photo upload error: \(error)")
                }
            })
        }
        else if let videoUrl = info[.mediaURL] as? URL {
            let fileName = "photo_message_" + messageId.replacingOccurrences(of: " ", with: "-") + ".mov"
            
            // Upload Video
            
            StorageManager.shared.uploadMessageVideo(with: videoUrl, fileName: fileName, completion: { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                
                switch result {
                case .success(let urlString):
                    // Ready to send message
                    print("Uploaded Message Video: \(urlString)")
                    
                    guard let url = URL(string: urlString),
                          let placeholder = UIImage(systemName: "plus") else {
                        return
                    }
                    
                    let media = Media(url: url,
                                      image: nil,
                                      placeholderImage: placeholder,
                                      size: .zero)
                    
                    let message = Message(sender: selfSender,
                                          messageId: messageId,
                                          sentDate: Date(),
//                                          sender_email: self?.otherUserEmail ?? "nil",
                                          kind: .video(media))
                    
                    DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: strongSelf.otherUserEmail, name: name, newMessage: message, completion: { success in
                        
                        if success {
                            print("sent photo message")
                        }
                        else {
                            print("failed to send photo message")
                        }
                        
                    })
                    
                case .failure(let error):
                    print("message photo upload error: \(error)")
                }
            })
        }
    }
    
}

// MARK: - InputBarAccessoryViewDelegate Extension
extension ChatVC: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        if text == " " || text == "" {
            sendMessageBarBtn.setImage((UIImage(named: "send")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal))?.imageResized(to: CGSize(width: 23, height: 23)), for: .normal)
            sendMessageBarBtn.isEnabled = false
        } else {
            sendMessageBarBtn.setImage((UIImage(named: "send.fill")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal))?.imageResized(to: CGSize(width: 23, height: 23)), for: .normal)
            sendMessageBarBtn.isEnabled = true
        }
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        if !text.replacingOccurrences(of: " ", with: "").isEmpty {
            messageInputBar.inputTextView.placeholder = "Sending..."
            //        inputBar.sendButton.startAnimating()
            //        inputBar.inputTextView.isUserInteractionEnabled = false
        }
        
        
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              let selfSender = self.selfSender,
              let messageId = createMessageId() else {
            return
        }
        
        let message = Message(sender: selfSender,
                              messageId: messageId,
                              sentDate: Date(),
//                              sender_email: otherUserEmail,
                              kind: .text(text))
        // Otherwise send message
        if isNewConvo {
            print("isNewConvo")
            // Create the convo in databse
            DatabaseManager.shared.createNewConversation(with: otherUserEmail, name: navigationItem.title ?? "User", firstMessage: message, completion: { [weak self] success in
                if success {
                    print("message sent")
                    self?.isNewConvo = false
                    let newConversationId = "conversation_\(message.messageId)"
                    self?.convoId = newConversationId
                    self?.listenForMessages(id: newConversationId, shouldScrollToBottom: true)
                    self?.messageInputBar.inputTextView.text = nil
                    //                    inputBar.inputTextView.placeholder = "Aa"
                    //                    inputBar.inputTextView.isUserInteractionEnabled = true
                    //                    inputBar.sendButton.stopAnimating()
                }
                else {
                    print("failed ot send")
                }
            })
        } else {
            print("OldConvo")
            guard let conversationId = convoId, let name = self.title else {
                return
            }
            
            // append to existing convo
            DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: otherUserEmail, name: name, newMessage: message, completion: { [weak self] success in
                if success {
                    self?.messageInputBar.inputTextView.text = nil
                    print("message sent")
                }
                else {
                    print("failed to send")
                }
            })
        }
    }
}

// MARK: - MessagesCollectionViewDelegateAndDataSource Extension
extension ChatVC: MessagesCollectionViewDelegateAndDataSource {
    
    //    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
    //
    //        var lastSectionIndexPath = IndexPath.init(row: 0, section: 0)
    //
    //        for i in 0..<self.messagesCollectionView.numberOfSections {
    //            for j in 0..<self.messagesCollectionView.numberOfItems(inSection: i) {
    //                let indexPath = IndexPath(row: j, section: i)
    //                lastSectionIndexPath = indexPath
    //            }
    //        }
    //
    //        if lastSectionIndexPath.section == section {
    //            var viewHeight = CGSize.init()
    ////            self.isShowingKeyboard == false ? (viewHeight = CGSize.init()) : (viewHeight = CGSize(width: view.frame.width, height: 50))
    //            print(section)
    //            print(lastSectionIndexPath.section)
    //            return viewHeight
    //        }
    //
    //        return CGSize.init()
    //    }
    
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }
        
        fatalError("Self Sender is nil, email should be cached")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {

//        if messages[indexPath.section].kind.messageKindString == "photo" {
//            if let safeMessageContent = messages[indexPath.section].content {
//                convoSharedPhotoArray.append(safeMessageContent)
//                let uniqueArrayOfPhoto = convoSharedPhotoArray.uniqueItemInTheArray{$0}
//                convoSharedPhotoArray.removeAll()
//                convoSharedPhotoArray.append(contentsOf: uniqueArrayOfPhoto)
//            }
//        }
        
        switch messages[indexPath.section].kind.messageKindString {
        case "photo":
            if let safeMessageContent = messages[indexPath.section].content {
                convoSharedPhotoArray.append(safeMessageContent)
                let uniqueArrayOfPhoto = convoSharedPhotoArray.uniqueItemInTheArray{$0}
                convoSharedPhotoArray.removeAll()
                convoSharedPhotoArray.append(contentsOf: uniqueArrayOfPhoto)
            }
        case "location":
            if let safeMessageContent = messages[indexPath.section].content {
                convoSharedLocationArray.append(safeMessageContent)
                let uniqueArrayOfPhoto = convoSharedLocationArray.uniqueItemInTheArray{$0}
                convoSharedLocationArray.removeAll()
                convoSharedLocationArray.append(contentsOf: uniqueArrayOfPhoto)
            }
        default:
            break
        }
        
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let message = message as? Message else {
            return
        }
        
        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            imageView.sd_setImage(with: imageUrl, completed: nil)
        default:
            break
        }
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let sender = message.sender
        if sender.senderId == selfSender?.senderId {
            // Sender bubble color
            return .link
        }
        // Receiver bubble color
        return .secondarySystemBackground
    }
    
    //    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
    //
    //        let sender = message.sender
    //
    //        if sender.senderId == selfSender?.senderId {
    //            // show our image
    //            if let currentUserImageURL = self.senderPhotoURL {
    //                avatarView.sd_setImage(with: currentUserImageURL, completed: nil)
    //            }
    //            else {
    //                // images/safeemail_profile_picture.png
    //
    //                guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
    //                    return
    //                }
    //
    //                let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
    //                let path = "images/\(safeEmail)_profile_picture.png"
    //
    //                // fetch url
    //                StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
    //                    switch result {
    //                    case .success(let url):
    //                        self?.senderPhotoURL = url
    //                        DispatchQueue.main.async {
    //                            avatarView.sd_setImage(with: url, completed: nil)
    //                        }
    //                    case .failure(let error):
    //                        print("\(error)")
    //                    }
    //                })
    //            }
    //        }
    //        else {
    //            // other user image
    //            if let otherUsrePHotoURL = self.otherUserPhotoURL {
    //                avatarView.sd_setImage(with: otherUsrePHotoURL, completed: nil)
    //            }
    //            else {
    //                // fetch url
    //                let email = self.otherUserEmail
    //
    //                let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
    //                let path = "images/\(safeEmail)_profile_picture.png"
    //
    //                // fetch url
    //                StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
    //                    switch result {
    //                    case .success(let url):
    //                        self?.otherUserPhotoURL = url
    //                        DispatchQueue.main.async {
    //                            avatarView.sd_setImage(with: url, completed: nil)
    //                        }
    //                    case .failure(let error):
    //                        print("\(error)")
    //                    }
    //                })
    //            }
    //        }
    //
    //    }
    
}

// MARK: - MessageCellDelegate Extension
extension ChatVC: MessageCellDelegate {
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
            return
        }
        
        let message = messages[indexPath.section]
        
        switch message.kind {
        case .location(let locationData):
            let coordinates = locationData.location.coordinate
            let vc = LocationPickerVC(coordinates: coordinates)
            vc.title = "Client's Location"
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
            return
        }
        
        let message = messages[indexPath.section]
        
        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            let vc = PhotoViewerVC(with: imageUrl)
            navigationController?.pushViewController(vc, animated: true)
            
//        case .video(let media):
//            guard let videoUrl = media.url else {
//                return
//            }
//
//            let vc = AVPlayerViewController()
//            vc.player = AVPlayer(url: videoUrl)
//            present(vc, animated: true)
        default:
            break
        }
    }
}

extension UICollectionView {
    
    func scrollToLastIndexPath(position: UICollectionView.ScrollPosition, animated: Bool) {
        self.layoutIfNeeded()
        
        for sectionIndex in (0..<self.numberOfSections).reversed() {
            if self.numberOfItems(inSection: sectionIndex) > 0 {
                self.scrollToItem(at: IndexPath.init(item: self.numberOfItems(inSection: sectionIndex)-1, section: sectionIndex),
                                  at: position,
                                  animated: animated)
                break
            }
        }
    }
    
}
