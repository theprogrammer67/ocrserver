.PHONY: build run stop clean push

DOCKER_USER = theprogrammer67
IMAGE_NAME = ocrserver
CONTAINER = ocrserver
TAG = latest
IMAGE = $(DOCKER_USER)/$(IMAGE_NAME):$(TAG)

build:
	docker build -t $(IMAGE) .

push: build
	docker push $(IMAGE)

run:
	docker run --rm --name $(CONTAINER) -p 7080:7080 $(IMAGE)

stop:
	docker stop $(CONTAINER)

clean:
	docker rm $(CONTAINER)

logs:
	docker logs $(CONTAINER)
