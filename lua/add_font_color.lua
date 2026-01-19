function Span(el)
  if el.attributes.style then
    local color = el.attributes.style:match("color:%s*([^;]+)")
    
    if color then
      color = color:gsub("%s+", "")
      
      -- 颜色名称映射
      local colors = {
        red = "FF0000", blue = "0000FF", green = "008000",
        yellow = "FFFF00", orange = "FFA500", purple = "800080"
      }
      
      local hex = colors[color:lower()] or color:gsub("#", "")
      
      -- 构建 DOCX 原始格式
      local result = {}
      table.insert(result, pandoc.RawInline('openxml', 
        '<w:r><w:rPr><w:color w:val="' .. hex .. '"/></w:rPr><w:t>'))
      
      for _, item in ipairs(el.content) do
        table.insert(result, item)
      end
      
      table.insert(result, pandoc.RawInline('openxml', '</w:t></w:r>'))
      
      return result
    end
  end
  
  return el
end

return { Span = Span }