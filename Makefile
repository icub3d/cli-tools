export PATH := /usr/local/go/bin:${HOME}/.cargo/bin:${PATH}

all: init go-tools copy-go-tools rust-tools copy-rust-tools zip-files

init:
	apt-get install -y wget build-essential pkg-config libsecret-1-dev gcc-arm-linux-gnueabihf libssl-dev zip
	wget https://go.dev/dl/go1.21.6.linux-amd64.tar.gz
	tar -xzf go1.21.6.linux-amd64.tar.gz
	mv go /usr/local
	rm go1.21.6.linux-amd64.tar.gz
	wget -O- https://sh.rustup.rs | sh -s -- -y
	rustup target add armv7-unknown-linux-gnueabihf

go-tools: docker-credential-helpers
	cat go-binaries-dev | while read PACKAGE; do \
		go install $$PACKAGE ; \
	done

docker-credential-helpers:
	git clone https://github.com/docker/docker-credential-helpers
	cd docker-credential-helpers && make secretservice && cp bin/build/docker-credential-secretservice ${HOME}/go/bin/

copy-go-tools:
	mkdir -p dist/cli-tools/x86_64 
	cp ${HOME}/go/bin/* dist/cli-tools/x86_64

rust-tools:
	cargo install --root /tmp/x86_64 $(shell cat rust-binaries-dev)

copy-rust-tools:
	mkdir -p dist/cli-tools/x86_64
	cp /tmp/x86_64/bin/* dist/cli-tools/x86_64

spark:
	wget https://raw.githubusercontent.com/holman/spark/master/spark
	chmod +x spark
	cp spark dist/cli-tools/x86_64/spark
	rm spark

zip-files: spark
	zip -j dist/cli-tools.x86_64.zip dist/cli-tools/x86_64/*
	sha512sum dist/cli-tools.x86_64.zip > dist/cli-tools.x86_64.zip.sha512
	rm -rf dist/cli-tools
