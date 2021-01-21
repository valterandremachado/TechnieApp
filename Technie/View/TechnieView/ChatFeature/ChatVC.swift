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
    
    init(with email: String, id: String?) {
        self.otherUserEmail = email
        self.convoId = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let mySendBtn = UIButton(type: .custom)
//        mySendBtn.frame = CGRect(x: 329, y: 12, width: 30, height: 30)
//        //            mySendBtn.backgroundColor = .gray
//        mySendBtn.setImage(UIImage(systemName:"paperplane.fill"), for: .normal)
//        mySendBtn.imageView?.contentMode = .scaleAspectFit
//        mySendBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//        mySendBtn.addTarget(self, action: #selector(sendPressed(sender:)), for: .touchUpInside)
//        messageInputBar.addSubview(mySendBtn)
       
        // Do any additional setup after loading the view.
//        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
//            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
//            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
//            layout.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
//            layout.minimumInteritemSpacing = 0
//            layout.minimumLineSpacing = 0
//        }
        
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        setupInputBarButtons()
        view.backgroundColor = .white
        
//        messages.append(Message(sender: selfSender, messageId: "0", sentDate: Date(), kind: .text("Heyy!!")))
//        messages.append(Message(sender: selfSender, messageId: "0", sentDate: Date(), kind: .text("Heyy Heyy Heyy!!")))
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

    }
    @objc func sendPressed(sender: UIButton) {
//        sender.backgroundColor = ColorPresets.appleSendBlue
        messagesCollectionView.scrollToLastItem()

        // add send func here
        messageInputBar.didSelectSendButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
        if let conversationId = convoId {
            listenForMessages(id: conversationId, shouldScrollToBottom: true)
        }
        self.tabBarController?.setTabBar(hidden: true, animated: true, along: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Do any additional setup after loading the view.
        self.tabBarController?.setTabBar(hidden: false, animated: true, along: nil)
    }
    
//    @objc func handleKeyboardWillShow(notification: Notification) {
//
//        messagesCollectionView.scrollToItem(at: IndexPath(row: messages.count - 1, section: messages.count), at: .top, animated: false)
//    }
    
    private func setupInputBarButtons() {
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
        
        let sendMessageBarBtn = InputBarButtonItem()
        sendMessageBarBtn.setSize(CGSize(width: 30, height: 30), animated: false)
        sendMessageBarBtn.setImage((UIImage(named: "send.fill")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal))?.imageResized(to: CGSize(width: 25, height: 25)), for: .normal)
        sendMessageBarBtn.onTouchUpInside { [weak self] _ in
            self?.messagesCollectionView.scrollToLastItem()
            // add send func here
            self?.messageInputBar.didSelectSendButton()
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
            
            print("long=\(longitude) | lat= \(latitude)")
            
            
            let location = Location(location: CLLocation(latitude: latitude, longitude: longitude),
                                    size: .zero)
            
            let message = Message(sender: selfSender,
                                  messageId: messageId,
                                  sentDate: Date(),
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
                print("success in getting messages: \(messages)")
                guard !messages.isEmpty else {
                    print("messages are empty")
                    return
                }
                self?.messages = messages

                DispatchQueue.main.async {
//                    self?.messagesCollectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 70, right: 0)
                    self?.messagesCollectionView.reloadDataAndKeepOffset()

                    if shouldScrollToBottom {
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
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
       
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              let selfSender = self.selfSender,
              let messageId = createMessageId() else {
            return
        }
        
        let message = Message(sender: selfSender,
                               messageId: messageId,
                               sentDate: Date(),
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
    
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }

        fatalError("Self Sender is nil, email should be cached")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
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

            vc.title = "Location"
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
