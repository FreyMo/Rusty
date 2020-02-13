FROM rust:latest as build

# musl and unknown linux target
RUN apt-get update
RUN apt-get install musl-tools -y
RUN rustup target add x86_64-unknown-linux-musl

WORKDIR /app

COPY . .

RUN RUSTFLAGS=-Clinker=musl-gcc cargo build --release --target=x86_64-unknown-linux-musl --target-dir /out

# FROM alpine:latest as release
FROM scratch as release

COPY --from=build /out/x86_64-unknown-linux-musl/release/rusty /usr/local/bin/

CMD ["rusty"]
