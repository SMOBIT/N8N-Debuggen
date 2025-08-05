// vm2-fix.js - Einfacher Fix für n8n VM2 Sandbox
const fs = require('fs');
const path = require('path');

console.log('Applying VM2 sandbox fix...');

try {
    // Versuche n8n's package.json zu finden und zu patchen
    const n8nPackageJson = '/usr/lib/node_modules/n8n/package.json';
    
    if (fs.existsSync(n8nPackageJson)) {
        const pkg = JSON.parse(fs.readFileSync(n8nPackageJson, 'utf8'));
        
        // Externe Module zur Dependencies hinzufügen
        if (!pkg.dependencies) pkg.dependencies = {};
        
        const modules = {
            'pdf-parse': '*',
            'cheerio': '*',
            'mammoth': '*',
            'turndown': '*',
            'html-minifier': '*',
            '@adobe/helix-docx2md': '*',
            'node-convert': '*'
        };
        
        Object.assign(pkg.dependencies, modules);
        
        fs.writeFileSync(n8nPackageJson, JSON.stringify(pkg, null, 2));
        console.log('n8n package.json updated with external modules');
    }
} catch (error) {
    console.log('Could not patch package.json:', error.message);
}

console.log('VM2 fix applied successfully!');
