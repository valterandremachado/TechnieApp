//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Valter A. Machado on 1/19/21.
//

import Foundation
import FirebaseDatabase
import MessageKit
import CoreLocation
import CodableFirebase

/// Manager object to read and write data to real time firebase database
final class DatabaseManager {

    /// Shared instance of class
    public static let shared = DatabaseManager()

    private let database = Database.database().reference()

    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

extension DatabaseManager {

    /// Returns dictionary node at child path
    public func getDataFor(path: String, completion: @escaping (Result<Any, Error>) -> Void) {
        database.child("\(path)").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        }
    }

}

// MARK: - Account Mgmt

extension DatabaseManager {

    /// Checks if user exists for given email
    /// Parameters
    /// - `email`:              Target email to be checked
    /// - `completion`:   Async closure to return with result
    public func userExists(with email: String,
                           completion: @escaping ((Bool) -> Void)) {

        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? [String: Any] != nil else {
                completion(false)
                return
            }

            completion(true)
        })

    }

    /// Inserts new user to database
    public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ], withCompletionBlock: { [weak self] error, _ in

            guard let strongSelf = self else {
                return
            }

            guard error == nil else {
                print("failed ot write to database")
                completion(false)
                return
            }

            strongSelf.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                if var usersCollection = snapshot.value as? [[String: String]] {
                    // append to user dictionary
                    let newElement = [
                        "name": user.firstName + " " + user.lastName,
                        "email": user.safeEmail
                    ]
                    usersCollection.append(newElement)

                    strongSelf.database.child("users").setValue(usersCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }

                        completion(true)
                    })
                }
                else {
                    // create that array
                    let newCollection: [[String: String]] = [
                        [
                            "name": user.firstName + " " + user.lastName,
                            "email": user.safeEmail
                        ]
                    ]

                    strongSelf.database.child("users").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }

                        completion(true)
                    })
                }
            })
        })
    }
    
    
    public func insertTechnicianUser(with user: TechnicianUserModel, completion: @escaping (Bool) -> Void) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ], withCompletionBlock: { [weak self] error, _ in

            guard let strongSelf = self else {
                return
            }

            guard error == nil else {
                print("failed ot write to database")
                completion(false)
                return
            }

            strongSelf.database.child("users/technicians").observeSingleEvent(of: .value, with: { snapshot in
                if var usersCollection = snapshot.value as? [[String: Any]] {
                    // append to user dictionary
                    let newElement = [
                        "profileInfo": [
                            "name": user.firstName + " " + user.lastName,
                            "email": user.safeEmail,
                            "location": user.location,
                            "profileSummary": user.profileSummary,
                            "experience": user.experience,
                            "skills": user.skills,
                            "accountType": user.accountType,
                            "hourlyRate": user.hourlyRate,
                        ],
                        
                        "numberOfCompletedServices": user.numberOfCompletedServices,
                        "numberOfActiveServices": user.numberOfActiveServices,
                        "numberOfPreviousServices": user.numberOfPreviousServices,
                        "technieRank": user.technieRank
                    ] as [String : Any]
                    
                    usersCollection.append(newElement)

                    strongSelf.database.child("users/technicians").setValue(usersCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }

                        completion(true)
                    })
                }
                else {
                    // create that array
                    let newCollection: [[String: Any]] = [
                        [
                            "profileInfo": [
                                "name": user.firstName + " " + user.lastName,
                                "email": user.safeEmail,
                                "location": user.location,
                                "profileSummary": user.profileSummary,
                                "experience": user.experience,
                                "skills": user.skills, // array
                                "accountType": user.accountType,
                                "hourlyRate": user.hourlyRate,
                            ],
                            
                            "numberOfCompletedServices": user.numberOfCompletedServices,
                            "numberOfActiveServices": user.numberOfActiveServices,
                            "numberOfPreviousServices": user.numberOfPreviousServices,
                            "technieRank": user.technieRank
                        ]
                    ]

                    strongSelf.database.child("users/technicians").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }

                        completion(true)
                    })
                }
            })
        })
    }

    public func insertClientUser(with user: ClientUserModel, completion: @escaping (Bool) -> Void) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ], withCompletionBlock: { [weak self] error, _ in

            guard let strongSelf = self else {
                return
            }

            guard error == nil else {
                print("failed ot write to database")
                completion(false)
                return
            }

            strongSelf.database.child("users/clients").observeSingleEvent(of: .value, with: { snapshot in
                if var usersCollection = snapshot.value as? [[String: Any]] {
                    // append to user dictionary
                    let newElement = [
                        "profileInfo": [
                            "name": user.firstName + " " + user.lastName,
                            "email": user.safeEmail,
                            "location": user.location
                        ],
                        
                        "numberOfPosts": user.numberOfPosts,
                        "numberOfActivePosts": user.numberOfActivePosts,
                        "numberOfInactivePosts": user.numberOfInactivePosts
                    ] as [String : Any]
                    
                    usersCollection.append(newElement)
                    strongSelf.database.child("users/clients").setValue(usersCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }

                        completion(true)
                    })
                } else {
                    // create that array
                    let newCollection: [[String: Any]] = [
                        [
                            "profileInfo": [
                                "name": user.firstName + " " + user.lastName,
                                "email": user.safeEmail,
                                "location": user.location
                            ],
                            
                            "numberOfPosts": user.numberOfPosts,
                            "numberOfActivePosts": user.numberOfActivePosts,
                            "numberOfInactivePosts": user.numberOfInactivePosts
                        ]
                    ]

                    strongSelf.database.child("users/clients").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }

                        completion(true)
                    })
                }
            })
        })
    }
    
