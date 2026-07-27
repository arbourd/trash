import Foundation
import XCTest
@testable import Trash

class TrashTests: XCTestCase {
    private var directory: URL!

    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        directory = URL(fileURLWithPath: NSTemporaryDirectory())
    }

    // MARK: - Helpers

    // Creates an empty file under the test's temp directory and returns its path.
    private func makeTestFile(_ name: String) -> String {
        let path = directory.appendingPathComponent(name).path
        FileManager.default.createFile(atPath: path, contents: nil)
        XCTAssertTrue(FileManager.default.fileExists(atPath: path))
        return path
    }

    // MARK: - Trash.put tests

    func testTrashNotFound() {
        let paths = [directory.appendingPathComponent("missing_test.file").path]
        XCTAssertFalse(FileManager.default.fileExists(atPath: paths[0]))

        XCTAssertThrowsError(try Trash.put(paths)) { error in
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, NSCocoaErrorDomain)
            XCTAssertEqual(nsError.code, NSFileNoSuchFileError)
        }
    }

    func testTrashSuccess() {
        let path = makeTestFile("test.file")

        XCTAssertNoThrow(try Trash.put([path]))
        XCTAssertFalse(FileManager.default.fileExists(atPath: path))
    }

    func testTrashManySuccess() {
        let paths = (1...3).map { makeTestFile("test\($0).file") }

        XCTAssertNoThrow(try Trash.put(paths))

        for path in paths {
            XCTAssertFalse(FileManager.default.fileExists(atPath: path))
        }
    }

    // MARK: - CLI tests

    func testCLINoArgs() {
        let result = CLI.run([])
        XCTAssertTrue(result.output.hasPrefix("Usage: trash"))
        XCTAssertEqual(result.exitCode, 0)
    }

    func testCLIHelp() {
        for flag in ["-h", "--help"] {
            let result = CLI.run([flag])
            XCTAssertTrue(result.output.hasPrefix("Usage: trash"))
            XCTAssertEqual(result.exitCode, 0)
        }
    }

    func testCLIVersion() {
        for flag in ["-v", "--version"] {
            let result = CLI.run([flag])
            XCTAssertTrue(result.output.hasPrefix("trash, version "))
            XCTAssertEqual(result.exitCode, 0)
        }
    }

    func testCLITrashSuccess() {
        let path = makeTestFile("cli_test.file")

        let result = CLI.run([path])
        XCTAssertEqual(result.output, "")
        XCTAssertEqual(result.exitCode, 0)
        XCTAssertFalse(FileManager.default.fileExists(atPath: path))
    }

    func testCLITrashNotFound() {
        let path = directory.appendingPathComponent("cli_missing.file").path

        let result = CLI.run([path])
        XCTAssertFalse(result.output.isEmpty)
        XCTAssertEqual(result.exitCode, 1)
    }
}
