import SwiftUI
import AVKit

struct GuessTheSongView: View {
    
    @Binding var userAnswer : String
    @Binding var isShowingGuessView: Bool

    
    var body: some View {
        
        

        ZStack {
            
                
           
            
            VStack {
                Spacer()

                ShazamLikeView()
                    .frame(width: 100, height: 100)
                
                Spacer()
                
                TextField("Insert the title", text: $userAnswer, onCommit: {
                    // ...
                    print("Title: \(userAnswer)")
                })
                .font(.headline)
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .onTapGesture {
                    isShowingGuessView = false
                }
                .keyboardType(.default)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                Spacer()
            }
            
            
        }
        
    }
    

}
