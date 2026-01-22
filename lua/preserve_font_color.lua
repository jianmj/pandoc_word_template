function Span(el)
  -- 辅助：解析颜色字符串为 6 位大写十六进制（不带 #），支持颜色名、#hex、rgb()/rgba()
  local function parse_color(s)
    if not s then return nil end
    s = s:gsub("%s+", "")
    local lower = s:lower()

    local named = {
      red = "FF0000", blue = "0000FF", green = "008000",
      yellow = "FFFF00", orange = "FFA500", purple = "800080",
      black = "000000", white = "FFFFFF"
    }
    if named[lower] then return named[lower] end

    -- 6 位 hex (#aabbcc 或 aabbcc)
    local hex = s:match("#?(%x%x%x%x%x%x)")
    if hex then return hex:upper() end

    -- rgb(r,g,b)
    local r,g,b = s:match("rgb%((%d+),%s*(%d+),%s*(%d+)%)")
    if r and g and b then
      local function h(n) return string.format("%02X", tonumber(n) or 0) end
      return h(r)..h(g)..h(b)
    end

    -- rgba(r,g,b,a) -> 合成到白色背景上
    local ra,ga,ba,aa = s:match("rgba%((%d+),%s*(%d+),%s*(%d+),%s*([%d%.]+)%)")
    if ra and ga and ba and aa then
      local R = tonumber(ra) or 0
      local G = tonumber(ga) or 0
      local B = tonumber(ba) or 0
      local A = tonumber(aa) or 1
      if A < 0 then A = 0 end
      if A > 1 then A = 1 end
      local function comp(c)
        local v = math.floor((A * c + (1 - A) * 255) + 0.5)
        if v < 0 then v = 0 end
        if v > 255 then v = 255 end
        return string.format("%02X", v)
      end
      return comp(R)..comp(G)..comp(B)
    end

    return nil
  end

  if el.attributes.style then
    local style = el.attributes.style

    -- 将 style 分解为属性表，避免 'background-color' 包含 'color' 导致错误匹配
    local props = {}
    for k, v in style:gmatch("([%w%-]+)%s*:%s*([^;]+)") do
      local key = string.lower(k:gsub("^%s*(.-)%s*$", "%1"))
      local val = v:gsub("^%s*(.-)%s*$", "%1")
      props[key] = val
    end

    local text_color_raw = props["color"]
    local bg_color_raw = props["background-color"] or props["background"]

    local text_hex = parse_color(text_color_raw)
    local bg_hex = parse_color(bg_color_raw)

    if text_hex or bg_hex then
      local result = {}
      local open = '<w:r><w:rPr>'
      if text_hex then
        open = open .. '<w:color w:val="' .. text_hex .. '"/>'
      end
      if bg_hex then
        open = open .. '<w:shd w:val="clear" w:color="auto" w:fill="' .. bg_hex .. '"/>'
      end
      open = open .. '</w:rPr><w:t>'

      table.insert(result, pandoc.RawInline('openxml', open))
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