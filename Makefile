update:
	apt-get update -y
	apt-get upgrade -y
	apt-get install -y zip

go-tools: update
	go install github.com/mikefarah/yq/v4@latest
	go install github.com/go-delve/delve/cmd/dlv@latest
	go install golang.org/x/tools/gopls@latest
	go install github.com/nsf/gocode@latest
	go install github.com/rogpeppe/godef@latest
	go install golang.org/x/tools/cmd/godoc@latest
	go install golang.org/x/tools/cmd/goimports@latest
	go install github.com/cweill/gotests/gotests@latest
	go install github.com/prasmussen/gdrive@latest
	GOARCH=arm GOARM=7 go install github.com/mikefarah/yq/v4@latest