//    public func postService(userUID: String, completion: @escaping (Bool) -> Void) {
//
//        database.child("users").observeSingleEvent(of: .value, with: { [weak self] snapshot in
//            //                print("VALUE: \(snapshot.value)")
//            guard let strongSelf = self else {
//                return
//            }
//
//            if var usersCollection = snapshot.value as? [[String: Any]] {
//                // append to user dictionary
//                let newElement = [
////                    "servicePosts": [
////                    [
//                        "title": "user.firstName + user.lastName",
//                        "description": "user.safeEmail",
//                        "attachments": "user.location",
//                        "projectType": "user.location",
//                        "budget": "user.location",
//                        "requiredSkills": "user.location3"
////                    ]
////                        ]
//                ]
//
//                for index in 0..<usersCollection.count {
//                    let user = usersCollection[index]
////                    print("USERS: \(user)")
//                    for (key , values) in user {
////                        print("value: \(values), key: \(key)")
//                        guard let value = values as? [String: Any] else { return }
//                        if key == "servicePosts" {
//                            guard let value = values as? [String: Any] else { return }
//                            print("servicePostsValue: \(value.values)")
//                        }
//                        let email = value["email"] as? String
//                        if email  == "test3-hotmail-com" && key != "servicePosts" {
//                            print("email: \(String(describing: email)), indexOf: \(index)")
//
//                            strongSelf.database.child("users/\(index)").child("servicePosts").childByAutoId().setValue(newElement, withCompletionBlock: { error, _ in
//                                print("That error: \(error?.localizedDescription ?? "nil")")
//
//                                guard error == nil else {
//                                    completion(false)
//                                    return
//                                }
//                                completion(true)
//                            })
//                            return // Get out of the loop once the right much is found
//                        }
//                    }
//
//                }
//
//            }
//        })
//    }
    
    public func insertPostToUserDB(with postID: String, completion: @escaping (Bool) -> Void) {
        database.child("users/clients").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            
            guard let usersCollection = snapshot.value as? [[String: Any]] else { return }
            print("counting: \(usersCollection.count)")
            var index = -1 //indexOfUsers in the db
            
            for users in usersCollection {
                index += 1
                // print("USER: \(users), count: \(count)")
                for user in users {
                    if user.key == "profileInfo" {
                        guard let value = user.value as? [String: Any] else { return }
                        let email = value["email"] as? String
                        print("USER: \(email ?? "nil"), count: \(index)")
                        let randomString = ["client1-hotmail-com", "client2-hotmail-com", "client3-hotmail-com"]
                        let randomEmail = (randomString.randomElement() ?? "nil")
                        print("randomEmail: " + randomEmail)
                        if email  ==  randomEmail {
                            print("email: \(String(describing: email)), indexOf: \(index)")
                            
                            strongSelf.database.child("users/clients/\(index)/servicePosts").observeSingleEvent(of: .value, with: { snapshot in
                                
                                if var usersCollection = snapshot.value as? [[String: Any]] {
                                    // append to user dictionary
                                    let newElement = [
                                        "postID": postID,
                                    ]
                                    
                                    usersCollection.append(newElement)
                                    strongSelf.database.child("users/clients/\(index)/servicePosts").setValue(usersCollection, withCompletionBlock: { error, _ in
                                        guard error == nil else {
                                            completion(false)
                                            return
                                        }
                                        
                                        completion(true)
                                    })
                                } else {
                                    // create that array
                                    let newCollection: [[String: Any]] = [
                                        [
                                            "postID": postID,
                                        ]
                                    ]
                                    
                                    strongSelf.database.child("users/clients/\(index)/servicePosts").setValue(newCollection, withCompletionBlock: { error, _ in
                                        guard error == nil else {
                                            completion(false)
                                            return
                                        }
                                        
                                        completion(true)
                                    })
                                }
                            })
                           return // Get out of the loop once the right much is found
                        }
                    }
                }
            }
        })
    }
    
    public func insertPost(with post: PostModel, completion: @escaping (Bool) -> Void) {
        let data = try! FirebaseEncoder().encode(post)
        
        database.child("posts").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            
            guard let strongSelf = self else {
                return
            }
            
//            if var _ = snapshot.value as? [[String: Any]] {
//
//                let db = strongSelf.database.child("posts")
//                let dbPostID = db.childByAutoId()
//
//                dbPostID.setValue(data, withCompletionBlock: { error, _ in
//                    guard error == nil else {
//                        completion(false)
//                        return
//                    }
//                    let postID = "\(dbPostID)"
//                    let delimiter = "posts/"
//                    let slicedString = postID.components(separatedBy: delimiter)[1]
//                    DatabaseManager.shared.insertPostToUserDB(with: slicedString, completion: { success in
//                        if success {
//                            print("success")
//                        } else {
//                            print("failed")
//                        }
//                    })
//
////                    strongSelf.database.child("posts/\(slicedString)").observeSingleEvent(of: .value, with: { snapshot in
//                        let newElement = [
//                            "id": slicedString,
//                        ]
//                        let childPath = "posts/\(slicedString)"
//                        strongSelf.database.child(childPath).updateChildValues(newElement, withCompletionBlock: { error, _ in
//                        })
////                    })
//                    completion(true)
//                })
//            } else {
                // create that array
                
                let db = strongSelf.database.child("posts")
                let dbPostID = db.childByAutoId()
                dbPostID.setValue(data, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    let postID = "\(dbPostID)"
                    let delimiter = "posts/"
                    let slicedString = postID.components(separatedBy: delimiter)[1]
                    DatabaseManager.shared.insertPostToUserDB(with: slicedString, completion: { success in
                        if success {
                            print("success")
                        } else {
                            print("failed")
                        }
                    })
                    
                    let updateElement = [
                        "id": slicedString,
//                        "location":
                    ]
                    
                    let childPath = "posts/\(slicedString)"
                    strongSelf.database.child(childPath).updateChildValues(updateElement, withCompletionBlock: { error, _ in
                    })
                    
                    completion(true)
                })
