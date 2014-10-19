all: build test

build:
	@`npm bin`/coffee -c index.coffee

clean:
	rm -rf index.js

test:
	@`npm bin`/coffee test/all.coffee | `npm bin`/tap-difflet

coverage: build
	@coffee -c --bare test
	@`npm bin`/browserify -t coverify --bare test/*.js | node | `npm bin`/coverify

.PHONY: build clean test
