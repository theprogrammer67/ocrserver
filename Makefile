.PHONY: build run stop clean

build:
	docker build -t ocrserver:latest .

run:
	docker run --rm --name ocrserver -d -p 7080:7080 ocrserver:latest

stop:
	docker stop ocrserver

clean:
	docker rm ocrserver
