//
//  StorageManager.swift
//  Messenger
//
//  Created by Valter A. Machado on 1/19/21.
//

import Foundation
import FirebaseStorage

/// Allows you to get, fetch, and upload files to firebase  storage
final class StorageManager {

    static let shared = StorageManager()

    private init() {}

    private let storage = Storage.storage().reference()

    /*
     /images/afraz9-gmail-com_profile_picture.png
     */

    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    public typealias UploadCertificatePictureCompletion = (Result<String, Error>) -> Void

    /// Uploads picture to firebase storage and returns completion with url string to download
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("profile_images/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            guard let strongSelf = self else {
                return
            }

            guard error == nil else {
                // failed
                print("failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }

            strongSelf.storage.child("profile_images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }

                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    public func uploadProofOfExpertise(with data: Data, fileName: String, completion: @escaping UploadCertificatePictureCompletion) {
        storage.child("proofOfService_images/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            guard let strongSelf = self else {
                return
            }

            guard error == nil else {
                // failed
                print("failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }

            strongSelf.storage.child("proofOfService_images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }

                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    public func uploadProfilePictureAndCertificate(with data: Data, certificateFile: Data, fileName: String, completion: @escaping UploadPictureCompletion, certificateCompletion: @escaping UploadPictureCompletion) {
        
        storage.child("profile_images/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            guard let strongSelf = self else {
                return
            }

            guard error == nil else {
                // failed
                print("failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }

            strongSelf.storage.child("profile_images/\(fileName)").downloadURL(completion: { profileImageUrl, error in
                guard let profileImageUrl = profileImageUrl else {
                    print("Failed to get profileImageUrl")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }

                strongSelf.storage.child("proofOfService_images/\(fileName)").putData(certificateFile, metadata: nil, completion: { metadata, error in
                    
                    strongSelf.storage.child("proofOfService_images/\(fileName)").downloadURL(completion: { certificateFileUrl, error in
                        guard let certificateFileUrl = certificateFileUrl else {
                            print("Failed to get certificateFileUrl")
                            certificateCompletion(.failure(StorageErrors.failedToGetDownloadUrl))
                            return
                        }

                        let certificateFileUrlString = certificateFileUrl.absoluteString
                        let profileImageUrlString = profileImageUrl.absoluteString
                        print("download certificateFileUrlString returned: \(certificateFileUrlString)")
                        print("download profileImageUrlString returned: \(profileImageUrlString)")
                        completion(.success(profileImageUrlString))
                        certificateCompletion(.success(certificateFileUrlString))
                    })
                    
                })

            })
        })
    }

    /// Upload image that will be sent in a conversation message
    public func uploadMessagePhoto(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("message_images/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            guard error == nil else {
                // failed
                print("failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }

            self?.storage.child("message_images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }

                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
    }

    public func uploadPostImages(with imageArray: [Data], with fileNameArray: [String], completion: @escaping UploadPictureCompletion) {
        DispatchQueue.global(qos: .userInitiated).async {[self] in
            
            guard let getUsersPersistedInfo = UserDefaults.standard.object(UserPersistedInfo.self, with: "persistUsersInfo") else { return }
            let email = getUsersPersistedInfo.email
            for data in imageArray {
                for fileName in fileNameArray {
                    let storagePath = storage.child("post_images").child("\(email)/\(fileName)")
                    storagePath.putData(data, metadata: nil, completion: { metadata, error in
                        //                    guard let strongSelf = self else { return }
                        
                        guard error == nil else {
                            // failed
                            print("failed to upload data to firebase for picture")
                            completion(.failure(StorageErrors.failedToUpload))
                            return
                        }
                        
                        storagePath.downloadURL(completion: { url, error in
                            guard let url = url else {
                                print("Failed to get download url")
                                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                                return
                            }
                            
                            let urlString = url.absoluteString
                            print("download url: \(urlString)")
                            completion(.success(urlString))
                        })
                    })
                }
            }
        }
        
    }
    
//    public func getPostImages(with data: [Data], fileName: [String], completion: @escaping UploadPictureCompletion) {
//
////        guard error == nil else {
////            // failed
////            print("failed to upload data to firebase for picture")
////            completion(.failure(StorageErrors.failedToUpload))
////            return
////        }
//
//        storage.child("post_images").child("technician2@hotmail.com/\(name)").downloadURL(completion: { url, error in
//            guard let url = url else {
//                print("Failed to get download url")
//                completion(.failure(StorageErrors.failedToGetDownloadUrl))
//                return
//            }
//
//            let urlString = url.absoluteString
//            print("download url returned: \(urlString)")
//            completion(.success(urlString))
//        })
//
//    }
    
    /// Upload video that will be sent in a conversation message
    public func uploadMessageVideo(with fileUrl: URL, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("message_videos/\(fileName)").putFile(from: fileUrl, metadata: nil, completion: { [weak self] metadata, error in
            guard error == nil else {
                // failed
                print("failed to upload video file to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }

            self?.storage.child("message_videos/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }

                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
    }

    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }

    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)

        reference.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return
            }

            completion(.success(url))
        })
    }
}
