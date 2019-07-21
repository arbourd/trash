import Foundation
import Trash

let version = "0.2.0"
let usage = """
Usage: trash [file ...]
"""

extension FileHandle: TextOutputStream {
    public func write(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        self.write(data)
    }
}

struct CLI {
    static var standardError = FileHandle.standardError

    static func run() {
        let args = CommandLine.arguments.dropFirst()

        switch args.first {
        case nil:
            print(usage)
        case "-h"?, "--help"?:
            print(usage)
        case "-v"?, "--version"?:
            print("trash, version " + version)
        default:
            do {
                let urls = args.map(URL.init(fileURLWithPath:))
                try Trash.recycle(Array(urls))
                exit(0)
            } catch {
                print(error.localizedDescription, to: &standardError)
                exit(1)
            }
        }
    }
}

CLI.run()
