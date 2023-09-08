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
    func testTrashNotFound() {
        let paths = [path + "missing_test.file"]

        /// Ensure the file does not exist
        XCTAssertFalse(FileManager.default.fileExists(atPath: paths[0]))

        /// Check that Trash throws when files are not found
        XCTAssertThrowsError(try Trash.put(paths))
    }

    func testTrashSuccess() {
        let paths = [path + "test.file"]
        FileManager.default.createFile(atPath: paths[0], contents: nil)

        /// Check if test file was created
        XCTAssertTrue(FileManager.default.fileExists(atPath: paths[0]))

        /// Trash test file
        XCTAssertNoThrow(try Trash.put(paths))

        /// Check if the file was removed
        XCTAssertFalse(FileManager.default.fileExists(atPath: paths[0]))
    }

    func testTrashManySuccess() {
        var paths: [String] = []
        for index in [1, 2, 3] {
            paths.append(String(format: "%stest%d.file", path, index))
        }

        for path in paths {
            FileManager.default.createFile(atPath: path, contents: nil)

            /// Check if test file was created
            XCTAssertTrue(FileManager.default.fileExists(atPath: path))
        }

        /// Trash test files
        XCTAssertNoThrow(try Trash.put(paths))

        for path in paths {
            /// Check if the file was removed
            XCTAssertFalse(FileManager.default.fileExists(atPath: path))
        }
    }
}
