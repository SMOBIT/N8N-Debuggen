# STAGE 1: Debian Basis
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin

# STAGE 2: System-Abhängigkeiten installieren
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl gnupg \
    python3 python3-pip python3-dev \
    libxml2-dev libxslt1-dev zlib1g-dev \
    build-essential \
    pandoc \
    tesseract-ocr tesseract-ocr-deu \
    ghostscript qpdf unpaper \
    default-jre \
    nano wget ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Node.js 20 installieren
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
 && apt-get install -y --no-install-recommends nodejs

# STAGE 3: User anlegen
RUN useradd --user-group --create-home --shell /bin/false n8n
RUN mkdir -p /home/n8n/.n8n && chown -R n8n:n8n /home/n8n

# STAGE 4: n8n und Module installieren
# n8n global installieren
RUN npm install -g n8n@latest

# Externe Module DIREKT in n8n's node_modules installieren
RUN cd /usr/lib/node_modules/n8n && npm install \
    pdf-parse \
    cheerio \
    mammoth \
    turndown \
    html-minifier \
    @adobe/helix-docx2md \
    node-convert

# Module auch global installieren (Fallback)
RUN npm install -g \
    pdf-parse \
    cheerio \
    mammoth \
    turndown \
    html-minifier \
    @adobe/helix-docx2md \
    node-convert

# n8n Konfiguration erstellen
RUN mkdir -p /home/n8n/.n8n && echo '{ \
  "nodes": { \
    "communityPackages": { \
      "enabled": true \
    } \
  }, \
  "executions": { \
    "process": "main" \
  } \
}' > /home/n8n/.n8n/config.json

# VM2 Sandbox Fix anwenden
COPY vm2-fix.js /tmp/vm2-fix.js
RUN node /tmp/vm2-fix.js && rm /tmp/vm2-fix.js

# Berechtigungen setzen
RUN chown -R n8n:n8n /home/n8n/.n8n
RUN chown -R n8n:n8n /usr/lib/node_modules/n8n 2>/dev/null || true

# Cache aufräumen
RUN npm cache clean --force

# User wechseln
USER n8n
WORKDIR /home/n8n

EXPOSE 5678
CMD ["n8n"]
