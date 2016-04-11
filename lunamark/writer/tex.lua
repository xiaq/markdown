-- (c) 2009-2011 John MacFarlane. Released under MIT license.
-- See the file LICENSE in the source for details.

--- Generic TeX writer for lunamark.
-- Extends [lunamark.writer.generic].

local M = {}

local util = require("lunamark.util")
local generic = require("lunamark.writer.generic")
local entities = require("lunamark.entities")
local format = string.format

--- Returns a new TeX writer.
-- For a list of fields, see [lunamark.writer.generic].
function M.new(options)
  local options = options or {}
  local TeX = generic.new(options)

  TeX.interblocksep = "\n\n"  -- insensitive to layout

  TeX.containersep = "\n"

  TeX.linebreak = "\\\\"

  TeX.ellipsis = "\\markdownEllipsis "

  TeX.escaped = {
     ["{"] = "\\{",
     ["}"] = "\\}",
     ["$"] = "\\$",
     ["%"] = "\\%",
     ["&"] = "\\&",
     ["_"] = "\\_",
     ["#"] = "\\#",
     ["^"] = "\\^{}",
     ["\\"] = "\\char92{}",
     ["~"] = "\\char126{}",
     ["|"] = "\\char124{}",
     ["["] = "{[}", -- to avoid interpretation as optional argument
     ["]"] = "{]}",
   }

  local str_escaped = {
     ["\226\128\156"] = "``",
     ["\226\128\157"] = "''",
     ["\226\128\152"] = "`",
     ["\226\128\153"] = "'",
     ["\226\128\148"] = "---",
     ["\226\128\147"] = "--",
     ["\194\160"]     = "~",
   }

  local escaper = util.escaper(TeX.escaped, str_escaped)

  TeX.string = escaper

  function TeX.paragraph(s)
    return s
  end

  function TeX.code(s)
    return {"\\markdownCodeSpan{",TeX.string(s),"}"}
  end

  function TeX.link(lab,src,tit)
    return {"\\markdownLink{",TeX.string(lab[1]),"}",
                          "{",TeX.string(src),"}",
                          "{",TeX.string(tit),"}"}
  end

  function TeX.image(lab,src,tit)
    return {"\\markdownImage{",TeX.string(lab[1]),"}",
                           "{",TeX.string(src),"}",
                           "{",TeX.string(tit),"}"}
  end

  local function ulitem(s)
    return {"\\markdownUlItem ",s}
  end

  function TeX.bulletlist(items,tight)
    local buffer = {}
    for _,item in ipairs(items) do
      buffer[#buffer + 1] = ulitem(item)
    end
    local contents = util.intersperse(buffer,"\n")
    if tight then
      return {"\\markdownUlBeginTight\n",contents,"\n\\markdownUlEndTight "}
    else
      return {"\\markdownUlBegin\n",contents,"\n\\markdownUlEnd "}
    end
  end

  local function olitem(s,num)
    if num ~= nil then
      return {"\\markdownOlItemWithNumber{",num,"} ",s}
    else
      return {"\\markdownOlItem ",s}
    end
  end

  function TeX.orderedlist(items,tight,startnum)
    local buffer = {}
    local num = startnum
    for _,item in ipairs(items) do
      buffer[#buffer + 1] = olitem(item,num)
      if num ~= nil then
        num = num + 1
      end
    end
    local contents = util.intersperse(buffer,"\n")
    if tight then
      return {"\\markdownOlBeginTight\n",contents,"\n\\markdownOlEndTight "}
    else
      return {"\\markdownOlBegin\n",contents,"\n\\markdownOlEnd "}
    end
  end

  local function dlitem(term,defs)
      return {"\\markdownDlItem{",term,"}\n",defs}
  end

  function TeX.definitionlist(items,tight)
    local buffer = {}
    for _,item in ipairs(items) do
      buffer[#buffer + 1] = dlitem(item.term,
        util.intersperse(item.definitions, TeX.interblocksep))
    end
    local contents = util.intersperse(buffer, TeX.containersep)
    if tight then
      return {"\\markdownDlBeginTight\n",contents,"\n\\markdownDlEndTight "}
    else
      return {"\\markdownDlBegin\n",contents,"\n\\markdownDlEnd "}
    end
  end

  function TeX.emphasis(s)
    return {"\\markdownEmphasis{",s,"}"}
  end

  function TeX.strong(s)
    return {"\\markdownStrongEmphasis{",s,"}"}
  end

  function TeX.blockquote(s)
    return {"\\markdownBlockQuoteBegin\n",s,"\n\\markdownBlockQuoteEnd "}
  end

  function TeX.verbatim(s)
    return {"\\markdownCodeBlockBegin\n",TeX.string(s),"\\markdownCodeBlockEnd "}
  end

  function TeX.header(s,level)
    local cmd
    if level == 1 then
      cmd = "\\markdownHeaderOne"
    elseif level == 2 then
      cmd = "\\markdownHeaderTwo"
    elseif level == 3 then
      cmd = "\\markdownHeaderThree"
    elseif level == 4 then
      cmd = "\\markdownHeaderFour"
    elseif level == 5 then
      cmd = "\\markdownHeaderFive"
    elseif level == 6 then
      cmd = "\\markdownHeaderSix"
    else
      cmd = ""
    end
    return {cmd,"{",s,"}"}
  end

  TeX.hrule = "\\markdownHorizontalRule "

  function TeX.note(contents)
    return {"\\markdownFootnote{",contents,"}"}
  end

  return TeX
end

return M
