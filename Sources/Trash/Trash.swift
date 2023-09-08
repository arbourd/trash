import Foundation
import AppKit

let version = "0.3.6"
let usage = """
Usage: trash [file ...]
"""

public struct Trash {
    public static func put(_ paths: [String]) throws {
        var error: NSError?
        let urls = paths.map(URL.init(fileURLWithPath:))
        let loop = CFRunLoopGetCurrent()

        DispatchQueue.main.async {
            NSWorkspace.shared.recycle(urls, completionHandler: { _, err in
                error = err as NSError?
                CFRunLoopStop(loop)
            })
        }
        CFRunLoopRun()

        if error != nil {
            throw error!
        }
    }
}

extension FileHandle: TextOutputStream {
    public func write(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        self.write(data)
    }
}

@main
struct CLI {
    static var standardError = FileHandle.standardError

    static func main() {
        let args = Array(CommandLine.arguments.dropFirst())

        switch args.first {
        case nil:
            print(usage)
        case "-h"?, "--help"?:
            print(usage)
        case "-v"?, "--version"?:
            print("trash, version " + version)
        default:
            do {
                try Trash.put(args)
                exit(0)
            } catch {
                print(error.localizedDescription, to: &standardError)
                exit(1)
            }
        }
    }
}
