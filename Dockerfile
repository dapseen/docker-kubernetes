#slim alpine golang image
#build stage
ARG GO_VERSION=1.12.9
ARG ALPINE_VERSION=3.9

FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION} AS build-stage

LABEL maintainer="Adedapo Ajuwon"

#COPY working directory
WORKDIR /go/src/go-api
COPY . /go/src/go-api


# Install git.
# Git is required for fetching the dependencies.
RUN apk --update add --no-cache ca-certificates\
    git \
    curl \
    && curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh \
    && go get -d -u github.com/golang/dep \
    && apk add --update bash \
    && dep ensure \
    && CGO_ENABLED=0 GOOS=`go env GOHOSTOS` GOARCH=`go env GOHOSTARCH` go build . \
    && rm $GOPATH/bin/dep \
    && apk del wget curl git 


#production stage
FROM scratch

# Add the built binary
COPY --from=build-stage /go/src/go-api .


# Run the application
ENTRYPOINT ["./go-api"]