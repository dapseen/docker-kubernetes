BASE_PATH="${GOPATH}/src"
mkdir -p ${BASE_PATH}
export IMPORT_PATH="${BASE_PATH}/${BITBUCKET_REPO_SLUG}"
ln -s ${PWD} ${IMPORT_PATH}
echo ${PWD}
cd ${IMPORT_PATH}
apk update && apk add --no-cache git \
    curl \
    && curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh \
    && go get -d -u github.com/golang/dep \
    && apk add --update bash make gcc musl-dev \
    && dep ensure 