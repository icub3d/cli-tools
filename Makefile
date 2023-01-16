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
	sudo apt-get install -y gcc-arm-linux-gnueabihf
	echo '[target.armv7-unknown-linux-gnueabihf]\nlinker = "arm-linux-gnueabihf-gcc"' > ${HOME}/.cargo/config.toml
	cargo install --root /tmp/x86_64 $(shell cat rust-binaries-base rust-binaries-dev)
	cargo install --root /tmp/armv7l --target=armv7-unknown-linux-gnueabihf $(shell cat rust-binaries-base)
	
copy-rust-tools:
	mkdir -p dist/cli-tools/x86_64 dist/cli-tools/armv7l
	cp /tmp/x86_64/bin/* dist/cli-tools/x86_64
	cp /tmp/armv7l/bin/* dist/cli-tools/armv7l

spark:
	curl https://raw.githubusercontent.com/holman/spark/master/spark -o spark
	chmod +x spark
	cp spark dist/cli-tools/x86_64/spark
	cp spark dist/cli-tools/armv7l/spark
	rm spark

zip-files: spark
	zip -j dist/cli-tools.x86_64.zip dist/cli-tools/x86_64/*
	zip -j dist/cli-tools.armv7l.zip dist/cli-tools/armv7l/*
	rm -rf dist/cli-tools
