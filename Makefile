export PATH := /usr/local/go/bin:${HOME}/.cargo/bin:${PATH}

all: init go-tools copy-go-tools rust-tools copy-rust-tools zip-files

init:
	apt-get install -y wget build-essential pkg-config libsecret-1-dev gcc-arm-linux-gnueabihf libssl-dev zip
	wget https://go.dev/dl/go1.21.2.linux-amd64.tar.gz
	tar -xzf go1.21.2.linux-amd64.tar.gz
	mv go /usr/local
	rm go1.21.2.linux-amd64.tar.gz
	wget -O- https://sh.rustup.rs | sh -s -- -y
	rustup target add armv7-unknown-linux-gnueabihf

go-tools: docker-credential-helpers
	cat go-binaries-base | while read PACKAGE; do \
		GOARCH=arm GOARM=7 go install $$PACKAGE ; \
	done
	cat go-binaries-base go-binaries-dev | while read PACKAGE; do \
		go install $$PACKAGE ; \
	done

docker-credential-helpers:
	git clone https://github.com/docker/docker-credential-helpers
	cd docker-credential-helpers && make secretservice && cp bin/build/docker-credential-secretservice ${HOME}/go/bin/

copy-go-tools:
	mkdir -p dist/cli-tools/x86_64 dist/cli-tools/armv7l
	cp ${HOME}/go/bin/linux_arm/* dist/cli-tools/armv7l
	rm -rf ${HOME}/go/bin/linux_arm
	cp ${HOME}/go/bin/* dist/cli-tools/x86_64

rust-tools:
	echo '[target.armv7-unknown-linux-gnueabihf]\nlinker = "arm-linux-gnueabihf-gcc"' > ${HOME}/.cargo/config.toml
	cargo install --root /tmp/x86_64 $(shell cat rust-binaries-base rust-binaries-dev)
	cargo install --root /tmp/armv7l --target=armv7-unknown-linux-gnueabihf $(shell cat rust-binaries-base)

copy-rust-tools:
	mkdir -p dist/cli-tools/x86_64 dist/cli-tools/armv7l
	cp /tmp/x86_64/bin/* dist/cli-tools/x86_64
	cp /tmp/armv7l/bin/* dist/cli-tools/armv7l

spark:
	wget https://raw.githubusercontent.com/holman/spark/master/spark
	chmod +x spark
	cp spark dist/cli-tools/x86_64/spark
	cp spark dist/cli-tools/armv7l/spark
	rm spark

zip-files: spark
	zip -j dist/cli-tools.x86_64.zip dist/cli-tools/x86_64/*
	sha512sum dist/cli-tools.x86_64.zip > dist/cli-tools.x86_64.zip.sha512
	zip -j dist/cli-tools.armv7l.zip dist/cli-tools/armv7l/*
	sha512sum dist/cli-tools.armv7l.zip > dist/cli-tools.armv7l.zip.sha512
	rm -rf dist/cli-tools
