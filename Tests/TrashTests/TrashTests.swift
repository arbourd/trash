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

    func testTrashNotFound() async throws {
        let paths = [directory.appendingPathComponent("missing_test.file").path]
        XCTAssertFalse(FileManager.default.fileExists(atPath: paths[0]))

        do {
            try await Trash.put(paths)
            XCTFail("expected Trash.put to throw")
        } catch {
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, NSCocoaErrorDomain)
            XCTAssertEqual(nsError.code, NSFileNoSuchFileError)
        }
    }

    func testTrashSuccess() async throws {
        let path = makeTestFile("test.file")

        try await Trash.put([path])
        XCTAssertFalse(FileManager.default.fileExists(atPath: path))
    }

    func testTrashManySuccess() async throws {
        let paths = (1...3).map { makeTestFile("test\($0).file") }

        try await Trash.put(paths)

        for path in paths {
            XCTAssertFalse(FileManager.default.fileExists(atPath: path))
        }
    }

    // MARK: - CLI tests

    func testCLINoArgs() async throws {
        let result = await CLI.run([])
        XCTAssertTrue(result.output.hasPrefix("Usage: trash"))
        XCTAssertEqual(result.exitCode, 0)
    }

    func testCLIHelp() async throws {
        for flag in ["-h", "--help"] {
            let result = await CLI.run([flag])
            XCTAssertTrue(result.output.hasPrefix("Usage: trash"))
            XCTAssertEqual(result.exitCode, 0)
        }
    }

    func testCLIVersion() async throws {
        for flag in ["-v", "--version"] {
            let result = await CLI.run([flag])
            XCTAssertTrue(result.output.hasPrefix("trash, version "))
            XCTAssertEqual(result.exitCode, 0)
        }
    }

    func testCLITrashSuccess() async throws {
        let path = makeTestFile("cli_test.file")

        let result = await CLI.run([path])
        XCTAssertEqual(result.output, "")
        XCTAssertEqual(result.exitCode, 0)
        XCTAssertFalse(FileManager.default.fileExists(atPath: path))
    }

    func testCLITrashNotFound() async throws {
        let path = directory.appendingPathComponent("cli_missing.file").path

        let result = await CLI.run([path])
        XCTAssertFalse(result.output.isEmpty)
        XCTAssertEqual(result.exitCode, 1)
    }
}
