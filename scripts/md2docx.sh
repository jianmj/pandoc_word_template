pandoc input.md -t html | \
    pandoc -f html -o output.docx \
    --reference-doc template_标题不编号-列表第二行顶格.docx \
    --lua-filter markdown-to-docx.lua