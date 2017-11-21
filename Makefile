build:
	swift build -c release -Xswiftc -static-stdlib

install: build
	cp ./.build/x86_64-apple-macosx10.10/release/TrashCLI /usr/local/bin/trash

test:
	@swift test

.PHONY: build install test
