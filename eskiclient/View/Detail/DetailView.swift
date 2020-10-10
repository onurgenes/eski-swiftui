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
            ScrollView {
                ForEach(viewModel.entries) { entry in
                    EntryView(entry: entry, clickedLink: $viewModel.clickedLink)
                        .padding()
                    Divider()
                }
            }
            .alert(item: $viewModel.clickedLink, content: { clickedLink -> Alert in
                return Alert(title: Text(clickedLink.text),
                             message: Text(clickedLink.url.absoluteString),
                             dismissButton: .default(Text("dismiss")))
            })
            .onAppear(perform: {
                viewModel.getDetails()
            })
            .navigationBarTitle(viewModel.title)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(viewModel: DetailViewModel(link: ""))
    }
}
