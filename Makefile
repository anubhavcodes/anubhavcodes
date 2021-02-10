TAG ?= latest
PROJECT = anubhavcodes/anubhavcodes

image:
	git submodule init && git submodule update
	docker image build -t ${PROJECT}:${TAG} .

push:
	docker image push ${PROJECT}:${TAG}

preview: image
	docker container run --rm --publish 8080:80 -v ${PWD}:/srv ${PROJECT}:${TAG}
