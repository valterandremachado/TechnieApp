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
    
    public func insertPostToUserDB2(with postID: String, completion: @escaping (Bool) -> Void) {
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
    
    // MARK: - -----

    
    // MARK: - Setters
    public func insertClient(with clientUser: ClientModel, with UID: String, firstName: String, lastName: String, completion: @escaping (Bool) -> Void) {
        let data = try! FirebaseEncoder().encode(clientUser)
        
        var safeEmail: String {
            var safeEmail = clientUser.profileInfo.email.replacingOccurrences(of: ".", with: "-")
            safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
            return safeEmail
        }
        
        database.child(safeEmail).setValue([
            "first_name": firstName,
            "last_name": lastName
        ], withCompletionBlock: { [weak self] error, _ in
            guard let strongSelf = self else {
                return
            }
            
            let db = strongSelf.database.child("users/clients")
            let dbPostID = db.child(UID)
            dbPostID.setValue(data, withCompletionBlock: { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                
                completion(true)
            })
        })
    }
   
    public func insertTechnician(with technicainUser: TechnicianModel, with UID: String, firstName: String, lastName: String, completion: @escaping (Bool) -> Void) {
        let data = try! FirebaseEncoder().encode(technicainUser)
        
        var safeEmail: String {
            var safeEmail = technicainUser.profileInfo.email.replacingOccurrences(of: ".", with: "-")
            safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
            return safeEmail
        }
        
        database.child(safeEmail).setValue([
            "first_name": firstName,
            "last_name": lastName
        ], withCompletionBlock: { [weak self] error, _ in
            guard let strongSelf = self else {
                return
            }
            
            let db = strongSelf.database.child("users/technicians")
            let dbPostID = db.child(UID)
            dbPostID.setValue(data, withCompletionBlock: { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                
                completion(true)
            })
        })
    }
    
    public func insertTechnicianNotification(with technicianNotificationModel: TechnicianNotificationModel, with technicianEmail: String, completion: @escaping (Bool) -> Void) {
        let data = try! FirebaseEncoder().encode(technicianNotificationModel)
        
        database.child("users/technicians").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else { return }
            guard let techniciansCollection = snapshot.value as? [String: Any] else {
                return
            }
            
            for (key, _) in techniciansCollection {
                strongSelf.database.child("users/technicians/\(key)").observeSingleEvent(of: .value, with: { snapshot in
                    guard let value = snapshot.value else { return }
                    do {
                        
                        let model = try FirebaseDecoder().decode(TechnicianModel.self, from: value)
                        let email = model.profileInfo.email
                        
                        if email == technicianEmail {
                            let db = strongSelf.database.child("users/technicians/\(key)/notifications")
                            let dbPostID = db.childByAutoId()
                            let postID = "\(dbPostID)"
                            let delimiter = "notifications/"
                            let slicedString = postID.components(separatedBy: delimiter)[1]
                            dbPostID.setValue(data, withCompletionBlock: { error, _ in
                                guard error == nil else {
                                    return
                                }
                                
                                let updateElement = [
                                    "id": slicedString,
                                ]
                                let childPath = "users/technicians/\(key)/notifications/\(slicedString)"
                                strongSelf.database.child(childPath).updateChildValues(updateElement, withCompletionBlock: { error, _ in
                                })
                            })
                            
                        }
                    } catch let error {
                        print(error)
                    }
                })
            }
        })
        
    }
    
    public func insertClientNotification(with clientNotificationModel: ClientNotificationModel, with clientKeyPath: String, completion: @escaping (Bool) -> Void) {
        let data = try! FirebaseEncoder().encode(clientNotificationModel)
        
//        database.child("users/client").observeSingleEvent(of: .value, with: { [weak self] snapshot in
//            guard let strongSelf = self else { return }
//            guard let techniciansCollection = snapshot.value as? [String: Any] else {
//                return
//            }
            
//            for (key, _) in techniciansCollection {
//                strongSelf.database.child("users/clients/\(clientKeyPath)").observeSingleEvent(of: .value, with: { snapshot in
//                    guard let value = snapshot.value else { return }
//                    do {
//
//                        let model = try FirebaseDecoder().decode(TechnicianModel.self, from: value)
//                        let email = model.profileInfo.email
                        
//                        if email == technicianEmail {
        let mainChildPath = "users/clients/\(clientKeyPath)/notifications"
        let db = database.child(mainChildPath)
        let dbPostID = db.childByAutoId()
        let postID = "\(dbPostID)"
        let delimiter = "notifications/"
        let slicedString = postID.components(separatedBy: delimiter)[1]
        dbPostID.setValue(data, withCompletionBlock: { [self] error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            
            let updateElement = [
                "id": slicedString,
            ]
            let childPath = "\(mainChildPath)/\(slicedString)"
            database.child(childPath).updateChildValues(updateElement, withCompletionBlock: { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            })
        })
                            
//                        }
//                    } catch let error {
//                        print(error)
//                    }
//                })
//            }
//        })
        
    }
    
    public func insertHiredJobs(withModel hiredJobsModel: HiredJobs, withKeyPath technicianKeyPath: String, withEmail technicianEmail: String, technicianNotificationKeyPath: String, technicianName: String, clientKeyPath: String, postChildPath: String, completion: @escaping (Bool) -> Void) {
        let data = try! FirebaseEncoder().encode(hiredJobsModel)
        
        do {
            
            let db = self.database.child("users/technicians/\(technicianKeyPath)/hiredJobs")
            let dbPostID = db.childByAutoId()
            let postID = "\(dbPostID)"
            let delimiter = "hiredJobs/"
            let slicedString = postID.components(separatedBy: delimiter)[1]
            dbPostID.setValue(data, withCompletionBlock: { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
                let updateElement = [
                    "id": slicedString,
                ]
                let childPath = "users/technicians/\(technicianKeyPath)/hiredJobs/\(slicedString)"
                self.database.child(childPath).updateChildValues(updateElement, withCompletionBlock: { error, _ in
                })
                
                let updateElement2 = [
                    "isHiringAccepted": true,
                    "description": "Don’t let your new client awaiting, start a conversation with the job owner now."
                ] as [String : Any]
                
                self.database.child("users/technicians/\(technicianKeyPath)/notifications/\(technicianNotificationKeyPath)").updateChildValues(updateElement2, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        return
                    }
                    let technieInfo = TechnicianInfo(name: technicianName,
                                                     email: technicianEmail,
                                                     keyPath: technicianKeyPath)
                    let clientNotificationModel = ClientNotificationModel(id: "nil",
                                                                          type: ClientNotificationType.hiringOfferStatus.rawValue,
                                                                          title: ClientNotificationType.hiringOfferStatus.rawValue,
                                                                          description: "\(technicianName) has accepted your hiring offer, you can now be directly in touch with each other.",
                                                                          dateTime: PostFormVC.dateFormatter.string(from: Date()),
                                                                          wasAccepted: true,
                                                                          technicianInfo: technieInfo)
                    self.insertClientNotification(with: clientNotificationModel, with: clientKeyPath, completion: { _ in })
                    
                    let upadateElement = [
                        "availabilityStatus": false,
                        "hiringStatus": [
                            "isHired": true,
                            "technicianToHireEmail": technicianEmail,
                            "date": PostFormVC.dateFormatter.string(from: Date())
                        ]
                    ] as [String : Any]

                    self.database.child("\(postChildPath)").updateChildValues(upadateElement, withCompletionBlock: { error, _ in
                        if error != nil {
                            print("error on hiring: \(error?.localizedDescription ?? "nil")")
                            return
                        }
                    })
                    
                })
                
            })
            
        } catch let error {
            print(error)
        }
        
    }
    
    public func insertPostToUserDB(with postID: String, completion: @escaping (Bool) -> Void) {
        database.child("users/clients").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else { return }
            
            guard let postsCollection = snapshot.value as? [String: Any] else {
                completion(false)
                return
            }
            
            let uidKeys = ["PNayVUR9AyTwQqqHn0T9oanJwd72", "RNVQZwqbXIcakB1LJjUwNEO1BG22", "SEQ0IMTLF4YZMXtjwR7AkiuypSg1", "nSOieQCUcWQZQlTMRk6LKYGYyO02"]
            let randoUIDkey = uidKeys.randomElement() ?? "nil"
            
            for (key, _) in postsCollection {
                print("randomKey: \(randoUIDkey), key: \(key)")
                if key == "SEQ0IMTLF4YZMXtjwR7AkiuypSg1" {
                    print("InsideRandomKey: \(randoUIDkey), insideKey: \(key)")
                    
                    strongSelf.database.child("users/clients/\(key)/servicePosts").observeSingleEvent(of: .value, with: { snapshot in
                        
                        if var usersCollection = snapshot.value as? [[String: Any]] {
                            // append to user dictionary
                            let newElement = [
                                "postID": postID,
                            ]
                            
                            usersCollection.append(newElement)
                            strongSelf.database.child("users/clients/\(key)/servicePosts").setValue(usersCollection, withCompletionBlock: { error, _ in
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
                            
                            strongSelf.database.child("users/clients/\(key)/servicePosts").setValue(newCollection, withCompletionBlock: { error, _ in
                                guard error == nil else {
                                    completion(false)
                                    return
                                }
                                
                                completion(true)
                            })
                        }
                    })
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
                ]
                
                let childPath = "posts/\(slicedString)"
                strongSelf.database.child(childPath).updateChildValues(updateElement, withCompletionBlock: { error, _ in
                })
                
                completion(true)
            })
        })
    }
    
    /// Deletion
    public func deleteChildPath(withChildPath: String, completion: @escaping (Bool) -> Void) {
        database.child(withChildPath).removeValue { (error, _) in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    public func deleteNotification(withTechnieChildPath: String, withPostChildPath: String, clientKeyPath: String, technicianName: String, completion: @escaping (Bool) -> Void) {
        database.child(withTechnieChildPath).removeValue { [self] (error, _) in
            guard error == nil else {
                completion(false)
                return
            }
//            completion(true)
            database.child(withPostChildPath).removeValue { (error, _) in
                guard error == nil else {
                    completion(false)
                    return
                }
                
                let clientNotificationModel = ClientNotificationModel(id: "nil",
                                                                      type: ClientNotificationType.hiringOfferStatus.rawValue,
                                                                      title: ClientNotificationType.hiringOfferStatus.rawValue,
                                                                      description: "The technician '\(technicianName)' you tried to hire has rejected your hiring offer, we’re sorry please try hiring someone nearby your place.",
                                                                      dateTime: PostFormVC.dateFormatter.string(from: Date()))
                self.insertClientNotification(with: clientNotificationModel, with: clientKeyPath, completion: { success in
                    if success {
                        completion(true)
                    }
                })
            }
        }
    }
    
    
    // MARK: - Getters
    public func getAllTechnicianNotifications(completion: @escaping (Result<[TechnicianNotificationModel], Error>) -> Void) {
      
        guard let getUsersPersistedInfo = UserDefaults.standard.object([UserPersistedInfo].self, with: "persistUsersInfo") else { return }
        var notifications = [TechnicianNotificationModel]()
        
        for id in getUsersPersistedInfo {
            let uid = id.uid
            print("UID: "+uid)
            self.database.child("users/technicians/\(uid)/notifications").observeSingleEvent(of: .value, with: { snapshot in
                guard let notificationsCollection = snapshot.value as? [String: Any] else { return }
                for (keyPath, _) in notificationsCollection {
                    self.database.child("users/technicians/\(uid)/notifications/\(keyPath)").observeSingleEvent(of: .value, with: { snapshot in
                        guard let value = snapshot.value else { return }
                        do {
                            let model = try FirebaseDecoder().decode(TechnicianNotificationModel.self, from: value)
                            notifications.append(model)
                            completion(.success(notifications))
                        } catch let error {
                            print(error)
                        }
                    })
                }
                
            })
        }
    }
    
    public func getAllClientNotifications(completion: @escaping (Result<[ClientNotificationModel], Error>) -> Void) {
      
        guard let getUsersPersistedInfo = UserDefaults.standard.object([UserPersistedInfo].self, with: "persistUsersInfo") else { return }
        var notifications = [ClientNotificationModel]()
        
        for id in getUsersPersistedInfo {
            let uid = id.uid
            self.database.child("users/clients/\(uid)/notifications").observeSingleEvent(of: .value, with: { snapshot in
                guard let notificationsCollection = snapshot.value as? [String: Any] else { return }
                for (keyPath, _) in notificationsCollection {
                    self.database.child("users/clients/\(uid)/notifications/\(keyPath)").observeSingleEvent(of: .value, with: { snapshot in
                        guard let value = snapshot.value else { return }
                        do {
                            let model = try FirebaseDecoder().decode(ClientNotificationModel.self, from: value)
                            notifications.append(model)
                            completion(.success(notifications))
                        } catch let error {
                            print(error)
                        }
                    })
                }
                
            })
        }
    }
    
    /// Gets all posts from database
    public func getAllPosts(completion: @escaping (Result<[PostModel], Error>) -> Void) {
        database.child("posts").observeSingleEvent(of: .value, with: { snapshot in
            guard let postsCollection = snapshot.value as? [String: Any] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            var posts = [PostModel]()

            for (key, _) in postsCollection {
                Database.database().reference().child("posts/\(key)").observeSingleEvent(of: .value, with: { snapshot in
                    guard let value = snapshot.value else { return }
                    do {
                        let model = try FirebaseDecoder().decode(PostModel.self, from: value)
                        if model.availabilityStatus != false {
                            posts.append(model)

//                            print("sortedArray: \(sortedArray)")
//                            print("NOTsortedArray: \(posts)")
                            completion(.success(posts))
                        }
                       
                    } catch let error {
                        print(error)
                    }
                })
            }
        })
    }
    
    /// Gets all clients from database
    public func getAllClients(completion: @escaping (Result<ClientModel, Error>) -> Void) {
        database.child("users/clients").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let self = self else { return }
            guard let usersCollection = snapshot.value as? [String: Any] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }

            for (key, _) in usersCollection {
                self.database.child("users/clients/\(key)").observeSingleEvent(of: .value, with: { snapshot in
                    guard let value = snapshot.value else { return }
                    do {
                        let model = try FirebaseDecoder().decode(ClientModel.self, from: value)
                        print("email: \(model.profileInfo.email)")
                        completion(.success(model))
                    } catch let error {
                        print(error)
                    }
                })
            }
        })
    }
    
    /// Gets all technician from database
    public func getAllTechnicians(completion: @escaping (Result<TechnicianModel, Error>) -> Void) {
        database.child("users/technicians").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let self = self else { return }
            guard let techniciansCollection = snapshot.value as? [String: Any] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            for (key, _) in techniciansCollection {
                self.database.child("users/technicians/\(key)").observeSingleEvent(of: .value, with: { snapshot in
                    guard let value = snapshot.value else { return }
                    do {
                        let model = try FirebaseDecoder().decode(TechnicianModel.self, from: value)
//                        print("email: \(model)")
                        completion(.success(model))
                    } catch let error {
                        print(error)
                    }
                })
            }
        })
    }
    
    public func getAllClientPosts(completion: @escaping (Result<[PostModel], Error>) -> Void) {
        
        let getUsersPersistedInfo = UserDefaults.standard.object([UserPersistedInfo].self, with: "persistUsersInfo")
        
        var userPersistedEmail = ""
        if let info = getUsersPersistedInfo {
            userPersistedEmail = info.first!.email
        }
        
        database.child("posts").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let self = self else { return }
            
            guard let postsCollection = snapshot.value as? [String: Any] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            var posts = [PostModel]()
            var userPostIDs = [String]()
            
            for (key, _) in postsCollection {
                self.database.child("posts/\(key)").observeSingleEvent(of: .value, with: { snapshot in
                    guard let value = snapshot.value else { return }
                    do {
                        let postModel = try FirebaseDecoder().decode(PostModel.self, from: value)
                        
                        self.database.child("users/clients").observeSingleEvent(of: .value, with: { snapshot in
                            guard let postsCollection = snapshot.value as? [String: Any] else {
                                completion(.failure(DatabaseError.failedToFetch))
                                return
                            }
                            
                            
                            for (key, _) in postsCollection {
                                self.database.child("users/clients/\(key)").observeSingleEvent(of: .value, with: { snapshot in
                                    guard let value = snapshot.value else { return }
                                    do {
                                        let userModel = try FirebaseDecoder().decode(ClientModel.self, from: value)
                                        let email = userModel.profileInfo.email
                                        
//                                        print("email: \(email)")
                                        if userPersistedEmail == email {
//                                            print("Equal email: \(email)")
                                            userModel.servicePosts?.forEach({ (post) in
                                                if userPostIDs.count != userModel.servicePosts?.count {
                                                    userPostIDs.append(post.postID)
//                                                    print("userPostIDs: \(userPostIDs)")
                                                }
                                                
                                            })
                                            
                                            if  userPostIDs.count == userModel.servicePosts?.count {
                                                for ids in userPostIDs {
                                                    if postModel.id == ids {
                                                        posts.append(postModel)
//                                                        print("posts: \(posts), count: \(posts.count)")
                                                        completion(.success(posts))
                                                    }
                                                }
                                            }
//                                            guard let postID = userModel.servicePosts?.first?.postID else { return }
                                            
                                            
                                        }
                                        
                                    } catch let error {
                                        print(error)
                                    }
                                })
                            }
                        })
                        
                        
                        
                    } catch let error {
                        print(error)
                    }
                })
            }
        })
    }
    
    public func getAllSpecificTechnician(techniciankeyPath: String, completion: @escaping (Result<[String], Error>) -> Void) {
                var jobs = [String]()
            
//            for (key, _) in techniciansCollection {
                self.database.child("users/technicians/\(techniciankeyPath)/hiredJobs").observeSingleEvent(of: .value, with: { snapshot in
                    guard let hiredJobs = snapshot.value as? [String: Any] else { return }
                    for (_ , value) in hiredJobs {
                    do {
                        let model = try FirebaseDecoder().decode(HiredJobs.self, from: value)
                       
                        let delimiter = "/"
                        let slicedString = model.postChildPath.components(separatedBy: delimiter)[1]
                        jobs.append(slicedString)
//                        print("model: \(jobs)")
                        completion(.success(jobs))
                    } catch let error {
                        print(error)
                    }
                    }
                })
//            }
//        })
    }
    
    public func getAllHiredJobs(technicianHiredJobKeyPaths: [String], completion: @escaping (Result<[PostModel], Error>) -> Void) {
        database.child("posts").observeSingleEvent(of: .value, with: { snapshot in
            guard let postsCollection = snapshot.value as? [String: Any] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            var posts = [PostModel]()
            
            for (key, _) in postsCollection {
                technicianHiredJobKeyPaths.forEach { technieKey in
                    if key == technieKey {
                        Database.database().reference().child("posts/\(key)").observeSingleEvent(of: .value, with: { snapshot in
                            guard let value = snapshot.value else { return }
                            do {
                                let model = try FirebaseDecoder().decode(PostModel.self, from: value)
                                if posts.count < technicianHiredJobKeyPaths.count {
                                    posts.append(model)
                                    completion(.success(posts))
                                }
                                
                            } catch let error {
                                print(error)
                            }
                        })
                    }
                }
            }
        })
    }
    
    public func getAllActiveHiredJobs(technicianHiredJobKeyPaths: [String], completion: @escaping (Result<[PostModel], Error>) -> Void) {
        database.child("posts").observeSingleEvent(of: .value, with: { snapshot in
            guard let postsCollection = snapshot.value as? [String: Any] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            var posts = [PostModel]()
            
            for (key, _) in postsCollection {
                technicianHiredJobKeyPaths.forEach { technieKey in
                    if key == technieKey {
                        Database.database().reference().child("posts/\(key)").observeSingleEvent(of: .value, with: { snapshot in
                            guard let value = snapshot.value else { return }
                            do {
                                let model = try FirebaseDecoder().decode(PostModel.self, from: value)
                                if posts.count < technicianHiredJobKeyPaths.count {
                                    posts.append(model)
                                    completion(.success(posts))
                                }
                                
                            } catch let error {
                                print(error)
                            }
                        })
                    }
                }
            }
        })
    }
    
    // MARK: - Listeners
    public func listenToPostChanges(completion: @escaping (Result<[PostModel], Error>) -> Void) {
        Database.database().reference().child("posts").observeSingleEvent(of: .childChanged, with: { [self] snapshot in
            guard let postsCollection = snapshot.value as? [String: Any] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
//            print("postsCollection: \(postsCollection)")
            var updatedPosts = [PostModel]()
            
            database.child("posts").observeSingleEvent(of: .value, with: { snapshot in
                guard let postsCollection = snapshot.value as? [String: Any] else {
                    completion(.failure(DatabaseError.failedToFetch))
                    return
                }
                
                for (key, _) in postsCollection {
                    Database.database().reference().child("posts/\(key)").observeSingleEvent(of: .value, with: { snapshot in
                        guard let value = snapshot.value else { return }
                        do {
                            let model = try FirebaseDecoder().decode(PostModel.self, from: value)
//                            print("model: \(model)")
                            updatedPosts.append(model)
                            completion(.success(updatedPosts))
                        } catch let error {
                            print(error)
                        }
                    })
                }
            })
        })
    }
    
    public func listenToClientPostChanges(completion: @escaping (Result<[PostModel], Error>) -> Void) {
        let getUsersPersistedInfo = UserDefaults.standard.object([UserPersistedInfo].self, with: "persistUsersInfo")
        
        var userPersistedEmail = ""
        if let info = getUsersPersistedInfo {
            userPersistedEmail = info.first!.email
        }
        
        Database.database().reference().child("posts").observeSingleEvent(of: .childChanged, with: { [self] snapshot in
            guard let postsCollection = snapshot.value as? [String: Any] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            database.child("posts").observeSingleEvent(of: .value, with: { [weak self] snapshot in
                guard let self = self else { return }
                
                guard let postsCollection = snapshot.value as? [String: Any] else {
                    completion(.failure(DatabaseError.failedToFetch))
                    return
                }
                
                var posts = [PostModel]()
                var userPostIDs = [String]()
                
                for (key, _) in postsCollection {
                    self.database.child("posts/\(key)").observeSingleEvent(of: .value, with: { snapshot in
                        guard let value = snapshot.value else { return }
                        do {
                            let postModel = try FirebaseDecoder().decode(PostModel.self, from: value)
                            
                            self.database.child("users/clients").observeSingleEvent(of: .value, with: { snapshot in
                                guard let postsCollection = snapshot.value as? [String: Any] else {
                                    completion(.failure(DatabaseError.failedToFetch))
                                    return
                                }
                                
                                
                                for (key, _) in postsCollection {
                                    self.database.child("users/clients/\(key)").observeSingleEvent(of: .value, with: { snapshot in
                                        guard let value = snapshot.value else { return }
                                        do {
                                            let userModel = try FirebaseDecoder().decode(ClientModel.self, from: value)
                                            let email = userModel.profileInfo.email
                                            
                                            //                                        print("email: \(email)")
                                            if userPersistedEmail == email {
                                                //                                            print("Equal email: \(email)")
                                                userModel.servicePosts?.forEach({ (post) in
                                                    if userPostIDs.count != userModel.servicePosts?.count {
                                                        userPostIDs.append(post.postID)
                                                        //                                                    print("userPostIDs: \(userPostIDs)")
                                                    }
                                                    
                                                })
                                                
                                                if  userPostIDs.count == userModel.servicePosts?.count {
                                                    for ids in userPostIDs {
                                                        if postModel.id == ids {
                                                            posts.append(postModel)
                                                            //                                                        print("posts: \(posts), count: \(posts.count)")
                                                            completion(.success(posts))
                                                        }
                                                    }
                                                }
                                                //                                            guard let postID = userModel.servicePosts?.first?.postID else { return }
                                                
                                                
                                            }
                                            
                                        } catch let error {
                                            print(error)
                                        }
                                    })
                                }
                            })
                            
                            
                            
                        } catch let error {
                            print(error)
                        }
                    })
                }
            })
        })
    }
    
    public func listenToTechnicianNotificationChanges(completion: @escaping (Result<[TechnicianNotificationModel], Error>) -> Void) {
        
        guard let getUsersPersistedInfo = UserDefaults.standard.object([UserPersistedInfo].self, with: "persistUsersInfo") else { return }
        var notifications = [TechnicianNotificationModel]()
        
        for id in getUsersPersistedInfo {
            let uid = id.uid
            Database.database().reference().child("users/technicians/\(uid)/notifications").observeSingleEvent(of: .childChanged, with: { [self] snapshot in
                guard let _ = snapshot.value as? [String: Any] else {
                    completion(.failure(DatabaseError.failedToFetch))
                    return
                }
                
                self.database.child("users/technicians/\(uid)/notifications").observeSingleEvent(of: .value, with: { snapshot in
                    guard let notificationsCollection = snapshot.value as? [String: Any] else { return }
                    for (keyPath, _) in notificationsCollection {
                        self.database.child("users/technicians/\(uid)/notifications/\(keyPath)").observeSingleEvent(of: .value, with: { snapshot in
                            guard let value = snapshot.value else { return }
                            do {
                                let model = try FirebaseDecoder().decode(TechnicianNotificationModel.self, from: value)
                                notifications.append(model)
//                                print("Notifications: \(notifications)")
                                completion(.success(notifications))
                            } catch let error {
                                print(error)
                            }
                        })
                    }
                    
                })
            })
        }
    }
    
    public func listenToClientNotificationChanges(completion: @escaping (Result<[ClientNotificationModel], Error>) -> Void) {
        
        guard let getUsersPersistedInfo = UserDefaults.standard.object([UserPersistedInfo].self, with: "persistUsersInfo") else { return }
        var notifications = [ClientNotificationModel]()
        
        for id in getUsersPersistedInfo {
            let uid = id.uid
            Database.database().reference().child("users/technicians/\(uid)/notifications").observeSingleEvent(of: .childChanged, with: { [self] snapshot in
                guard let _ = snapshot.value as? [String: Any] else {
                    completion(.failure(DatabaseError.failedToFetch))
                    return
                }
                
                self.database.child("users/technicians/\(uid)/notifications").observeSingleEvent(of: .value, with: { snapshot in
                    guard let notificationsCollection = snapshot.value as? [String: Any] else { return }
                    for (keyPath, _) in notificationsCollection {
                        self.database.child("users/technicians/\(uid)/notifications/\(keyPath)").observeSingleEvent(of: .value, with: { snapshot in
                            guard let value = snapshot.value else { return }
                            do {
                                let model = try FirebaseDecoder().decode(ClientNotificationModel.self, from: value)
                                notifications.append(model)
//                                print("Notifications: \(notifications)")
                                completion(.success(notifications))
                            } catch let error {
                                print(error)
                            }
                        })
                    }
                    
                })
            })
        }
    }
    
    // MARK: - -----
    
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

