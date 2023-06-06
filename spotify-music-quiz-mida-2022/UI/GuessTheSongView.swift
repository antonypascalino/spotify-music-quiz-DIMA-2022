import SwiftUI
import AVKit

struct GuessTheSongView: View {
    
    let correctAnswer : String
    @State var guessedTitle = ""
    @State var isCorrect = false
    
    @EnvironmentObject var gameManager : GameManager
    
//    let answerSelected = true
    var body: some View {
        
        VStack(alignment: .leading, spacing: 3) {
            
            if (gameManager.answerSelected) {
                HStack {
                    AsyncImage(url: URL(string: (gameManager.currentQuestion?.albumImage!)!)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 270, height: 270)
                            .offset(y: -20)
                            .shadow(color: Color(isCorrect ? "Green" : "Red"), radius: 40)
                        
                    } placeholder: {
                        ShazamLikeView()
                    }
                }
                .frame(maxWidth: .infinity)
            } else {
                ShazamLikeView()
            }
            HStack {
                let guessAuthor = gameManager.currentQuestion?.author.name == gameManager.currentQuestion?.correctAnswer
                TextField("",text: $guessedTitle)
                    .placeholder(when: guessedTitle.isEmpty && !gameManager.answerSelected) {
                        Text(guessAuthor ? "_Author..._" : "_Title..._")
                            .font(TextStyle.answer().italic())
                            .foregroundColor(Color.gray)
                            .opacity(0.7)
                    }
                    .placeholder(when: gameManager.answerSelected) {
                        Text(guessAuthor ? gameManager.currentQuestion!.songName! : correctAnswer)
                            .font(TextStyle.answer())
                            .foregroundColor(isCorrect ? Color("Green") : Color("Red"))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                    .onSubmit {
                        checkAnswer()
                        gameManager.selectAnswer(isCorrect)
                        guessedTitle = ""
                    }
                    .font(TextStyle.answer())
                    .foregroundColor(Color("White"))
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .disabled(gameManager.answerSelected)
                
                Button {
                    checkAnswer()
                    gameManager.selectAnswer(isCorrect)
                    guessedTitle = ""
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color("Green"))
                                    .frame(width: 30, height: 30)
                                    .opacity(guessedTitle == "" ? 0 : 1)
                }
                .disabled(gameManager.answerSelected)
            }
            .padding(.leading)
            .frame(width: 370.0)
            
            Text((gameManager.currentQuestion?.author.name)!)
                .font(TextStyle.time())
                .opacity(gameManager.answerSelected ? 1 : 0)
                .foregroundColor(isCorrect ? Color("Green") : Color("Red"))
                .padding([.trailing, .leading])
        }
        .frame(maxWidth: .infinity)
        .onChange(of: gameManager.playerMiss) { newValue in
            guessedTitle = ""
        }
    }

    func checkAnswer() {
        if guessedTitle.compare(correctAnswer, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame || levenshteinDistance(correctAnswer, guessedTitle) <= correctAnswer.count/3 {
            isCorrect = true
        } else {
            isCorrect = false
        }
        
       
    }
    
    func levenshteinDistance(_ str1: String, _ str2: String) -> Int {
        let m = str1.count
        let n = str2.count

        if m == 0 {
            return n
        }

        if n == 0 {
            return m
        }

        var distances = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)

        for i in 0...m {
            distances[i][0] = i
        }

        for j in 0...n {
            distances[0][j] = j
        }

        for i in 1...m {
            for j in 1...n {
                let index1 = str1.index(str1.startIndex, offsetBy: i - 1)
                let index2 = str2.index(str2.startIndex, offsetBy: j - 1)

                let cost = str1[index1] == str2[index2] ? 0 : 1

                distances[i][j] = min(
                    distances[i - 1][j] + 1,           // Deletion
                    distances[i][j - 1] + 1,           // Insertion
                    distances[i - 1][j - 1] + cost     // Substitution
                )
            }
        }

        return distances[m][n]
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct GuessTheSongView_Previews: PreviewProvider {
    static var previews: some View {
        GuessTheSongView(correctAnswer: "Hold On")
            .background(Color("Black"))
            .environmentObject(GameManager())
    }
}
