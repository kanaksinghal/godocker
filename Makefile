.PHONY: build
build:
	docker compose build unittest

export FIXUID=$(shell id -u)
export FIXGID=$(shell id -g)
test: build
	docker compose run --rm unittest
	ls -la