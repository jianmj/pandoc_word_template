pandoc --reference-doc template.docx -s input.md \
    -o output.docx \
    --lua-filter markdown-to-docx.lua