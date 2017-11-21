build:
	swift build -c release -Xswiftc -static-stdlib

test:
	@swift test

.PHONY: build install test
