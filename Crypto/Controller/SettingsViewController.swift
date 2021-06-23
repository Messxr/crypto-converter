//
//  SettingsViewController.swift
//  Crypto
//
//  Created by Daniil Marusenko on 25.02.2021.
//

import UIKit
import StoreKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet var buttonViews: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "gradient"),
                                                                    for: .default)
        
        manageUI()
    }
    
    @IBAction func rateButtonPressed(_ sender: UIButton) {
        rateApp()
    }
    
    @IBAction func supportButtonPressed(_ sender: UIButton) {
        if let url = URL(string: "") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func privacyPolicyPressed(_ sender: UIButton) {
        if let url = URL(string: "") {
            UIApplication.shared.open(url)
        }
    }
    
    func rateApp() {
        
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
            
        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "appId") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    
    func manageUI() {
        for view in buttonViews {
            view.layer.cornerRadius = 10
            view.clipsToBounds = true
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            view.layer.shadowOpacity = 0.2
            view.layer.shadowRadius = 3
        }
    }
    
}

