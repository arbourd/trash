import Foundation
import AppKit

let version = "0.3.7"
let usage = """
Usage: trash [file ...]
"""

public struct Trash {
    public static func put(_ paths: [String]) async throws {
        let urls = paths.map(URL.init(fileURLWithPath:))
        _ = try await NSWorkspace.shared.recycle(urls)
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
    nonisolated(unsafe) static var standardError = FileHandle.standardError

    static func run(_ args: [String]) async -> (output: String, exitCode: Int32) {
        switch args.first {
        case nil:
            return (usage, 0)
        case "-h"?, "--help"?:
            return (usage, 0)
        case "-v"?, "--version"?:
            return ("trash, version " + version, 0)
        default:
            do {
                try await Trash.put(args)
                return ("", 0)
            } catch {
                return (error.localizedDescription, 1)
            }
        }
    }

    static func main() async {
        let args = Array(CommandLine.arguments.dropFirst())
        let result = await run(args)

        if result.exitCode == 0 {
            if !result.output.isEmpty {
                print(result.output)
            }
        } else {
            print(result.output, to: &standardError)
        }
        exit(result.exitCode)
    }
}
