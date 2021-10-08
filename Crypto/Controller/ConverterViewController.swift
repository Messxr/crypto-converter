//
//  ViewController.swift
//  Crypto
//
//  Created by Daniil Marusenko on 25.02.2021.
//

import UIKit

class ConverterViewController: UIViewController, CryptoesTableViewControllerDelegate {

    @IBOutlet weak var gradientImageView: UIImageView!
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet var calculatorButtons: [UIButton]!
    @IBOutlet weak var firstValueLabel: UILabel!
    @IBOutlet weak var secondValueLabel: UILabel!
    @IBOutlet weak var сryptoButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var cryptoManager = CryptoManager()
    var currency = "btc"
    var firstCalcValue: Double = 0
    var secondCalcValue: Double = 0
    var currentSign = ""
    var resetLabelText = false
    var equalPressed = false
    var signPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundImage = UIImage(named: "gradient")
            appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                              .foregroundColor: UIColor.white]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.setBackgroundImage(UIImage(named: "gradient"), for: .default)
        }

        manageUI()
                
        cryptoManager.delegate = self

        cryptoManager.performRequest(currency: currency, isHistorical: false, duration: nil)
        
        secondValueLabel.adjustsFontSizeToFitWidth = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "converterToCryptoes" {
            let navigationVC = segue.destination as! UINavigationController
            let destinationVC = navigationVC.topViewController as! CryptoesTableViewController
            destinationVC.delegate = self
            destinationVC.fromConverter = true
        }
    }
    
    @IBAction func сryptoPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "converterToCryptoes", sender: self)
    }
    
    func getCryptoName(name: String) {
        currency = name
        сryptoButton.setTitle(name, for: .normal)
        
        cryptoManager.performRequest(currency: currency, isHistorical: false, duration: nil)
    }
    
    @IBAction func calculatorNumberPressed(_ sender: UIButton) {
        
        resetButton.setTitle("C", for: .normal)
        
        if !equalPressed {
            if currentSign == "" {
                if firstValueLabel.text == "0" {
                    firstValueLabel.text = sender.currentTitle
                } else {
                    firstValueLabel.text! += sender.currentTitle!
                }
            } else {
                if resetLabelText || firstValueLabel.text == "0" {
                    firstValueLabel.text = sender.currentTitle
                    resetLabelText = false
                } else {
                    firstValueLabel.text! += sender.currentTitle!
                }
            }
            cryptoManager.performRequest(currency: currency, isHistorical: false, duration: nil)
            signPressed = false
        }
                
    }
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
            
        switch sender.tag {
        
        // Plus sign pressed
        case 0:
            equalPressed = false
            if !resetLabelText {
                calculate(currentSign)
                currentSign = "+"
                signPressed = true
            }
        // Minus sign pressed
        case 1:
            equalPressed = false
            if !resetLabelText {
                calculate(currentSign)
                currentSign = "-"
                signPressed = true
            }
        // Equal sign pressed
        case 2:
            if !signPressed {
                equalPressed = true
                switch currentSign {
                case "+":
                    secondCalcValue = Double(firstValueLabel.text!)!
                    firstValueLabel.text = String(firstCalcValue + secondCalcValue)
                    firstCalcValue = firstCalcValue + secondCalcValue
                case "-":
                    secondCalcValue = Double(firstValueLabel.text!)!
                    firstValueLabel.text = String(firstCalcValue - secondCalcValue)
                    firstCalcValue = firstCalcValue - secondCalcValue
                default:
                    return
                }
                currentSign = ""
            }
        default:
            return
        }
        
    }
    
    func calculate(_ currentSign: String) {
        
        switch currentSign {
        case "":
            firstCalcValue = Double(firstValueLabel.text!)!
            firstValueLabel.text = "0"
        case "+":
            resetLabelText = true
            let answer = firstCalcValue + Double(firstValueLabel.text!)!
            let roundedAnswer = Double(round(100*answer)/100)
            firstValueLabel.text = String(roundedAnswer)
            firstCalcValue = roundedAnswer
        case "-":
            resetLabelText = true
            let answer = firstCalcValue - Double(firstValueLabel.text!)!
            let roundedAnswer = Double(round(100*answer)/100)
            firstValueLabel.text = String(roundedAnswer)
            firstCalcValue = roundedAnswer
        default:
           return
        }
        
        cryptoManager.performRequest(currency: currency, isHistorical: false, duration: nil)
        
    }
    
    @IBAction func dotPressed(_ sender: UIButton) {
        resetButton.setTitle("C", for: .normal)
        if !firstValueLabel.text!.contains(".") {
            firstValueLabel.text! += "."
        }
    }
    
    
    @IBAction func backspacePressed(_ sender: UIButton) {
        
        if firstValueLabel.text != "0" && !equalPressed {

            let count = firstValueLabel.text?.count
            var counter = 0
            var newNumber = ""

            if count == 1 {
                firstValueLabel.text = "0"
            } else {
                for num in firstValueLabel.text! {
                    counter += 1
                    if counter == count {
                        firstValueLabel.text = newNumber
                        firstCalcValue = Double(newNumber) ?? 0
                        return
                    } else {
                        newNumber += String(num)
                    }
                }
            }

        }
        
        secondCalcValue = 0
        currentSign = ""
        resetLabelText = false
        equalPressed = false
        
        cryptoManager.performRequest(currency: currency, isHistorical: false, duration: nil)
        
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        sender.setTitle("AC", for: .normal)
        firstValueLabel.text = "0"
        secondValueLabel.text = "0"
        firstCalcValue = 0
        secondCalcValue = 0
        currentSign = ""
        resetLabelText = false
        equalPressed = false
    }
    
    func manageUI() {
        bottomContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomContainer.layer.cornerRadius = 30
        bottomContainer.layer.shadowColor = UIColor.black.cgColor
        bottomContainer.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        bottomContainer.layer.shadowOpacity = 0.2
        bottomContainer.layer.shadowRadius = 3
        
        gradientImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        gradientImageView.layer.cornerRadius = 30
        
        for button in calculatorButtons {
            button.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            button.layer.cornerRadius = 20
            button.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
}

//MARK: - CryptoManagerDelegate

extension ConverterViewController: CryptoManagerDelegate {
    func getRate(_ rates: [Double]?) {
        DispatchQueue.main.async {
            if let value = Double(self.firstValueLabel.text!), let rates = rates {
                if rates[0] * value == 0.0 {
                    self.secondValueLabel.text = "0"
                } else {
                    self.secondValueLabel.text = String(format: "%.2f", rates[0] * value)
                }
            }
        }
    }
}

