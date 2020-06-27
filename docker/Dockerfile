FROM debian:10-slim

RUN apt-get update && apt-get install -y --no-install-recommends ruby fontforge-nox potrace bdfresize patch make && rm -rf /var/lib/apt/lists/*

WORKDIR /app

CMD ["make"]
