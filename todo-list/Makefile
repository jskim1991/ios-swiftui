PROJECT := todo-list.xcodeproj
SCHEME := todo-list
DESTINATION := platform=iOS Simulator,name=iPhone 17 Pro

.PHONY: test build clean

test:
	xcodebuild test -project $(PROJECT) -scheme $(SCHEME) -destination '$(DESTINATION)'

build:
	xcodebuild build -project $(PROJECT) -scheme $(SCHEME) -destination '$(DESTINATION)'

clean:
	xcodebuild clean -project $(PROJECT) -scheme $(SCHEME)
