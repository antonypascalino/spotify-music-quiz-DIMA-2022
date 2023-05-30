import SwiftUI

struct ShazamLikeView: View {
    
    @State private var animating = true
    @Binding var isCorrect: Bool

    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color(isCorrect ? "Green" : "Red"))
                .frame(width: 180, height: 180)
                .scaleEffect(animating ? 3 : 1.0)
                .opacity(0.2)
                .animation(Animation.easeInOut(duration: 1).repeatForever(), value: animating)

            Circle()
                .foregroundColor(Color(isCorrect ? "Green" : "Red"))
                .frame(width: 180, height: 180)
                .scaleEffect(animating ? 2 : 1.0)
                .opacity(0.4)
                .animation(Animation.easeInOut(duration: 1).repeatForever(), value: animating)
            
            Circle()
                .foregroundColor(Color(isCorrect ? "Green" : "Red"))
                .frame(width: 180.0, height: 180.0)
                .scaleEffect(animating ? 1.5 : 1.0)
                .opacity(0.6)
                .animation(Animation.easeInOut(duration: 1).repeatForever(), value: animating)
            
            Circle()
                .frame(width: 200, height: 200)
                .foregroundColor(.black)
            
            Image("SpotifyLogoGreen")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 300)
        }
        .onAppear {
            withAnimation {
                animating.toggle()
            }
        }
        .frame(maxWidth: .infinity)
    }
}

//struct ShazamLikeView_Preview: PreviewProvider {
//    
//    static var previews: some View {
//        
//        let isCorrect = false
//        
//        ShazamLikeView(isCorrect: $isCorrect)
//            .background(Color("Black"))
//    }
//}

