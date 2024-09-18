# Use an Alpine base image (commonly used for its small size)
FROM alpine:3.12

# Install a package (for demonstration purposes)
RUN apk add --no-cache curl

# Expose an unnecessary port (bad practice)
EXPOSE 8080

# Leaked credentials (oops!)
ENV API_KEY=supersecretapikey

# Copy your application code (replace this with your actual app)
COPY myapp /app

# Set the entry point (running as root—another no-no!)
ENTRYPOINT ["/app/myapp"]
