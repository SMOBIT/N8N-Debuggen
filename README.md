# Dokumenten-Toolkit mit n8n

Dieses Docker-Image liefert eine umfassende Umgebung zur automatisierten Verarbeitung von Dokumenten (OCR, Konvertierung, PDF-Bearbeitung) und zur Orchestrierung von Workflows mit **n8n**.

---

## Inhaltsverzeichnis

1. [Systemwerkzeuge](#systemwerkzeuge)  
2. [LaTeX & PDF](#latex--pdf)  
3. [OCR](#ocr)  
4. [Office & Java](#office--java)  
5. [Python](#python)  
6. [n8n Workflow-Automatisierung](#n8n-workflow-automatisierung)  
7. [Node.js-Bibliotheken](#nodejs-bibliotheken)  

---

## Systemwerkzeuge
- **pandoc**  
  Universeller Dokumentenkonverter (Markdown ↔ HTML ↔ DOCX ↔ PDF etc.).  
- **curl**  
  Kommandozeilen-Tool zum Abrufen von Webinhalten und APIs.  
- **nano**  
  Einfacher Terminal-Texteditor für schnelle Änderungen.  

---

## LaTeX & PDF
- **texlive-latex-base** & **texlive-fonts-recommended**  
  Grundlegende LaTeX-Distribution für professionelle PDF-Erstellung.  
- **ghostscript**  
  PostScript-/PDF-Verarbeitung (Optimierung, Kompression).  
- **qpdf**  
  Manipulation von PDF-Dateien (Zusammenführen, Aufteilen, Verschlüsseln).  
- **unpaper**  
  Nachbearbeitung gescannter Seiten (Ränder entfernen, Layout glätten).  

---

## OCR
- **tesseract-ocr** & **tesseract-ocr-deu**  
  Open-Source-OCR-Engine zur Texterkennung in Bildern/PDFs, mit deutscher Sprache.  

---

## Office & Java
- **libreoffice** & **libreoffice-java-common**  
  Headless-Konvertierung von Office-Dokumenten (z.B. DOCX → PDF, ODT → DOCX).  
- **default-jre**  
  Java-Laufzeitumgebung für LibreOffice und andere Java-basierte Tools.  

---

## Python
- **python3** & **pip3**  
  Python 3 Interpreter und Paketmanager.  
- **python-docx**  
  Bibliothek zum Erstellen und Bearbeiten von Word-Dokumenten (DOCX) mit Python.  

---

## n8n Workflow-Automatisierung
- **n8n**  
  Open-Source-Plattform für Low-Code-Workflows: verbindet APIs, Skripte und Apps in visuell konfigurierbaren Flows.  

---

## Node.js-Bibliotheken
Alle Bibliotheken werden sowohl global (für n8n) als auch im User-Kontext installiert:

- **cheerio**  
  jQuery-ähnliches Parsen und Manipulieren von HTML auf dem Server.  
- **node-convert**  
  Generische Konvertierung von Dateien (z.B. Dokumente, Bilder).  
- **mammoth**  
  Hochwertige Umwandlung von DOCX in HTML.  
- **html-minifier**  
  Komprimierung und Bereinigung von HTML-Code.  
- **@adobe/helix-docx2md**  
  DOCX → Markdown-Konverter basierend auf Adobe Helix.  
- **turndown**  
  HTML → Markdown-Konverter.  
- **pdf-parse**  
  Extraktion von Text und Metadaten aus PDF-Dateien.  

---
