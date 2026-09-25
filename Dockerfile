FROM ghcr.io/cirrusci/flutter:stable AS build-env

ENV FLUTTER_SUPPRESS_ANALYTICS=true

WORKDIR /app
COPY . .

RUN flutter pub get --no-example
RUN flutter build web --release

FROM nginx:alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
