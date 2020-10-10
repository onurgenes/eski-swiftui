//
//  HomeView.swift
//  eskiclient
//
//  Created by Onur Geneş on 9.10.2020.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    @State var didLoad = false
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.headings) { heading in
                    NavigationLink(destination: DetailView(viewModel: DetailViewModel(link: heading.link ?? ""))) {
                        Text(heading.name ?? "")
                    }
                }
            }
        }.onAppear(perform: {
            if !didLoad {
                viewModel.getHomePage()
            }
            didLoad = true
        }).navigationBarTitle("bugun")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
