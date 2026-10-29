import UIKit
import AVFoundation

final class ViewController: UIViewController, AVAudioPlayerDelegate {
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var playPauseButton: UIButton!
    @IBOutlet private weak var progressSlider: UISlider!
    @IBOutlet private weak var currentTimeLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!

    private var currentIndex = 0
    private var audioPlayer: AVAudioPlayer?
    private var isPlaying = false
    private var progressTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        progressSlider.minimumValue = 0
        progressSlider.value = 0
        loadCurrentTrack(autoplay: false)
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {
            [weak self] _ in self?.updateProgress()
        }
    }

    @IBAction private func previousTapped(_ sender: UIButton) {
        guard !TrackLibrary.tracks.isEmpty else { return }
        currentIndex = (currentIndex - 1 + TrackLibrary.tracks.count) % TrackLibrary.tracks.count
        loadCurrentTrack(autoplay: isPlaying)
    }

    @IBAction private func playPauseTapped(_ sender: UIButton) {
        guard let audioPlayer else { return }
        if audioPlayer.isPlaying {
            audioPlayer.pause()
            isPlaying = false
        } else {
            isPlaying = audioPlayer.play()
        }
        refreshPlayButton()
    }

    @IBAction private func nextTapped(_ sender: UIButton) {
        advanceToNextTrack(autoplay: isPlaying)
    }

    @IBAction private func progressChanged(_ sender: UISlider) {
        guard let audioPlayer else { return }
        audioPlayer.currentTime = TimeInterval(sender.value)
        currentTimeLabel.text = formatTime(audioPlayer.currentTime)
    }

    private func updateProgress() {
        guard let audioPlayer else { return }
        if !progressSlider.isTracking {
            progressSlider.value = Float(audioPlayer.currentTime)
        }
        currentTimeLabel.text = formatTime(audioPlayer.currentTime)
    }

    private func advanceToNextTrack(autoplay: Bool) {
        guard !TrackLibrary.tracks.isEmpty else { return }
        currentIndex = (currentIndex + 1) % TrackLibrary.tracks.count
        loadCurrentTrack(autoplay: autoplay)
    }

    private func loadCurrentTrack(autoplay: Bool) {
        guard !TrackLibrary.tracks.isEmpty else { return }
        let track = TrackLibrary.tracks[currentIndex]
        titleLabel.text = track.title
        artistLabel.text = track.artist
        coverImageView.image = UIImage(named: track.coverImageName)

        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
        progressSlider.value = 0
        progressSlider.maximumValue = 1
        currentTimeLabel.text = "0:00"
        durationLabel.text = "0:00"

        guard let url = Bundle.main.url(forResource: track.fileName, withExtension: "mp3") else {
            refreshPlayButton()
            reportPlaybackError("Missing audio file: \(track.fileName).mp3")
            return
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            player.prepareToPlay()
            audioPlayer = player
            progressSlider.maximumValue = Float(player.duration)
            durationLabel.text = formatTime(player.duration)
            if autoplay { isPlaying = player.play() }
        } catch {
            reportPlaybackError("Cannot load \(track.fileName).mp3: \(error.localizedDescription)")
        }
        refreshPlayButton()
    }

    private func refreshPlayButton() {
        let symbol = isPlaying ? "pause.fill" : "play.fill"
        playPauseButton.setImage(UIImage(systemName: symbol), for: .normal)
        playPauseButton.accessibilityLabel = isPlaying ? "Pause" : "Play"
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let seconds = max(0, Int(time))
        return String(format: "%d:%02d", seconds / 60, seconds % 60)
    }

    private func reportPlaybackError(_ message: String) {
        print("MusicPlayer: \(message)")
        let alert = UIAlertController(title: "Playback unavailable", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        guard player === audioPlayer else { return }
        if flag {
            advanceToNextTrack(autoplay: true)
        } else {
            isPlaying = false
            refreshPlayButton()
        }
    }

    deinit { progressTimer?.invalidate() }
}
