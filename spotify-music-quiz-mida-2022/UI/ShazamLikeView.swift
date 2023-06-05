import SwiftUI

struct ShazamLikeView: View {
    
    @State private var animating = true

    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color("Green"))
                .frame(width: 180, height: 180)
                .scaleEffect(animating ? 3 : 1.0)
                .opacity(0.2)

            Circle()
                .foregroundColor(Color("Green"))
                .frame(width: 180, height: 180)
                .scaleEffect(animating ? 2 : 1.0)
                .opacity(0.4)
            
            Circle()
                .foregroundColor(Color("Green"))
                .frame(width: 180.0, height: 180.0)
                .scaleEffect(animating ? 1.5 : 1.0)
                .opacity(0.6)
            
            Circle()
                .frame(width: 200, height: 200)
                .foregroundColor(.black)
            
            Image("SpotifyLogoGreen")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 300)
        }
        .onAppear {
            withAnimation(Animation.easeIn(duration: 1).repeatForever()) {
                animating.toggle()
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct ShazamLikeView_Preview: PreviewProvider {
    
    static var previews: some View {
        ShazamLikeView()
            .background(Color("Black"))
    }
}

