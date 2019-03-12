//
//  DetailViewModel.swift
//  MyHealthApp
//
//  Created by Stuti on 09/10/18.
//  Copyright © 2018 iOS. All rights reserved.
//

import Foundation

private enum UserDataType: Int {
    case FirstName = 0
    case LastName = 1
    case Dob = 2
    case EmailAddress = 3
    case GeneticResults = 4
    
    static let count: Int = {
        var max: Int = 0
        while let _ = UserDataType(rawValue: max) {
            max += 1
        }
        return max
    }()
}

protocol DetailDelegate: class {
    func logout()
    func updateUI()
}

class DetailViewModel {
    
    private let apiManager = ApiManager()
    weak var delegate: DetailDelegate?
    private var user = User()
    private let dispatchGroup = DispatchGroup()
    
    init() {
        getUserData()
        getGeneticsData()
        dispatchGroup.notify(queue: .main) {
            self.delegate?.updateUI()
        }
    }
    
    func displayUserDataHeading(at index: Int) -> String {
        switch index {
        case UserDataType.FirstName.rawValue:
            return "First Name:"
        case UserDataType.LastName.rawValue:
            return "Last Name:"
        case UserDataType.Dob.rawValue:
            return "Date of Birth:"
        case UserDataType.EmailAddress.rawValue:
            return "Email Address:"
        case UserDataType.GeneticResults.rawValue:
            return "Genetics Result:"
        default:
            return ""
        }
    }
    
    func displayUserData(at index: Int) -> String {
        switch index {
        case UserDataType.FirstName.rawValue:
            return user.firstname ?? ""
        case UserDataType.LastName.rawValue:
            return user.lastname ?? ""
        case UserDataType.Dob.rawValue:
            return user.dob ?? ""
        case UserDataType.EmailAddress.rawValue:
            return user.email ?? ""
        case UserDataType.GeneticResults.rawValue:
            var str: String = ""
            for geneData in user.geneticResult! {
                str.append("Gene Symbol: \(geneData.symbol ?? "") \nGene Name: \(geneData.name ?? "")\n\n")
            }
            return str
        default:
            return ""
        }
    }
    
    func getUserDataCount() -> Int {
        return UserDataType.count
    }
    
    private func getUserData() {
        
        dispatchGroup.enter()
        let getCustomerUrl = String(format: getCustomerDataURL, "123")
        apiManager.fetchData(with: getCustomerUrl) { (data, error) in
            if let file = Bundle.main.url(forResource: "UserData", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: file)
                    self.user = try JSONDecoder().decode(User.self, from: data)
                }
                catch {
                }
                self.dispatchGroup.leave()
            }
        }
    }
    
    private func getGeneticsData() {
        
        dispatchGroup.enter()
        let getCustomerGeneticsURL = String(format: getCustomerGeneticsDataURL, "123")
        apiManager.fetchData(with: getCustomerGeneticsURL) { (data, error) in
            if let file = Bundle.main.url(forResource: "GeneticsData", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: file)
                    self.user.geneticResult = try JSONDecoder().decode([GeneticData].self, from: data)
                }
                catch {
                }
                self.dispatchGroup.leave()
            }
        }
    }
    
    func postHeartRateData(with heartRate: String, and timeStamp: String) {
        
        let postHeartRateURL = String(format: lifestylePostURL, "123")
        let parameters = ["rate": heartRate, "timestamp": timeStamp]
        apiManager.postData(with: postHeartRateURL, and: parameters) { (data, error) in
            print("Posted a heart rate entry")
        }
    }
    
    func logout() {
        apiManager.postData(with: logoutPostURL) { (data, error) in
            self.delegate?.logout()
        }
    }
    
}