//            }
        })
    }
    
    /// Gets all posts from database
    public func getAllPosts(completion: @escaping (Result<PostModel, Error>) -> Void) {
        database.child("posts").observeSingleEvent(of: .value, with: { snapshot in
            guard let postsCollection = snapshot.value as? [String: Any] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            for (keys, _) in postsCollection {
                Database.database().reference().child("posts/\(keys)").observeSingleEvent(of: .value, with: { snapshot in
                    guard let value = snapshot.value else { return }
                    do {
                        let model = try FirebaseDecoder().decode(PostModel.self, from: value)
                        completion(.success(model))
                    } catch let error {
                        print(error)
                    }
                })
            }
        })
    }
    
    /// Gets all posts from database
    public func getAllClients(completion: @escaping (Result<ClientModel, Error>) -> Void) {
        database.child("users/clients").observeSingleEvent(of: .value, with: { snapshot in
            guard let postsCollection = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            for post in postsCollection {
                do {
                    let model = try FirebaseDecoder().decode(ClientModel.self, from: post)
                    print("email: \(model.profileInfo.email)")
                    completion(.success(model))
                } catch let error {
                    print(error)
                }
            }
        })
    }
    
    public func getUserPosts(completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        database.child("users/clients").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            
            guard let usersCollection = snapshot.value as? [[String: Any]] else { return }
            var index = -1 //indexOfUsers in the db
            
            for users in usersCollection {
                index += 1
                // print("USER: \(users), count: \(count)")
                for user in users {
                    if user.key == "profileInfo" {
                        guard let value = user.value as? [String: Any] else { return }
                        let email = value["email"] as? String
                        
                        if email  == "test1-hotmail-com" {
                            print("email: \(String(describing: email)), indexOf: \(index)")
                            
                            strongSelf.database.child("users/clients\(index)/servicePosts").observeSingleEvent(of: .value, with: { snapshot in

                                guard let value = snapshot.value as? [[String: Any]] else {
                                    completion(.failure(DatabaseError.failedToFetch))
                                    return
                                }
                                completion(.success(value))
                                
                            })
                           return // Get out of the loop once the right much is found
                        }
                    }
                }
            }
        })
    }
    
    
    /// Gets all users from database
    public func getAllUsers(completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
//            print(snapshot.value)
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        })
    }

    public enum DatabaseError: Error {
        case failedToFetch

        public var localizedDescription: String {
            switch self {
            case .failedToFetch:
                return "This means blah failed"
            }
        }
    }

    /*
        users => [
           [
               "name":
               "safe_email":
           ],
           [
               "name":
            "safe_email":
           ]
       ]
        */
}

