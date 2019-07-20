import Foundation
import AppKit

public struct Trash {
    public static func recycle(_ files: [URL]) throws {
        var error: TrashError?
        let loop = CFRunLoopGetCurrent()

        DispatchQueue.main.async {
            NSWorkspace.shared.recycle(files, completionHandler: { _, err in
                if let err = err as NSError? {
                    error = TrashError(reason: err.localizedDescription)
                }

                CFRunLoopStop(loop)
            })
        }
        CFRunLoopRun()

        if error != nil {
            throw error!
        }
    }
}

public struct TrashError: Error {
    public let reason: String
}

extension TrashError: LocalizedError {
    public var errorDescription: String? {
        return NSLocalizedString(self.reason, comment: "")
    }
}
