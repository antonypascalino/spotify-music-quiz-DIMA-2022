import SwiftUI

struct ShazamLikeView: View {
    @State private var isTextFieldFocused = true
    @State private var animating1 = true
    @State private var animating2 = true
    @State private var animating3 = true
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color("Green"))
                .frame(width: 180, height: 180)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1).repeatForever()) {
                        animating1.toggle()
                    }
                }
                .scaleEffect(animating1 ? 3 : 1.0)
                .opacity(0.2)
            
            Circle()
                .foregroundColor(Color("Green"))
                .frame(width: 180, height: 180)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1).repeatForever()) {
                        animating2.toggle()
                    }
                }
                .scaleEffect(animating2 ? 2 : 1.0)
                .opacity(0.4)
                
            Circle()
                .foregroundColor(Color("Green"))
                .frame(width: 180.0, height: 180.0)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1).repeatForever()) {
                        animating3.toggle()
                    }
                }
                .scaleEffect(animating3 ? 1.5 : 1.0)
                .opacity(0.6)
            
            Circle()
                .frame(width: 200, height: 200)
            
            Image("SpotifyLogoGreen")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 300)
        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ShazamLikeView_Preview: PreviewProvider {
    
    static var previews: some View {
        ShazamLikeView()
            .background(Color("Black"))
    }
}

