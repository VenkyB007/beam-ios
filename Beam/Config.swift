import UIKit

enum Config {
    /// The web app. Since 1.9 beam. runs on the always-on server (AWS Lightsail), not the laptop.
    static let radioURL = URL(string: "https://beam.nikolatesla.co.in")!
    /// Where the app opens. (Until 1.8 a first launch visited kacheri. once so its page could hop
    /// the phone's library to beam.; kacheri. is gone now, so the app opens beam. directly.)
    static var startURL: URL { radioURL }
    /// Passport: Google sign-in hands the session back to the app through it (SignInHandoff).
    static let authURL = URL(string: "https://auth.nikolatesla.co.in")!
    /// Sign-in and the radio live under this domain; everything else opens outside the app.
    static let inAppDomain = "nikolatesla.co.in"
    /// Passport's app id for the handoff, and the scheme it sends the code back on (ridewave://auth?code=…).
    static let handoffApp = "ridewave"
    static let handoffScheme = "ridewave"

    /// Put the song and real buttons on the lock screen from the page's reports
    /// (window.RideWaveApp.playback → NowPlaying). If WebKit's own Media Session support
    /// already does this and the two fight over the lock screen, turn it off.
    static let nativeNowPlaying = true

    /// Holo, the default look, until the page reports its own (WebViewController.applyBars).
    static let background = UIColor(red: 0x08 / 255.0, green: 0x08 / 255.0, blue: 0x0B / 255.0, alpha: 1)
    /// Beam's headlamp amber.
    static let accent = UIColor(red: 0xFF / 255.0, green: 0xB5 / 255.0, blue: 0x47 / 255.0, alpha: 1)

    static var version: String { Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0" }
    static var build: Int { Int(Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "") ?? 0 }
}
