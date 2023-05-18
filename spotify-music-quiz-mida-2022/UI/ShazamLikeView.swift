import SwiftUI

struct ShazamLikeView: View {
    @State private var isTextFieldFocused = true
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("SpotifyLogoBlack")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .overlay(
                    ZStack {
                        Circle()
                            .stroke(Color.green, lineWidth: 50)
                            .scaleEffect(isTextFieldFocused ? 1.2 : 1.0)
                            .opacity(isTextFieldFocused ? 1 : 0)
                            .animation(.easeInOut(duration: 1.5), value: true)
                        
                        Circle()
                            .stroke(Color.green, lineWidth: 30)
                            .scaleEffect(isTextFieldFocused ? 1.4 : 1.0)
                            .opacity(isTextFieldFocused ? 0.7 : 0)
                            .animation(.easeInOut(duration: 2.0), value: true)
                    }
                )
        }
    }
}
