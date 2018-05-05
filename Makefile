MY_DOCKER_IMAGE=hello-world-printer

.PHONY: test

deps:
	pip install -r requirements.txt;
	pip install -r test_requirements.txt

lint:
	flake8 hello_world test

test:
	PYTHONPATH=. py.test --ignore test_ui

run:
	python main.py

docker_build:
	docker build -t $(MY_DOCKER_IMAGE) .

docker_run: docker_build
	docker run \
		--name hello-world-printer-dev \
		-p 5000:5000 \
		-d $(MY_DOCKER_IMAGE)

test_smoke:
	curl --fail 127.0.0.1:5000

USERNAME=justynabkumortester896412
TAG=$(USERNAME)/$(MY_DOCKER_IMAGE)

docker_push: docker_build
	@docker login --username $(USERNAME) --password $${DOCKER_PASSWORD}; \
	docker tag $(MY_DOCKER_IMAGE) $(TAG); \
	docker push $(TAG); \
	docker logout;
