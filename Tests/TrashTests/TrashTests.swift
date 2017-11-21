import Foundation
import XCTest
import Trash

class TrashTests: XCTestCase {
    private var path: String!

    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        path = NSTemporaryDirectory()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Tests
    func testRecyclingNotFound() {
        let localPath = path + "missing_test.file"

        /// Ensure the file does not exist
        XCTAssertFalse(FileManager.default.fileExists(atPath: localPath))

        /// Check that Trash throws when files are not found
        XCTAssertThrowsError(try Trash.recycle([URL.init(fileURLWithPath: localPath)]))
    }

    func testRecyclingSuccess() {
        let localPath = path + "test.file"
        FileManager.default.createFile(atPath: localPath, contents: nil)

        /// Check if test file was created
        XCTAssertTrue(FileManager.default.fileExists(atPath: localPath))

        /// Recycle test file
        XCTAssertNoThrow(try Trash.recycle([URL.init(fileURLWithPath: localPath)]))

        /// Check if the file was removed
        XCTAssertFalse(FileManager.default.fileExists(atPath: localPath))
    }
}
