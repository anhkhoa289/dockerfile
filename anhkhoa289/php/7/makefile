build:
	docker buildx build \
		--load \
		-f dockerfile.laravel \
		-t anhkhoa289/php:7.4-laravel \
		.

run:
	docker run --rm -p 8000:80 anhkhoa289/php:7.4-laravel
