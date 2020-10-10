//
//  ContentView.swift
//  eskiclient
//
//  Created by Onur Geneş on 9.10.2020.
//

import SwiftUI

struct ContentView: View {
    
    @State var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView(content: {
                HomeView(viewModel: HomeViewModel())
            }).tabItem {
                Text("anasayfa").font(.title)
                selection == 0 ? Image(systemName: "house.circle.fill") : Image(systemName: "house.circle")
            }
            
            NavigationView(content: {
                SearchView()
            }).tabItem {
                Text("arama").font(.title)
                selection == 1 ? Image(systemName: "magnifyingglass.circle.fill") : Image(systemName: "magnifyingglass.circle")
            }
            
            NavigationView(content: {
                Text("---")
            }).tabItem {
                Text("profil").font(.title)
                selection == 3 ? Image(systemName: "person.crop.circle.fill") : Image(systemName: "person.crop.circle")
            }
            
            NavigationView(content: {
                SettingsView()
            }).tabItem {
                Text("ayarlar").font(.title)
                selection == 2 ? Image(systemName: "gearshape.fill") : Image(systemName: "gearshape")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
