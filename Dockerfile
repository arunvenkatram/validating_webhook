# build stage
FROM golang:1.10-stretch AS build-env
RUN mkdir -p /go/src/github.com/arun/arun-vwh
WORKDIR /go/src/github.com/arun/arun-vwh
RUN go get k8s.io/api/admission/v1beta1 && go get k8s.io/api/core/v1 && go get k8s.io/apimachinery/pkg/apis/meta/v1 &&  go get github.com/golang/glog && go get github.com/google/gofuzz && go get github.com/spf13/pflag && go get github.com/gogo/protobuf/sortkeys && go get github.com/gogo/protobuf/proto
COPY  . .
RUN useradd -u 10001 webhook
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -o arun-whb

FROM scratch
COPY --from=build-env /go/src/github.com/arun/arun-vwh/arun-whb .
COPY --from=build-env /etc/passwd /etc/passwd
USER webhook
ENTRYPOINT ["/arun-whb"]
