validate-jenkins:
	@curl -sX POST -L --user icub3d:$(shell cat ~/Documents/ssssh/jenkins.marsh.gg-api-token) -F 'jenkinsfile=<Jenkinsfile' https://jenkins.marsh.gg/pipeline-model-converter/validate

update:
	apt-get update -y
	apt-get upgrade -y
	apt-get install -y zip

go-tools: update
	GOARCH=arm GOARM=7 go install $(shell cat go-binaries-base)
	go install $(shell cat go-binaries-base go-binaries-dev)
	ls -alh /go/bin /go/bin/linux_arm

rust-tools: update
	apt-get install -y ggc-arm-linux-gnueabihf
	rustup target add armv7-unknown-linux-gnueabihf && \
	mkdir -p /.cargo && \
	echo '[target.armv7-unknown-linux-gnueabihf]\nlinker = "arm-linux-gnueabihf-gcc"' >/.cargo/config.toml
  cargo install --root /tmp/x86_64 $(shell cat rust-binaries-base rust-binaries-dev)
	cargo install --root /tmp/armv7l --target=armv7-unknown-linux-gnueabihf $(shell cat rust-binaries-base)
  ls -alh /tmp/x864_64/bin/ /tmp/armv7l/bin/
