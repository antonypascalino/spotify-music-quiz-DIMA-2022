//
//  ContentView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 19/12/22.
//

import SwiftUI


var name = "Antony"
let score = 257



struct HomeView: View {

    
//    APICaller.shared.getUserProfile {[weak self] result in
//        DispatchQueue.main.async {
//            switch result{
//                case .success(let model):
//                    //self?.updateUI(with: model)
//                    name = model.display_name
//                    break
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    //self?.failedToGetProfile()
//            }
//        }
//    }
    
    var body: some View {
            VStack {
                HStack {
                    Text("Hi \(name)!")
                        .font(TextStyle.homeTitle())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .foregroundColor(.white)
                    Spacer()
                    NavigationLink(destination: LeaderboardView()) {
                        Image(systemName: "list.number")
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                    }
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                    }
                }
                Spacer()
                Image("Profilo1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 250.0, height: 250.0)
                    .clipShape(Circle())
                Spacer()
                Text("Your highscore:")
                    .font(TextStyle.scoreTitle())
                    .foregroundColor(Color("Green"))
                    .padding(.bottom)
                Text(String(score))
                    .font(TextStyle.score())
                    .foregroundColor(Color("Green"))
                    .padding(.bottom, 40.0)
                NavigationLink(destination: GameView()) {
                    Image("GreenPlay")
                        .resizable()
                        .frame(width: 100.0, height: 100.0)
                }
            }
            .background(
                RadialGradient(gradient: Gradient(colors: [Color("Green"), Color("Black")]),
                               center: UnitPoint(x: 0.50, y: 0.35),
                               startRadius: 20,
                               endRadius: 280)
                
            )
            .navigationTitle("Home")
            .foregroundColor(.white)
    }
}
    

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
