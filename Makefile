update:
	apt-get update -y
	apt-get upgrade -y
	apt-get install -y zip smbclient libsecret-1-dev

go-tools: update docker-credential-helpers
	cat go-binaries-base | while read PACKAGE; do \
		GOARCH=arm GOARM=7 go install $$PACKAGE ; \
	done
	cat go-binaries-base go-binaries-dev | while read PACKAGE; do \
		go install $$PACKAGE ; \
	done

docker-credential-helpers:
	git clone https://github.com/docker/docker-credential-helpers
	cd docker-credential-helpers && make secretservice && cp bin/docker-credential-secretservice /go/bin/

copy-go-tools:
	mkdir -p ${WORKSPACE}/dist/cli-tools/x86_64 ${WORKSPACE}/dist/cli-tools/armv7l
	cp /go/bin/linux_arm/* ${WORKSPACE}/dist/cli-tools/armv7l
	rm -rf /go/bin/linux_arm
	cp /go/bin/* ${WORKSPACE}/dist/cli-tools/x86_64

rust-tools: update
	apt-get install -y gcc-arm-linux-gnueabihf
	rustup target add armv7-unknown-linux-gnueabihf && \
	mkdir -p /.cargo && \
	echo '[target.armv7-unknown-linux-gnueabihf]\nlinker = "arm-linux-gnueabihf-gcc"' >/.cargo/config.toml
	cargo install --root /tmp/x86_64 $(shell cat rust-binaries-base rust-binaries-dev)
	cargo install --root /tmp/armv7l --target=armv7-unknown-linux-gnueabihf $(shell cat rust-binaries-base)
	
copy-rust-tools:
	mkdir -p ${WORKSPACE}/dist/cli-tools/x86_64 ${WORKSPACE}/dist/cli-tools/armv7l
	cp /tmp/x86_64/bin/* ${WORKSPACE}/dist/cli-tools/x86_64
	cp /tmp/armv7l/bin/* ${WORKSPACE}/dist/cli-tools/armv7l

spark:
	curl https://raw.githubusercontent.com/holman/spark/master/spark -o spark
	chmod +x spark
	cp spark ${WORKSPACE}/dist/cli-tools/x86_64/spark
	cp spark ${WORKSPACE}/dist/cli-tools/armv7l/spark
	rm spark

zip-files: spark
	zip -j ${WORKSPACE}/dist/cli-tools.x86_64.zip ${WORKSPACE}/dist/cli-tools/x86_64/*
	zip -j ${WORKSPACE}/dist/cli-tools.armv7l.zip ${WORKSPACE}/dist/cli-tools/armv7l/*

send-to-samba:
	echo "username=${SAMBA_USERNAME}\npassword=${SAMBA_PASSWORD}\n" >/smbclient.conf
	smbclient -A /smbclient.conf --directory files -c 'put dist/cli-tools.x86_64.zip cli-tools.x86_64.zip' //srv2/documents
	smbclient -A /smbclient.conf --directory files -c 'put dist/cli-tools.armv7l.zip cli-tools.armv7l.zip' //srv2/documents
