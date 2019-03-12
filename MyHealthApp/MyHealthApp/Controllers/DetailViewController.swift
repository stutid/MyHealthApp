//
//  DetailViewController.swift
//  MyHealthApp
//
//  Created by Stuti on 09/10/18.
//  Copyright © 2018 iOS. All rights reserved.
//

import UIKit
import SVProgressHUD

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var detailViewModelObj: DetailViewModel!
    @IBOutlet weak var btnHeartRate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailViewModelObj = DetailViewModel()
        detailViewModelObj.delegate = self
        SVProgressHUD.show(withStatus: "Loading data...")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setUpUI() {
        setupButtonUI()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        
        let rightBarBtn = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutBtnClicked))
        rightBarBtn.setTitleTextAttributes([NSAttributedStringKey.font : UIFont(name: "Cochin-Bold", size: 18)!, NSAttributedStringKey.foregroundColor : UIColor.white], for: .normal)
        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    func setupButtonUI() {
        btnHeartRate.layer.cornerRadius = 10.0
        btnHeartRate.layer.masksToBounds = true
    }
    
    @objc func logoutBtnClicked() {
        detailViewModelObj.logout()
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailViewModelObj.getUserDataCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath)
        cell.textLabel?.text = detailViewModelObj.displayUserDataHeading(at: indexPath.row)
        cell.detailTextLabel?.text = detailViewModelObj.displayUserData(at: indexPath.row)
        return cell
    }
}

extension DetailViewController: DetailDelegate {
    
    func logout() {
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func updateUI() {
        SVProgressHUD.dismiss()
        self.tableView.reloadData()
    }
}


extension DetailViewController: HeartRateKitControllerDelegate {
    
    @IBAction func checkYourHeartRateBtnAction(_ sender: UIButton) {
        let heartRateKitController = HeartRateKitController()
        heartRateKitController.delegate = self
        self.present(heartRateKitController, animated: true, completion: nil)
    }
    
    func heartRateKitController(_ controller: HeartRateKitController, didFinishWith result: HeartRateKitResult) {
        self.dismiss(animated: true) {
            self.showHeartRateResult(result)
        }
    }
    
    func heartRateKitControllerDidCancel(_ controller: HeartRateKitController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showHeartRateResult(_ result: HeartRateKitResult) {
        let heartRate = String(format: "%0.2f bpm", result.bpm)
        let timeStamp = "\(Date().timeIntervalSince1970 * 1000)"
        detailViewModelObj.postHeartRateData(with: heartRate, and: timeStamp)
        
        let alertController = UIAlertController(title: "Your Heart Rate", message: heartRate, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}
