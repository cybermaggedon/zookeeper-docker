
REPOSITORY=cybermaggedon/zookeeper
VERSION=$(shell git describe | sed 's/^v//')
ZOOKEEPER_VERSION=3.8.1
DOCKER=docker
URL=http://apache.mirror.anlx.net/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz

SUDO=
BUILD_ARGS=--build-arg ZOOKEEPER_VERSION=${ZOOKEEPER_VERSION}

all: zookeeper-${ZOOKEEPER_VERSION}.tar.gz
	${SUDO} ${DOCKER} build ${BUILD_ARGS} -t ${REPOSITORY}:${VERSION} .
	${SUDO} ${DOCKER} tag ${REPOSITORY}:${VERSION} ${REPOSITORY}:latest

# FIXME: May not be the right mirror for you.
zookeeper-${ZOOKEEPER_VERSION}.tar.gz:
	wget -q -O $@ ${URL}

push:
	${SUDO} ${DOCKER} push ${REPOSITORY}:${VERSION}
	${SUDO} ${DOCKER} push ${REPOSITORY}:latest

# Continuous deployment support
BRANCH=master
FILE=zookeeper-version
REPO=git@github.com:trustnetworks/gaffer

tools: phony
	if [ ! -d tools ]; then \
		git clone git@github.com:trustnetworks/cd-tools tools; \
	fi; \
	(cd tools; git pull)

phony:

bump-version: tools
	tools/bump-version

update-cluster-config: tools
	tools/update-version-file ${BRANCH} ${VERSION} ${FILE} ${REPO}