// MARK: - Sending messages / conversations

extension DatabaseManager {

    /*
        "dfsdfdsfds" {
            "messages": [
                {
                    "id": String,
                    "type": text, photo, video,
                    "content": String,
                    "date": Date(),
                    "sender_email": String,
                    "isRead": true/false,
                }
            ]
        }

           conversaiton => [
              [
                  "conversation_id": "dfsdfdsfds"
                  "other_user_email":
                  "latest_message": => {
                    "date": Date()
                    "latest_message": "message"
                    "is_read": true/false
                  }
              ],
            ]
           */

    /// Creates a new conversation with target user emamil and first message sent
    public func createNewConversation(with otherUserEmail: String, name: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String,
        let currentNamme = UserDefaults.standard.value(forKey: "name") as? String else {
            return
        }
//        let currentNamme = "pjW9o46h98axzoNsQyyohi2J2XN2"
//        print("currentNamme: "+currentNamme)
//        print("currentEmail: "+currentEmail)

        let safeEmail = DatabaseManager.safeEmail(emailAddress: currentEmail)

        let ref = database.child("\(safeEmail)")

        ref.observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard var userNode = snapshot.value as? [String: Any] else {
                completion(false)
                print("user not found")
                return
            }

            let messageDate = firstMessage.sentDate
            let dateString = ChatVC.dateFormatter.string(from: messageDate)

            var message = ""

            switch firstMessage.kind {
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .custom(_):
                break
            case .linkPreview(_):
                break
            }

            let conversationId = "conversation_\(firstMessage.messageId)"

            let newConversationData: [String: Any] = [
                "id": conversationId,
                "other_user_email": otherUserEmail,
                "name": name, //recipientName
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]

            let recipient_newConversationData: [String: Any] = [
                "id": conversationId,
                "other_user_email": safeEmail,
                "name": currentNamme, //recipientName
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            // Update recipient conversaiton entry

            self?.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: { [weak self] snapshot in
                if var convos = snapshot.value as? [[String: Any]] {
                    // append
                    convos.append(recipient_newConversationData)
                    self?.database.child("\(otherUserEmail)/conversations").setValue(convos)
                }
                else {
                    // create
                    self?.database.child("\(otherUserEmail)/conversations").setValue([recipient_newConversationData])
                }
            })

            // Update current user conversation entry
            if var conversations = userNode["conversations"] as? [[String: Any]] {
                // conversation array exists for current user
                // you should append

                conversations.append(newConversationData)
                userNode["conversations"] = conversations
                ref.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(name: name,
                                                     conversationID: conversationId,
                                                     firstMessage: firstMessage,
                                                     completion: completion)
                })
            }
            else {
                // conversation array does NOT exist
                // create it
                userNode["conversations"] = [
                    newConversationData
                ]

                ref.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }

                    self?.finishCreatingConversation(name: name,
                                                     conversationID: conversationId,
                                                     firstMessage: firstMessage,
                                                     completion: completion)
                })
            }
        })
    }

    private func finishCreatingConversation(name: String, conversationID: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
//        {
//            "id": String,
//            "type": text, photo, video,
//            "content": String,
//            "date": Date(),
//            "sender_email": String,
//            "isRead": true/false,
//        }

        let messageDate = firstMessage.sentDate
        let dateString = ChatVC.dateFormatter.string(from: messageDate)

        var message = ""
        switch firstMessage.kind {
        case .text(let messageText):
            message = messageText
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .custom(_):
            break
        case .linkPreview(_):
            break
        }

        guard let myEmmail = UserDefaults.standard.value(forKey: "email") as? String else {
            completion(false)
            return
        }

        let currentUserEmail = DatabaseManager.safeEmail(emailAddress: myEmmail)

        let collectionMessage: [String: Any] = [
            "id": firstMessage.messageId,
            "type": firstMessage.kind.messageKindString,
            "content": message,
            "date": dateString,
            "sender_email": currentUserEmail,
            "is_read": false,
            "name": name //recipientName
        ]

        let value: [String: Any] = [
            "messages": [
                collectionMessage
            ]
        ]

        print("adding convo: \(conversationID)")

        database.child("\(conversationID)").setValue(value, withCompletionBlock: { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }

    /// Fetches and returns all conversations for the user with passed in email
    public func getAllConversations(for email: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        database.child("\(email)/conversations").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }

            let conversations: [Conversation] = value.compactMap({ dictionary in
                guard let conversationId = dictionary["id"] as? String,
                    let name = dictionary["name"] as? String,
                    let otherUserEmail = dictionary["other_user_email"] as? String,
                    let latestMessage = dictionary["latest_message"] as? [String: Any],
                    let date = latestMessage["date"] as? String,
                    let message = latestMessage["message"] as? String,
                    let isRead = latestMessage["is_read"] as? Bool else {
                        return nil
                }

                let latestMmessageObject = LatestMessage(date: date,
                                                         message: message,
                                                         isRead: isRead)
                return Conversation(id: conversationId,
                                    name: name,
                                    otherUserEmail: otherUserEmail,
                                    latestMessage: latestMmessageObject)
            })

            completion(.success(conversations))
        })
    }

    /// Gets all mmessages for a given conversatino
    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        database.child("\(id)/messages").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }

            let messages: [Message] = value.compactMap({ dictionary in
                guard let name = dictionary["name"] as? String,
                    let isRead = dictionary["is_read"] as? Bool,
                    let messageID = dictionary["id"] as? String,
                    let content = dictionary["content"] as? String,
                    let senderEmail = dictionary["sender_email"] as? String,
                    let type = dictionary["type"] as? String,
                    let dateString = dictionary["date"] as? String,
                    let date = ChatVC.dateFormatter.date(from: dateString) else {
                        return nil
                }
                var kind: MessageKind?
                if type == "photo" {
                    // photo
                    guard let imageUrl = URL(string: content),
                    let placeHolder = UIImage(systemName: "plus") else {
                        return nil
                    }
                    let media = Media(url: imageUrl,
                                      image: nil,
                                      placeholderImage: placeHolder,
                                      size: CGSize(width: 300, height: 300))
                    kind = .photo(media)
                }
                else if type == "video" {
                    // photo
                    guard let videoUrl = URL(string: content),
                        let placeHolder = UIImage(named: "video_placeholder") else {
                            return nil
                    }
                    
                    let media = Media(url: videoUrl,
                                      image: nil,
                                      placeholderImage: placeHolder,
                                      size: CGSize(width: 300, height: 300))
                    kind = .video(media)
                }
                else if type == "location" {
                    let locationComponents = content.components(separatedBy: ",")
                    guard let longitude = Double(locationComponents[0]),
                        let latitude = Double(locationComponents[1]) else {
                        return nil
                    }
                    print("Rendering location; long = \(longitude) | lat = \(latitude)")
                    let location = Location(location: CLLocation(latitude: latitude, longitude: longitude),
                                            size: CGSize(width: 300, height: 300))
                    kind = .location(location)
                }
                else {
                    kind = .text(content)
                }

                guard let finalKind = kind else {
                    return nil
                }

                let sender = Sender(photoURL: "",
                                    senderId: senderEmail,
                                    displayName: name)

                return Message(sender: sender,
                               messageId: messageID,
                               sentDate: date,
                               sender_email: senderEmail,
                               kind: finalKind,
                               content: content)
            })

            completion(.success(messages))
        })
    }

    /// Sends a message with target conversation and message
    public func sendMessage(to conversation: String, otherUserEmail: String, name: String, newMessage: Message, completion: @escaping (Bool) -> Void) {
        // add new message to messages
        // update sender latest message
        // update recipient latest message

        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            completion(false)
            return
        }

        let currentEmail = DatabaseManager.safeEmail(emailAddress: myEmail)

        database.child("\(conversation)/messages").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }

            guard var currentMessages = snapshot.value as? [[String: Any]] else {
                completion(false)
                return
            }

            let messageDate = newMessage.sentDate
            let dateString = ChatVC.dateFormatter.string(from: messageDate)

            var message = ""
            switch newMessage.kind {
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(let mediaItem):
                if let targetUrlString = mediaItem.url?.absoluteString {
                    message = targetUrlString
                }
                break
            case .video(let mediaItem):
                if let targetUrlString = mediaItem.url?.absoluteString {
                    message = targetUrlString
                }
                break
            case .location(let locationData):
                let location = locationData.location
                message = "\(location.coordinate.longitude),\(location.coordinate.latitude)"
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .custom(_):
                break
            case .linkPreview(_):
                break
            }

            guard let myEmmail = UserDefaults.standard.value(forKey: "email") as? String else {
                completion(false)
                return
            }

            let currentUserEmail = DatabaseManager.safeEmail(emailAddress: myEmmail)

            let newMessageEntry: [String: Any] = [
                "id": newMessage.messageId,
                "type": newMessage.kind.messageKindString,
                "content": message,
                "date": dateString,
                "sender_email": currentUserEmail,
                "is_read": false,
                "name": name //recipientName
            ]

            currentMessages.append(newMessageEntry)

            strongSelf.database.child("\(conversation)/messages").setValue(currentMessages) { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }

                strongSelf.database.child("\(currentEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
                    var databaseEntryConversations = [[String: Any]]()
                    let updatedValue: [String: Any] = [
                        "date": dateString,
                        "is_read": false,
                        "message": message
                    ]

                    if var currentUserConversations = snapshot.value as? [[String: Any]] {
                        var targetConversation: [String: Any]?
                        var position = 0

                        for conversationDictionary in currentUserConversations {
                            if let currentId = conversationDictionary["id"] as? String, currentId == conversation {
                                targetConversation = conversationDictionary
                                break
                            }
                            position += 1
                        }

                        if var targetConversation = targetConversation {
                            targetConversation["latest_message"] = updatedValue
                            currentUserConversations[position] = targetConversation
                            databaseEntryConversations = currentUserConversations
                        }
                        else {
                            let newConversationData: [String: Any] = [
                                "id": conversation,
                                "other_user_email": DatabaseManager.safeEmail(emailAddress: otherUserEmail),
                                "name": name, //recipientName
                                "latest_message": updatedValue
                            ]
                            currentUserConversations.append(newConversationData)
                            databaseEntryConversations = currentUserConversations
                        }
                    }
                    else {
                        let newConversationData: [String: Any] = [
                            "id": conversation,
                            "other_user_email": DatabaseManager.safeEmail(emailAddress: otherUserEmail),
                            "name": name,//recipientName
                            "latest_message": updatedValue
                        ]
                        databaseEntryConversations = [
                            newConversationData
                        ]
                    }

                    strongSelf.database.child("\(currentEmail)/conversations").setValue(databaseEntryConversations, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }


                        // Update latest message for recipient user

                        strongSelf.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
                            let updatedValue: [String: Any] = [
                                "date": dateString,
                                "is_read": false,
                                "message": message
                            ]
                            var databaseEntryConversations = [[String: Any]]()

                            guard let currentName = UserDefaults.standard.value(forKey: "name") as? String else {
                                return
                            }

                            if var otherUserConversations = snapshot.value as? [[String: Any]] {
                                var targetConversation: [String: Any]?
                                var position = 0

                                for conversationDictionary in otherUserConversations {
                                    if let currentId = conversationDictionary["id"] as? String, currentId == conversation {
                                        targetConversation = conversationDictionary
                                        break
                                    }
                                    position += 1
                                }

                                if var targetConversation = targetConversation {
                                    targetConversation["latest_message"] = updatedValue
                                    otherUserConversations[position] = targetConversation
                                    databaseEntryConversations = otherUserConversations
                                }
                                else {
                                    // failed to find in current colleciton
                                    let newConversationData: [String: Any] = [
                                        "id": conversation,
                                        "other_user_email": DatabaseManager.safeEmail(emailAddress: currentEmail),
                                        "name": currentName, //recipientName
                                        "latest_message": updatedValue
                                    ]
                                    otherUserConversations.append(newConversationData)
                                    databaseEntryConversations = otherUserConversations
                                }
                            }
                            else {
                                // current collection does not exist
                                let newConversationData: [String: Any] = [
                                    "id": conversation,
                                    "other_user_email": DatabaseManager.safeEmail(emailAddress: currentEmail),
                                    "name": currentName, //recipientName
                                    "latest_message": updatedValue
                                ]
                                databaseEntryConversations = [
                                    newConversationData
                                ]
                            }

                            strongSelf.database.child("\(otherUserEmail)/conversations").setValue(databaseEntryConversations, withCompletionBlock: { error, _ in
                                guard error == nil else {
                                    completion(false)
                                    return
                                }

                                completion(true)
                            })
                        })
                    })
                })
            }
        })
    }

    public func deleteConversation(conversationId: String, completion: @escaping (Bool) -> Void) {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)

        print("Deleting conversation with id: \(conversationId)")

        // Get all conversations for current user
        // delete conversation in collection with target id
        // reset those conversations for the user in database
        let ref = database.child("\(safeEmail)/conversations")
        ref.observeSingleEvent(of: .value) { snapshot in
            if var conversations = snapshot.value as? [[String: Any]] {
                var positionToRemove = 0
                for conversation in conversations {
                    if let id = conversation["id"] as? String,
                        id == conversationId {
                        print("found conversation to delete")
                        break
                    }
                    positionToRemove += 1
                }

                conversations.remove(at: positionToRemove)
                ref.setValue(conversations, withCompletionBlock: { error, _  in
                    guard error == nil else {
                        completion(false)
                        print("faield to write new conversatino array")
                        return
                    }
                    print("deleted conversaiton")
                    completion(true)
                })
            }
        }
    }

    public func conversationExists(with targetRecipientEmail: String, completion: @escaping (Result<String, Error>) -> Void) {
        let safeRecipientEmail = DatabaseManager.safeEmail(emailAddress: targetRecipientEmail)
        guard let senderEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeSenderEmail = DatabaseManager.safeEmail(emailAddress: senderEmail)

        database.child("\(safeRecipientEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
            guard let collection = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }

            // iterate and find conversation with target sender
            if let conversation = collection.first(where: {
                guard let targetSenderEmail = $0["other_user_email"] as? String else {
                    return false
                }
                return safeSenderEmail == targetSenderEmail
            }) {
                // get id
                guard let id = conversation["id"] as? String else {
                    completion(.failure(DatabaseError.failedToFetch))
                    return
                }
                completion(.success(id))
                return
            }

            completion(.failure(DatabaseError.failedToFetch))
            return
        })
    }

}

