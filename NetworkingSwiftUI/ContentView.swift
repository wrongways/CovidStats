//
//  ContentView.swift
//  NetworkingSwiftUI
//
//  Created by jez wain on 8/26/20.
//  Copyright © 2020 jez wain. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var model = ResultsModel()
    
    init() {
        refresh()
    }
    var body: some View {
        List(model.covidHistory) { record in
            Text(self.dateToString(record.date))
        }
    }
    
    func dateToString(_ inDate: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.timeZone = TimeZone(abbreviation: "MDT")
        let date = formatter.date(from: String(inDate))!
        formatter.dateFormat = nil
        formatter.locale = Locale(identifier: "en_GB")
        formatter.setLocalizedDateFormatFromTemplate("MMMMdyyyy")
        formatter.dateStyle = .full
        return formatter.string(from: date)
        
    }
    
    func refresh() {
        let apiRoot = URL(string: "https://api.covidtracking.com/v1/us/daily.json")!
        let urlRequest = URLRequest(url: apiRoot, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 2)
        
        // Can gain further control (cellular access, headers, cookies...) by createing custom URLSession and passing
        // config to it. Then create dataTask from this session object
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if let data = data {
                if let covidHistory = try? JSONDecoder().decode([DailyCovidStats].self, from: data) {
                    DispatchQueue.main.async {
                        self.model.covidHistory = covidHistory.reversed()
                    }
                } else {
                    print("Failed to decode JSON")
                    let jsonString = String(data: data, encoding: .utf8)!
                    print(jsonString)
                }
            } else {
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("No data received for some reason")
                }
            }
        })
        
        dataTask.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
