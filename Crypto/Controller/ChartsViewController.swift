//
//  ChartsViewController.swift
//  Crypto
//
//  Created Daniil Marusenko on 25.02.2021.
//

import UIKit
import SwiftChart

class ChartsViewController: UIViewController, ChartDelegate, CryptoManagerDelegate, CryptoesTableViewControllerDelegate {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cryptoButton: UIButton!
    @IBOutlet weak var labelLeadingMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var buttonView: UIView!
    
    var labelLeadingMarginInitialConstant: CGFloat!
    var cryptoManager = CryptoManager()
    var currency = "BTC"
    var rates = [Double]()
    var duration = "1W"
    
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
        
        let titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Arial", size: 18), NSAttributedString.Key.foregroundColor:UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        let normalFont = UIFont.systemFont(ofSize: 16)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: normalFont], for: .normal)
        labelLeadingMarginInitialConstant = labelLeadingMarginConstraint.constant
        cryptoManager.delegate = self
        
        buttonView.layer.cornerRadius = 10
        buttonView.layer.shadowColor = UIColor.black.cgColor
        buttonView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        buttonView.layer.shadowOpacity = 0.2
        buttonView.layer.shadowRadius = 3
                
        initializeChart()
        cryptoManager.performRequest(currency: "btc", isHistorical: false, duration: nil)
        
        chart.removeAllSeries()
        cryptoManager.performRequest(currency: currency, isHistorical: true, duration: duration)
    }
    
    func initializeChart() {
        chart.delegate = self
        
        chart.labelFont = UIFont.systemFont(ofSize: 12)
        
        chart.yLabelsFormatter = { (labelIndex: Int, labelValue: Double) -> String in
            let numberFormatter = NumberFormatter()
            numberFormatter.minimumFractionDigits = 2
            return numberFormatter.string(from: NSNumber(value: labelValue))!
        }
        
        let series = ChartSeries(rates)
        series.color = ChartColors.blueColor()
        series.area = true
        chart.labelColor = .black
        chart.lineWidth = 0.8
        chart.xLabelsTextAlignment = .center
        chart.yLabelsOnRightSide = true
        chart.gridColor = .white
        chart.add(series)
    }
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        
        if let title = sender.titleForSegment(at: sender.selectedSegmentIndex) {
            chart.removeAllSeries()
            label.text = ""
            duration = title
            cryptoManager.performRequest(currency: currency, isHistorical: true, duration: duration)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "chartsToCryptoes" {
            let navigationVC = segue.destination as! UINavigationController
            let destinationVC = navigationVC.topViewController as! CryptoesTableViewController
            destinationVC.delegate = self
            destinationVC.fromConverter = false
        }
        
    }
    
    @IBAction func cryptoButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "chartsToCryptoes", sender: self)
    }
    
    func getRate(_ rates: [Double]?) {
        
        DispatchQueue.main.async {
            if let rates = rates {
                if rates.count == 1 {
                    self.priceLabel.text = "\(rates[0]) $"
                } else {
                    self.rates = rates
                    self.initializeChart()
                }
            } else {
                self.priceLabel.text = "-"
            }
        }
        
    }
    
    func getCryptoName(name: String) {
        currency = name
        cryptoButton.setTitle(name, for: .normal)
        titleLabel.text = "\(name) for 1 USD"
        cryptoManager.performRequest(currency: name, isHistorical: false, duration: nil)
        chart.removeAllSeries()
        cryptoManager.performRequest(currency: currency, isHistorical: true, duration: duration)
    }
    
    
    //MARK: - Chart delegate
    
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        
            if let value = chart.valueForSeries(0, atIndex: indexes[0]) {
                
                let numberFormatter = NumberFormatter()
                numberFormatter.minimumFractionDigits = 4
                numberFormatter.maximumFractionDigits = 4
                label.text = numberFormatter.string(from: NSNumber(value: value))
                
                // Align the label to the touch left position, centered
                var constant = labelLeadingMarginInitialConstant + left - (label.frame.width / 2)
                
                // Avoid placing the label on the left of the chart
                if constant < labelLeadingMarginInitialConstant {
                    constant = labelLeadingMarginInitialConstant
                }
                
                // Avoid placing the label on the right of the chart
                let rightMargin = chart.frame.width - label.frame.width
                if constant > rightMargin {
                    constant = rightMargin
                }
                
                labelLeadingMarginConstraint.constant = constant
                
            }
        
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        label.text = ""
        labelLeadingMarginConstraint.constant = labelLeadingMarginInitialConstant
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        // Redraw chart on rotation
        chart.setNeedsDisplay()
        
    }
    
}