// MARK: - User Insertion
struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String

    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }

    var profilePictureFileName: String {
        //afraz9-gmail-com_profile_picture.png
        return "\(safeEmail)_profile_picture.png"
    }
}

struct TechnicianUserModel {
//    let id: String
    let firstName: String
    let middleName: String
    let lastName: String
    let emailAddress: String
    let location: String
    let profileSummary: String
    let experience: String //Int
    let skills: [String]
    let accountType: String
    let hourlyRate: Float

    let numberOfCompletedServices: Int
    let numberOfActiveServices: Int
    let numberOfPreviousServices: Int
    let technieRank: Int
    
//    clientsSatisfaction[],
//    notifications[],
//    chats[]
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }

    var profilePictureFileName: String {
        //afraz9-gmail-com_profile_picture.png
        return "\(safeEmail)_profile_picture.png"
    }
}

struct ClientUserModel: Codable {
//    let id: String
    let firstName: String
    let middleName: String
    let lastName: String
    let emailAddress: String
    let location: String
    let numberOfPosts: Int
    let numberOfActivePosts: Int
    let numberOfInactivePosts: Int
    
//    posts[],
//    notifications[],
//    chats[]
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }

    var profilePictureFileName: String {
        return "\(safeEmail)_profile_picture.png"
    }
}

struct ClientModel: Codable {
   
    let numberOfActivePosts: Int
    let numberOfInactivePosts: Int
    let numberOfPosts: Int
    let profileInfo: ProfileInfo
    let servicePosts: [ServicePosts]?
}

struct ProfileInfo: Codable {
    let email: String
    let location: String
    let name: String
}

struct ServicePosts: Codable {
    let postID: String
}


struct PostModel: Codable {
    let id: String?
    let title: String
    let description: String
    let attachments: [String]
    let projectType: String
    let budget: String
    let location: String?
    let requiredSkills: [String]

    let availabilityStatus: Bool
    let numberOfProposals: Int
    let numberOfInvitesSent: Int
    let numberOfUnansweredInvites: Int
    let dateTime: String
    let field: String?
    let hiringStatus: HiringStatus?
    let proposals: [Proposals]?

}

struct HiringStatus: Codable {
    var isHired: Bool
    var hiredTechnicianEmail: String
}

struct Proposals: Codable {
    var technicianEmail: String
    var coverLetter: String
}
