local alert_types = {
  NOTE = "note",
  TIP = "tip",
  IMPORTANT = "important",
  WARNING = "warning",
  CAUTION = "caution",
}

local alert_titles = {
  NOTE = "Note",
  TIP = "Tip",
  IMPORTANT = "Important",
  WARNING = "Warning",
  CAUTION = "Caution",
}

local function marker_type(inline)
  if inline and inline.t == "Str" then
    return inline.text:match("^%[!(%u+)%]$")
  end
  return nil
end

local function drop_leading_space(inlines)
  while #inlines > 0 and (inlines[1].t == "Space" or inlines[1].t == "SoftBreak") do
    table.remove(inlines, 1)
  end
  return inlines
end

function BlockQuote(block)
  local first = block.content[1]
  if not first or first.t ~= "Para" or #first.content == 0 then
    return nil
  end

  local alert = marker_type(first.content[1])
  local class = alert and alert_types[alert]
  if not class then
    return nil
  end

  local remaining_inlines = {}
  for i = 2, #first.content do
    remaining_inlines[#remaining_inlines + 1] = first.content[i]
  end
  remaining_inlines = drop_leading_space(remaining_inlines)

  local content = {}
  content[#content + 1] = pandoc.Div(
    { pandoc.Para({ pandoc.Str(alert_titles[alert]) }) },
    pandoc.Attr("", { "title", "markdown-alert-title" })
  )

  if #remaining_inlines > 0 then
    content[#content + 1] = pandoc.Para(remaining_inlines)
  end

  for i = 2, #block.content do
    content[#content + 1] = block.content[i]
  end

  return pandoc.Div(
    content,
    pandoc.Attr("", { "markdown-alert", class }, { ["data-alert"] = alert })
  )
end
