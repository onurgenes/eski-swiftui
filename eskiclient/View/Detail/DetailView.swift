//
//  DetailView.swift
//  eskiclient
//
//  Created by Onur Geneş on 9.10.2020.
//

import SwiftUI
import WebKit

struct DetailView: View {
    
    @ObservedObject var viewModel: DetailViewModel
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.entries) { entry in
                    
                    TextView(text: entry.content, clickedLink: $viewModel.clickedLink)
                    HStack {
                        Spacer()
                        Button("Share") {
                            
                        }.buttonStyle(PlainButtonStyle()).font(.footnote)
                        Button("Share") {
                            
                        }.buttonStyle(PlainButtonStyle()).font(.footnote)
                        Button("Share") {
                            
                        }.buttonStyle(PlainButtonStyle()).font(.footnote)
                        Button("Share") {
                            
                        }.buttonStyle(PlainButtonStyle()).foregroundColor(.pink).font(.footnote)
                        Spacer()
                    }}
            }
            
        }
        .alert(item: $viewModel.clickedLink, content: { clickedLink -> Alert in
            return Alert(title: Text(clickedLink.text), message: Text(clickedLink.url.absoluteString), dismissButton: .default(Text("dismiss")))
        })
        .onAppear(perform: {
            viewModel.getDetails()
        })
        .navigationBarTitle(viewModel.title)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(viewModel: DetailViewModel(link: ""))
    }
}
