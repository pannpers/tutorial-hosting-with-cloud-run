FROM golang as builder

# Copy local code to the container image.
WORKDIR /go/src/github.com/knative/docs/helloworld
COPY . .

# Build the outyet command inside the container.
# (You may fetch or manage dependencies here, either manually or with a tool like "godep".)
RUN CGO_ENABLED=0 GOOS=linux go build -v -o helloworld


# Use a Docker multi-stage build to create a lean production image.
FROM alpine

# Copy the binary to the production image from the builder stage.
COPY --from=builder /go/src/github.com/knative/docs/helloworld/helloworld /helloworld

# Service must listen to $PORT environment variable.
# This default value facilitates local development.
ENV PORT 8080

# Run the web service on container startup.
CMD [ "/helloworld" ]
