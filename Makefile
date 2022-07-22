validate-jenkins:
	@curl -sX POST -L --user icub3d:$(shell cat ~/Documents/ssssh/jenkins.marsh.gg-api-token) -F 'jenkinsfile=<Jenkinsfile' https://jenkins.marsh.gg/pipeline-model-converter/validate

update:
	apt-get update -y
	apt-get upgrade -y
	apt-get install -y zip

go-tools: update
	ls ${WORKSPACE}
	cat go-binaries-base | while read PACKAGE; do \
		GOARCH=arm GOARM=7 go install $$PACKAGE ; \
	done
	cat go-binaries-base go-binaries-dev | while read PACKAGE; do \
		go install $$PACKAGE ; \
	done
	ls -alh /go/bin /go/bin/linux_arm

rust-tools: update
	ls ${WORKSPACE}
	apt-get install -y gcc-arm-linux-gnueabihf
	rustup target add armv7-unknown-linux-gnueabihf && \
	mkdir -p /.cargo && \
	echo '[target.armv7-unknown-linux-gnueabihf]\nlinker = "arm-linux-gnueabihf-gcc"' >/.cargo/config.toml
	cargo install --root /tmp/x86_64 $(shell cat rust-binaries-base rust-binaries-dev)
	cargo install --root /tmp/armv7l --target=armv7-unknown-linux-gnueabihf $(shell cat rust-binaries-base)
	ls -alh /tmp/x86_64/bin/ /tmp/armv7l/bin/
	
