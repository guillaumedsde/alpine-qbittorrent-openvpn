#!/bin/sh
mkdir -p $HOME/.docker/cli-plugins/
wget -O $HOME/.docker/cli-plugins/docker-buildx $BUILDX_URL
chmod a+x $HOME/.docker/cli-plugins/docker-buildx
"echo -e '{\n  \"experimental\": \"enabled\"\n}' | tee $HOME/.docker/config.json"
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx create --use --driver docker-container --name ${BUILDX_BUILDER} --platform=${CI_JOB_NAME}
docker buildx inspect --bootstrap ${BUILDX_BUILDER}
docker buildx ls
docker login -u "$CI_REGISTRY_USER" -p "$CI_REGISTRY_PASSWORD"
