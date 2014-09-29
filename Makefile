all: build test

build:
	@`npm bin`/coffee -c index.coffee

clean:
	rm -rf index.js

test:
	@`npm bin`/coffee test/all.coffee | `npm bin`/tap-min

.PHONY: build clean test
