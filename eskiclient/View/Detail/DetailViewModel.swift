//
//  DetailViewModel.swift
//  eskiclient
//
//  Created by Onur Geneş on 9.10.2020.
//

import SwiftUI
import Combine
import SwiftSoup

final class DetailViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let link: String
    private let eksiAPI = EksiAPI()
    
    @Published var entries = [Entry]()
    @Published var title = ""
    @Published var clickedLink: ClickedLink? = nil
    @Published var isAlertPresented = false
    
    init(link: String) {
        self.link = link
    }
    
    func getDetails() {
        eksiAPI.getDetails(link: link).sink { completion in
            switch completion {
            case .failure(let error):
                print(error)
            case .finished:
                break
            }
        } receiveValue: { responseString in
            do {
                let html = responseString
                let doc: Document = try SwiftSoup.parse(html)
                self.title = try doc.select("#title > a > span").text()
                let item = try doc.select("#entry-item-list > li")
                
                // #entry-item-list > li:nth-child(2) > footer > div.info > a.entry-date.permalink
                try item.forEach { element in
                    let authorId = try element.attr("data-author-id")
                    let entryId = try element.attr("data-id")
                    let content = try element.select("div.content")
                    let footer = try element.select("footer")
                    let date = try footer.select("div.info > a.entry-date.permalink").text()
                    let author = try footer.select("div.info > a.entry-author").text()
                    let favoriteCount = try footer.select("div.feedback > span.favorite-links > a.favorite-count.toggles").text()
                    
                    let attributedString = try NSMutableAttributedString(data: content.html().data(using: .utf8)!,
                                                                         options: [.documentType: NSAttributedString.DocumentType.html,
                                                                                   .characterEncoding: String.Encoding.utf8.rawValue],
                                                                         documentAttributes: nil)
                    attributedString.setBaseFont(baseFont: UIFont.preferredFont(forTextStyle: .body))
                    attributedString.addAttribute(.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: attributedString.length))
                    
                    let entry = Entry(content: attributedString, author: author, date: date, favoritesCount: favoriteCount, entryId: entryId, authorId: authorId, isFavorited: false)
                    self.entries.append(entry)
                }
                
                
            } catch Exception.Error(let type, let message) {
                print(type, message)
            } catch {
                print("error")
            }
        }.store(in: &cancellables)
        
    }
}

extension NSMutableAttributedString {
    
    /// Replaces the base font (typically Times) with the given font, while preserving traits like bold and italic
    func setBaseFont(baseFont: UIFont, preserveFontSizes: Bool = false) {
        let baseDescriptor = baseFont.fontDescriptor
        let wholeRange = NSRange(location: 0, length: length)
        beginEditing()
        enumerateAttribute(.font, in: wholeRange, options: []) { object, range, _ in
            guard let font = object as? UIFont else { return }
            // Instantiate a font with our base font's family, but with the current range's traits
            let traits = font.fontDescriptor.symbolicTraits
            guard let descriptor = baseDescriptor.withSymbolicTraits(traits) else { return }
            let newSize = preserveFontSizes ? descriptor.pointSize : baseDescriptor.pointSize
            let newFont = UIFont(descriptor: descriptor, size: newSize)
            self.removeAttribute(.font, range: range)
            self.addAttribute(.font, value: newFont, range: range)
        }
        endEditing()
    }
}
