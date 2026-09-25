FROM ubuntu:22.04 AS build-env

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/usr/local/flutter/bin:${PATH}"
ENV TAR_OPTIONS="--no-same-owner"

RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/flutter/flutter.git -b stable /usr/local/flutter
RUN flutter config --no-analytics

WORKDIR /app
COPY . .

RUN flutter pub get --no-example
RUN flutter build web --release

FROM nginx:alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