// MARK: - Sending Messages / Conversations

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
        
        let getUsersPersistedInfo = UserDefaults.standard.object([UserPersistedInfo].self, with: "persistUsersInfo")
        
        var userPersistedEmail = ""
        var userPersistedName = ""
        if let info = getUsersPersistedInfo {
            userPersistedEmail = info.first!.email
            userPersistedName = info.first!.name
        }
        
//        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String,
//        let currentNamme = UserDefaults.standard.value(forKey: "name") as? String else {
//            return
//        }
//        let currentNamme = "pjW9o46h98axzoNsQyyohi2J2XN2"
//        print("currentNamme: "+currentNamme)
//        print("currentEmail: "+currentEmail)

        let safeEmail = DatabaseManager.safeEmail(emailAddress: userPersistedEmail)

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
                "name": userPersistedName, //recipientName
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
        
        let getUsersPersistedInfo = UserDefaults.standard.object([UserPersistedInfo].self, with: "persistUsersInfo")
        
        var userPersistedEmail = ""
        if let info = getUsersPersistedInfo {
            userPersistedEmail = info.first!.email
        }

//        guard let myEmmail = UserDefaults.standard.value(forKey: "email") as? String else {
//            completion(false)
//            return
//        }

        let currentUserEmail = DatabaseManager.safeEmail(emailAddress: userPersistedEmail)

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

        let getUsersPersistedInfo = UserDefaults.standard.object([UserPersistedInfo].self, with: "persistUsersInfo")
        
        var myEmail = ""
