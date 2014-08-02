all:
	mkdir -p dist/
	buildapp --output dist/plotsvn --load-system plotsvn --asdf-tree ~/quicklisp/ --entry plotsvn::main --compress-core

install:
	cp dist/plotsvn /usr/local/bin/

clean:
	rm -rf dist/
