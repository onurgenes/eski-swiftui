//
//  EntryView.swift
//  eskiclient
//
//  Created by Onur Geneş on 10.10.2020.
//

import SwiftUI

struct EntryView: View {
    var entry: Entry
    @Binding var clickedLink: ClickedLink?
    
    var body: some View {
        VStack {
            TextView(text: entry.content, clickedLink: $clickedLink)
            HStack {
                Button(entry.author) {
                    print("AuthorName", entry.author)
                }
                .font(.footnote)
                
                Text(entry.date)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.footnote)
                    .foregroundColor(Color.gray)
            }
            .padding([.leading, .trailing], 10)
            
            Spacer(minLength: 10)
            
            HStack {
                Spacer()
                Button("Share") {
                    
                }
                .buttonStyle(PlainButtonStyle())
                .font(.footnote)
                
                Button("Share") {
                    
                }
                .buttonStyle(PlainButtonStyle())
                .font(.footnote)
                
                Button("Share") {
                    
                }
                .buttonStyle(PlainButtonStyle())
                .font(.footnote)
                
                Button("Share") {
                    
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.pink)
                .font(.footnote)
                
                Spacer()
            }
        }
    }
}
