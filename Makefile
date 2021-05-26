.PHONY: help
help: ## show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%s\033[0m|%s\n", $$1, $$2}' \
		| column -t -s '|'

build: fmt ## Build 
	GOOS=windows GOARCH=amd64 go build -ldflags -H=windowsgui -o wsl-notify-send.exe main.go

lint: build ## Build and lint
	golangci-lint run

test: ## Run tests
	richgo test -v ./...

fmt:
	find . -name '*.go' | grep -v vendor | xargs gofmt -s -w

post-create:
	go get -u github.com/kyoh86/richgo

devcontainer: ## (Advanced) Build the devcontainer
	docker build -f ./.devcontainer/Dockerfile ./.devcontainer -t wsl-notify-send-devcontainer

devcontainer-release: ## (Advanced) Run the devcontainer for release
ifdef DEVCONTAINER
	$(error This target can only be run outside of the devcontainer as it mounts files and this fails within a devcontainer. Don't worry all it needs is docker)
endif
	@docker run -v ${PWD}:${PWD} \
		-e BUILD_NUMBER="${BUILD_NUMBER}" \
		-e IS_CI="${IS_CI}" \
		-e IS_PR="${IS_PR}" \
		-e BRANCH="${BRANCH}" \
		-e GITHUB_TOKEN="${GITHUB_TOKEN}" \
		--entrypoint /bin/bash \
		--workdir "${PWD}" \
		wsl-notify-send-devcontainer \
		-c "${PWD}/scripts/ci_release.sh"