//        var userPersistedName = ""
        if let info = getUsersPersistedInfo {
            myEmail = info.first!.email
//            userPersistedName = info.first!.name
        }
        
//        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
//            completion(false)
//            return
//        }

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

            let getUsersPersistedInfo = UserDefaults.standard.object([UserPersistedInfo].self, with: "persistUsersInfo")
            
            var userPersistedEmail = ""
            if let info = getUsersPersistedInfo {
                userPersistedEmail = info.first!.email
            }
            
//            guard let myEmmail = UserDefaults.standard.value(forKey: "email") as? String else {
//                completion(false)
//                return
//            }

            let currentUserEmail = DatabaseManager.safeEmail(emailAddress: userPersistedEmail)

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
//        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//            return
//        }
        let getUsersPersistedInfo = UserDefaults.standard.object([UserPersistedInfo].self, with: "persistUsersInfo")
        
        var userPersistedEmail = ""
        if let info = getUsersPersistedInfo {
            userPersistedEmail = info.first!.email
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: userPersistedEmail)

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
        let getUsersPersistedInfo = UserDefaults.standard.object([UserPersistedInfo].self, with: "persistUsersInfo")
        
        var userPersistedEmail = ""
//        var userPersistedName = ""
        if let info = getUsersPersistedInfo {
            userPersistedEmail = info.first!.email
//            userPersistedName = info.first!.name
        }
