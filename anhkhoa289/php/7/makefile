build:
	docker buildx build \
		--load \
		-f dockerfile.sample \
		-t anhkhoa289/php:7.4-sample \
		.

run:
	docker run --rm -p 8000:80 anhkhoa289/php:7.4-sample
