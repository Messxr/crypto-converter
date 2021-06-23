//
//  CryptoesTableViewController.swift
//  Crypto
//
//  Created by Daniil Marusenko on 25.02.2021.
//

import UIKit

protocol CryptoesTableViewControllerDelegate {
    func getCryptoName(name: String)
}

class CryptoesTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var delegate: CryptoesTableViewControllerDelegate?
    var filteredNames: [String]!
    var filteredCryptoes: [String]!
    var fromConverter: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "gradient"), for: .default)
        
        searchBar.delegate = self

        if fromConverter == true {
            filteredCryptoes = Cryptoes.converterCryptoArray
            filteredNames = Cryptoes.converterNameArray
        } else if fromConverter == false {
            filteredCryptoes = Cryptoes.chartCryptoArray
            filteredNames = Cryptoes.chartNameArray
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredCryptoes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Currency", for: indexPath) as! CryptoTableViewCell
        cell.cryptoLabel.text = filteredCryptoes[indexPath.row]
        cell.nameLabel.text = filteredNames[indexPath.row]
        return cell
    }
    
    //MARK: - UITableViewDelegate
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.getCryptoName(name: filteredCryptoes[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        var cryptoArray = [String]()
        var nameArray = [String]()
        
        if fromConverter == true {
            cryptoArray = Cryptoes.converterCryptoArray
            nameArray = Cryptoes.converterNameArray
        } else if fromConverter == false {
            cryptoArray = Cryptoes.chartCryptoArray
            nameArray = Cryptoes.chartNameArray
        }
        
        filteredCryptoes = []
        filteredNames = []
        
        if searchText == "" {
            filteredCryptoes = cryptoArray
            filteredNames = nameArray
        } else {
            for crypto in cryptoArray {
                if crypto.lowercased().contains(searchText.lowercased()) {
                    filteredCryptoes.append(crypto)
                    filteredNames.append(nameArray[cryptoArray.firstIndex(of: crypto)!])
                }
            }
            for name in nameArray {
                if name.lowercased().contains(searchText.lowercased()) {
                    let crypto = cryptoArray[nameArray.firstIndex(of: name)!]
                    if !filteredCryptoes.contains(crypto) {
                        filteredCryptoes.append(crypto)
                        filteredNames.append(name)
                    }
                }
            }
        }
                
        tableView.reloadData()
        
    }

}
