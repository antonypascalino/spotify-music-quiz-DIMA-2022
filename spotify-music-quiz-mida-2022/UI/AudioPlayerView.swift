import SwiftUI
import AVKit

struct AudioPlayerView: UIViewControllerRepresentable {
    let player: AVPlayer
    let duration: TimeInterval
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.player?.play()
        
        player.addBoundaryTimeObserver(forTimes: [NSValue(time: CMTime(seconds: duration, preferredTimescale: 1))], queue: .main) {
            playerViewController.player?.pause()
        }
        
        return playerViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // No Action
    }
    
}
