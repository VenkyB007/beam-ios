import Foundation
import WebKit

/// Songs the page saves (public/js/actions.js: an `<a download>` click on /api/download/:id).
/// WebKit hands the transfer to us (WKDownload) and the file lands in the app's Documents
/// folder, which the Files app shows as "On My iPhone → Beam" (UIFileSharingEnabled +
/// LSSupportsOpeningDocumentsInPlace in Info.plist). No picker per song, so a whole playlist
/// can come down in one go, the way Android's DownloadManager fills Music/Beam.
final class Downloads: NSObject, WKDownloadDelegate {

    /// A note for the page's audio log (window.__rwNative("log:…")).
    var note: ((String) -> Void)?

    private var files: [ObjectIdentifier: URL] = [:]

    static var folder: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func download(_ download: WKDownload, decideDestinationUsing response: URLResponse, suggestedFilename: String,
                  completionHandler: @escaping (URL?) -> Void) {
        let dir = Self.folder
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        // "Artist - Title.m4a" from the server; a second copy of the same song gets " 2", " 3"…
        // because WebKit refuses to overwrite.
        let name = suggestedFilename.isEmpty ? "song.m4a" : suggestedFilename
        let base = (name as NSString).deletingPathExtension
        let ext = (name as NSString).pathExtension
        var url = dir.appendingPathComponent(name)
        var n = 2
        while FileManager.default.fileExists(atPath: url.path) {
            url = dir.appendingPathComponent(ext.isEmpty ? "\(base) \(n)" : "\(base) \(n).\(ext)")
            n += 1
        }
        files[ObjectIdentifier(download)] = url
        completionHandler(url)
    }

    func downloadDidFinish(_ download: WKDownload) {
        let url = files.removeValue(forKey: ObjectIdentifier(download))
        note?("download saved \(url?.lastPathComponent ?? "?")")
    }

    func download(_ download: WKDownload, didFailWithError error: Error, resumeData: Data?) {
        if let url = files.removeValue(forKey: ObjectIdentifier(download)) {
            try? FileManager.default.removeItem(at: url) // a half file would look like a song
        }
        note?("download failed \(error.localizedDescription)")
    }
}
