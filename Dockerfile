# STAGE 1: Eine saubere, AKTUELLE Debian-Basis (Debian 12 "Bookworm")
FROM debian:bookworm-slim

# Setze Umgebungsvariablen für eine non-interactive Installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin

# STAGE 2: Installation der Grundvoraussetzungen
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl gnupg \
    python3 python3-pip python3-dev \
    libxml2-dev libxslt1-dev zlib1g-dev \
    pandoc \
    tesseract-ocr tesseract-ocr-deu \
    ghostscript qpdf unpaper \
    default-jre \
    nano wget ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Installiere Node.js 20 LTS
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
 && apt-get install -y --no-install-recommends nodejs

# STAGE 3: User anlegen VOR n8n Installation
RUN useradd --user-group --create-home --shell /bin/false n8n
RUN mkdir -p /home/n8n/.n8n && chown -R n8n:n8n /home/n8n

# STAGE 4: n8n Installation und Konfiguration
# Installiere n8n global
RUN npm install -g n8n@latest

# KRITISCHER FIX: Module in das n8n node_modules Verzeichnis installieren
# UND die VM2-Whitelist erweitern
RUN cd /usr/lib/node_modules/n8n && npm install --production=false \
    cheerio \
    node-convert \
    mammoth \
    html-minifier \
    @adobe/helix-docx2md \
    turndown \
    pdf-parse

# Zusätzlich: Module auch global verfügbar machen
RUN npm install -g --production=false \
    cheerio \
    node-convert \
    mammoth \
    html-minifier \
    @adobe/helix-docx2md \
    turndown \
    pdf-parse

# WICHTIG: n8n VM2 Konfiguration anpassen
# Wir erstellen eine Konfigurationsdatei, die die Module für VM2 freigibt
RUN mkdir -p /home/n8n/.n8n && cat > /home/n8n/.n8n/config.json << 'EOF'
{
  "nodes": {
    "communityPackages": {
      "enabled": true
    }
  },
  "executions": {
    "process": "main"
  },
  "generic": {
    "timezone": "Europe/Berlin"
  }
}
EOF

# VM2 Sandbox Whitelist erweitern - NEUE METHODE
RUN cd /usr/lib/node_modules/n8n && \
    if [ -f "package.json" ]; then \
        node -e "
        const fs = require('fs');
        const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
        if (!pkg.n8n) pkg.n8n = {};
        if (!pkg.n8n.nodeTypes) pkg.n8n.nodeTypes = {};
        if (!pkg.n8n.nodeTypes.external) pkg.n8n.nodeTypes.external = [];
        const modules = ['cheerio', 'node-convert', 'mammoth', 'html-minifier', '@adobe/helix-docx2md', 'turndown', 'pdf-parse'];
        modules.forEach(mod => {
            if (!pkg.n8n.nodeTypes.external.includes(mod)) {
                pkg.n8n.nodeTypes.external.push(mod);
            }
        });
        fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
        "; \
    fi

# Alternative: Symlinks zu den Modulen erstellen
RUN ln -sf /usr/lib/node_modules/pdf-parse /usr/lib/node_modules/n8n/node_modules/pdf-parse || true
RUN ln -sf /usr/lib/node_modules/cheerio /usr/lib/node_modules/n8n/node_modules/cheerio || true
RUN ln -sf /usr/lib/node_modules/mammoth /usr/lib/node_modules/n8n/node_modules/mammoth || true
RUN ln -sf /usr/lib/node_modules/turndown /usr/lib/node_modules/n8n/node_modules/turndown || true
RUN ln -sf /usr/lib/node_modules/html-minifier /usr/lib/node_modules/n8n/node_modules/html-minifier || true

# Berechtigungen setzen
RUN chown -R n8n:n8n /home/n8n/.n8n
RUN chown -R n8n:n8n /usr/lib/node_modules/n8n/node_modules 2>/dev/null || true

# Cache aufräumen
RUN npm cache clean --force

# User wechseln
USER n8n
WORKDIR /home/n8n

# Port freigeben
EXPOSE 5678

# Startkommando
CMD ["n8n"]
