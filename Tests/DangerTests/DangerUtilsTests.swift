    func testFileDiffWhenDiffIsValid() {
        let executor = FakeShellExecutor()
        executor.output = validDiff

        let dangerUtils = DangerUtils(fileMap: [:], shellExecutor: executor)
        let diff = dangerUtils.diff(forFile: "file", sourceBranch: "master")

        guard case let .success(fileDiff) = diff else {
            XCTFail("Expected success, got \(diff)")
            return
        }

        XCTAssertEqual(fileDiff, FileDiff(parsedHeader: .init(filePath: ".swiftpm/xcode/package.xcworkspace/contents.xcworkspacedata", change: .created), hunks: [
            .init(oldLineStart: 0, oldLineSpan: 0, newLineStart: 1, newLineSpan: 7, lines: [
                FileDiff.Line(text: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>", changeType: .added),
                FileDiff.Line(text: "<Workspace", changeType: .added),
                FileDiff.Line(text: "   version = \"1.0\">", changeType: .added),
                FileDiff.Line(text: "   <FileRef", changeType: .added),
                FileDiff.Line(text: "      location = \"self:\">", changeType: .added),
                FileDiff.Line(text: "   </FileRef>", changeType: .added),
                FileDiff.Line(text: "</Workspace>", changeType: .added),
            ]),
        ]))
    }


    private var validDiff: String {
        """
        diff --git a/.swiftpm/xcode/package.xcworkspace/contents.xcworkspacedata b/.swiftpm/xcode/package.xcworkspace/contents.xcworkspacedata
        new file mode 100644
        index 0000000..919434a
        --- /dev/null
        +++ b/.swiftpm/xcode/package.xcworkspace/contents.xcworkspacedata
        @@ -0,0 +1,7 @@
        +<?xml version="1.0" encoding="UTF-8"?>
        +<Workspace
        +   version = "1.0">
        +   <FileRef
        +      location = "self:">
        +   </FileRef>
        +</Workspace>
        """
    }