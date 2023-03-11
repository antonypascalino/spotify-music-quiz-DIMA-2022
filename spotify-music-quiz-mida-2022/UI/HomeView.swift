//
//  ContentView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 19/12/22.
//

import SwiftUI

let name = "Antony"

struct HomeView: View {
    var body: some View {
        ScrollView {
            HStack {
                Text("Hi \(name)!")
                    .font(TextStyle.homeTitle())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "bell")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                }
                .navigationTitle("Settings")
            }
        }
        .background(Color("Black"))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