//        print("email: \(userPersistedEmail)")
//        guard let senderEmail = UserDefaults.standard.value(forKey: "email") as? String else {
//            return
//        }
        let safeSenderEmail = DatabaseManager.safeEmail(emailAddress: userPersistedEmail)

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

// MARK: - App Model
struct ClientModel: Codable {
   
    let numberOfActivePosts: Int
    let numberOfInactivePosts: Int
    let numberOfPosts: Int
    let profileInfo: ClientProfileInfo
    let servicePosts: [ServicePosts]? // array of user's post
//    let notifications: ClientNotificationModel?
//    chats[]
}

struct ClientProfileInfo: Codable {
    let id: String
    let email: String
//    let profileImage: String
//    let coverImage: String
    let location: String
    let name: String
    let membershipDate: String
}

struct ServicePosts: Codable {
    let postID: String
}

struct ClientNotificationModel: Codable {
    var id: String
    var type: String
    var title: String
    var description: String
    var dateTime: String
    var wasAccepted: Bool?
    var technicianInfo: TechnicianInfo?
}

struct TechnicianInfo: Codable {
    var name: String
    var email: String
    var keyPath: String?
}

struct TechnicianModel: Codable {
    
    let numberOfCompletedServices: Int
    let numberOfActiveServices: Int
    let numberOfPreviousServices: Int
    let technieRank: Int
    let profileInfo: TechnicianProfileInfo
//    let hired: HiredJobs?
//    let notifications: TechnicianNotificationModel? //array of notification with uid
    
//    clientsSatisfaction[],
//    chats[]
}

