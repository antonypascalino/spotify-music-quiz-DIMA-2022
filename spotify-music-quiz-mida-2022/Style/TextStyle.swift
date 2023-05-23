//
//  TextStyle.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 10/03/23.
//

import Foundation
import SwiftUI

    
struct TextStyle {
    static func homeTitle() -> Font {
        return Font.custom("Gotham-Black", size: 35)
    }
    
    static func scoreTitle() -> Font {
        return Font.custom("Gotham-Black", size: 30)
    }
    
    static func score(_ score: CGFloat) -> Font {
        return Font.custom("Gotham-Black", size: score)
    }
    
    static func LoginTitle() -> Font {
        return Font.custom("Gotham-Black", size: 90)
    }
    
    static func LoginSubtitle() -> Font {
        return Font.custom("Gotham-Black", size: 45)
    }
    
    static func LoginElement() -> Font {
        return Font.custom("Gotham-Bold", size: 30)
    }
    
    static func LoginInputTitle() -> Font {
        return Font.custom("Gotham-Bold", size: 22)
    }
    
    static func LoginInput() -> Font {
        return Font.custom("Gotham-BookItalic", size: 40)
    }
    
    static func leaderboardItem() -> Font {
        return Font.custom("Gotham-light", size: 15)
    }
    
    static func answer() -> Font {
        return Font.custom("Gotham-Black", size: 25)
    }
    
    static func time() -> Font {
        return Font.custom("Gotham-Black", size: 15)
    }
    
    static func boldItalic(_ size : CGFloat) -> Font {
        return Font.custom("Gotham-BoldItalic", size: size)
    }
    
    static func blackItalic(_ size : CGFloat) -> Font {
        return Font.custom("Gotham-BlackItalic", size: size)
    }
}
