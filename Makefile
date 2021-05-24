.PHONY: help
help: ## show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%s\033[0m|%s\n", $$1, $$2}' \
		| column -t -s '|'

build: fmt ## Build devcontainer cli
	GOOS=windows GOARCH=amd64 go build -o wsl-notify-send.exe main.go

lint: build ## Build and lint
	golangci-lint run

test: ## Run tests
	richgo test -v ./...

fmt:
	find . -name '*.go' | grep -v vendor | xargs gofmt -s -w

post-create:
	go get -u github.com/kyoh86/richgo
