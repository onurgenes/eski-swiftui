//
//  HomeViewModel.swift
//  eskiclient
//
//  Created by Onur Geneş on 9.10.2020.
//

import Combine
import SwiftUI
import SwiftSoup

final class HomeViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let eksiAPI = EksiAPI()
    
    @Published var headings = [Heading]()
    
    func getHomePage() {
        eksiAPI.getHomePage().sink { completion in
            switch completion {
            case .failure(let error):
                print(error)
                print(error.localizedDescription)
            case .finished:
                break
            }
        } receiveValue: { stringValue in
            do {
                let html = stringValue
                let doc: Document = try SwiftSoup.parse(html)
                let basliklar = try doc.select("#content-body > ul > li > a")
                try basliklar.forEach { element in
                    let heading = Heading(name: try element.text().replacingOccurrences(of: try element.select("small").text(), with: ""),
                                          count: try element.select("small").text(),
                                          link: try element.attr("href"))
                    self.headings.append(heading)
                }
                
            } catch Exception.Error(let type, let message) {
                print(type, message)
            } catch {
                print("error")
            }
        }.store(in: &cancellables)
    }
}
