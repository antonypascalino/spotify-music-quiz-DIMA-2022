//
//  CustomAlert.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 25/06/23.
//

import SwiftUI

struct CustomAlert: View {
    
    let message = "Do you wanna leave the game?"
    @Binding var showAlert : Bool
    @StateObject var gameManager = GameManager.shared
    
    var body: some View {
        VStack(spacing: 30) {
            Text(message)
                .foregroundColor(.white)
                .font(TextStyle.GothamBlack(20))
            HStack(spacing: 20) {
                Button {
                    showAlert = false
                    gameManager.resumeTimer()
                } label: {
                    Text("No")
                        .foregroundColor(Color("Black"))
                        .font(TextStyle.LoginInputTitle())
                        
                }
                .frame(width: 100.0, height: 60.0)
                .background(Color("Green"))
                .foregroundColor(Color("Black"))
                .cornerRadius(50.0)
                
                NavigationLink {
                    ContentView()
                } label: {
                    Text("Yes")
                        .foregroundColor(Color("Black"))
                        .font(TextStyle.LoginInputTitle())
                }
                .frame(width: 100.0, height: 60.0)
                .background(Color("Green"))
                .foregroundColor(Color("Black"))
                .cornerRadius(100.0)
                .simultaneousGesture(TapGesture().onEnded {
                    print("Start tap gesture")
                    AudioPlayer.shared.stop()
//                    gameManager.gameOver()
                    gameManager.restartGame = true
                    gameManager.resumeTimer()
                    print("End tap gesture")
                })
            }
        }
        .frame(width: 350, height: 200)
        .background(Color("Black"))
        .cornerRadius(40)
        .overlay(
            RoundedRectangle(cornerRadius: 40)
                .stroke(Color("Green"), lineWidth: 4)
        )
        
    }
}

struct CustomAlert_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var showAlert = true
        
        CustomAlert(showAlert: $showAlert)
    }
}
