build:
	swift build --static-swift-stdlib -c release

test:
	@swift test

.PHONY: build test
