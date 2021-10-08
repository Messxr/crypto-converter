//
//  CryptoManager.swift
//  Crypto
//
//  Created by Daniil Marusenko on 26.02.2021.
//

import Foundation

protocol CryptoManagerDelegate {
    func getRate(_ rates: [Double]?)
}

struct CryptoManager {
    
    var delegate: CryptoManagerDelegate?
    
    func performRequest(currency: String, isHistorical: Bool, duration: String?) {
        
        if isHistorical {
            guard let duration = duration else { return }
            let timeLimits = getTimeLimits(duration: duration)
            let startTime = timeLimits[0]
            let endTime = timeLimits[1]
            let historicalURL = "https://rest.coinapi.io/v1/ohlcv/\(currency.uppercased())/USD/history?apikey=889B6F71-79D7-42A8-8496-8F8C833088BD&period_id=1DAY&limit=1000&time_start=\(startTime)&time_end=\(endTime)"
            print("\(historicalURL)\n\n")
            guard let url = URL(string: historicalURL) else { return }
            performSessionTask(with: url, isHistorical: isHistorical)
        } else {
            let exchangeURL = "https://api.cryptowat.ch/markets/bittrex/\(currency)usd/price"
            guard let url = URL(string: exchangeURL) else { return }
            performSessionTask(with: url, isHistorical: isHistorical)
        }
        
    }
    
    func performSessionTask(with url: URL, isHistorical: Bool) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return
            }
            if let safeData = data {
                let rate = self.parseJSON(data: safeData, isHistorical: isHistorical)
                self.delegate?.getRate(rate)
            }
        }
        task.resume()
    }
    
    
    func parseJSON(data: Data, isHistorical: Bool) -> [Double]? {
        let decoder = JSONDecoder()
        do {
            if isHistorical {
                let decodedData = try decoder.decode(HistoryDataModel.self, from: data)
                var priceArray = [Double]()
                for price in decodedData {
                    priceArray.append(price.priceClose)
                }
                return priceArray
            } else {
                let decodedData = try decoder.decode(CryptoDataModel.self, from: data)
                let price = [decodedData.result.price]
                print(price)
                return price
            }
            
        } catch {
            return nil
        }
    }
    
    func getTimeLimits(duration: String) -> [String] {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let year = Int(formatter.string(from: date))!
        formatter.dateFormat = "MM"
        let month = Int(formatter.string(from: date))!
        formatter.dateFormat = "dd"
        let day = Int(formatter.string(from: date))!
        formatter.dateFormat = "yyyy-MM-dd"
        let end = "\(formatter.string(from: date))T00:00:00"
        
        var start = ""
        switch duration {
        case "1W":
            if day < 8 {
                formatter.dateFormat = "yyyy-\(month - 1)-\(calculateDate(date: 30 + day - 7))"
                start = "\(formatter.string(from: date))T00:00:00"
            } else {
                formatter.dateFormat = "yyyy-MM-\(calculateDate(date: day - 7))"
                start = "\(formatter.string(from: date))T00:00:00"
            }
        case "1M":
            if month == 1 {
                formatter.dateFormat = "\(year - 1)-12-dd"
                start = "\(formatter.string(from: date))T00:00:00"
            } else {
                formatter.dateFormat = "yyyy-\(calculateDate(date: month - 1))-dd"
                start = "\(formatter.string(from: date))T00:00:00"
            }
        case "3M":
            if month < 4 {
                formatter.dateFormat = "\(year - 1)-\(calculateDate(date: 12 + month - 3))-dd"
                start = "\(formatter.string(from: date))T00:00:00"
            } else {
                formatter.dateFormat = "yyyy-\(calculateDate(date: month - 3))-dd"
                start = "\(formatter.string(from: date))T00:00:00"
            }
        case "6M":
            if month < 7 {
                formatter.dateFormat = "\(year - 1)-\(calculateDate(date: 12 + month - 6))-dd"
                start = "\(formatter.string(from: date))T00:00:00"
            } else {
                formatter.dateFormat = "yyyy-\(calculateDate(date: month - 6))-dd"
                start = "\(formatter.string(from: date))T00:00:00"
            }
        case "1Y":
            formatter.dateFormat = "\(year - 1)-MM-dd"
            start = "\(formatter.string(from: date))T00:00:00"
        case "2Y":
            formatter.dateFormat = "\(year - 2)-MM-dd"
            start = "\(formatter.string(from: date))T00:00:00"
        default:
            start = ""
        }
        
        return [start, end]
        
    }
    
    func calculateDate(date: Int) -> String {
//        var calculatedDate = 0
        if String(date).count == 1 {
            return "0\(date)"
        } else {
            return "\(date)"
        }
    }
    
    
}