struct TechnicianProfileInfo: Codable {
    let id: String
    let name: String
    let email: String
//    let profileImage: String
//    let coverImage: String
    let location: String
    let profileSummary: String
    let experience: String //Int?
    let accountType: String
    let hourlyRate: Int
    let skills: [String]
    let membershipDate: String
}


struct HiredJobs: Codable { //Added to the db only when technician accept the hiring offer
    var postChildPath: String
    var isCompleted: Bool
    var clientEmail: String?
}

struct TechnicianNotificationModel: Codable {
    var id: String
    var type: String
    var title: String
    var description: String
    var dateTime: String
    var postChildPath: String?
    var isHiringAccepted: Bool? // only available if the notification type is hiring
    var clientInfo: ClientInfo?
}


struct ClientInfo: Codable {
    var name: String
    var email: String
    var keyPath: String? //  only available if the notification type is hiring
}

struct PostModel: Codable {
    
    let id: String?
    let title: String
    let description: String
    let attachments: [String]
    let projectType: String
    let budget: String
    let location: String? //jobLocation?
    let requiredSkills: [String]

    let availabilityStatus: Bool
    let numberOfProposals: Int
    let numberOfInvitesSent: Int
    let numberOfUnansweredInvites: Int
    let dateTime: String
    let field: String?
    let postOwnerInfo: PostOwnerInfo?
    let hiringStatus: HiringStatus?
    let proposals: [Proposals]?
 
}

struct PostOwnerInfo: Codable {
    var name: String
    var email: String
    var location: String
    var keyPath: String
    var profileImage: String?
}

struct HiringStatus: Codable {
    var isHired: Bool
    var technicianToHireEmail: String
}

struct Proposals: Codable {
    var technicianEmail: String
    var coverLetter: String
}

struct LocationModel: Codable {
    var geoLocation: String
    var lat: Double
    var long: Double
}


// MARK: - ------
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
    let id: String
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
    let membershipDate: String

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
    let id: String
    let firstName: String
    let middleName: String
    let lastName: String
    let emailAddress: String
    let location: String
    let numberOfPosts: Int
    let numberOfActivePosts: Int
    let numberOfInactivePosts: Int
    let membershipDate: String
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

