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
-- For a list ofy fields, see [lunamark.writer.generic].
function M.new(options)
  local options = options or {}
  local TeX = generic.new(options)

  TeX.interblocksep = "\n\n"  -- insensitive to layout

  TeX.containersep = "\n"

  TeX.linebreak = "\\\\"

  TeX.ellipsis = "\\ldots{}"

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
    return {"\\texttt{",TeX.string(s),"}"}
  end

  function TeX.link(lab,src,tit)
    return {"\\href{",TeX.string(src),"}{",lab,"}"}
  end

  function TeX.image(lab,src,tit)
    return {"\\includegraphics{",TeX.string(src),"}"}
  end

  local function listitem(s)
    return {"\\item ",s}
  end

  function TeX.bulletlist(items)
    local buffer = {}
    for _,item in ipairs(items) do
      buffer[#buffer + 1] = listitem(item)
    end
    local contents = util.intersperse(buffer,"\n")
    return {"\\begin{itemize}\n",contents,"\n\\end{itemize}"}
  end

  function TeX.orderedlist(items)
    local buffer = {}
    for _,item in ipairs(items) do
      buffer[#buffer + 1] = listitem(item)
    end
    local contents = util.intersperse(buffer,"\n")
    return {"\\begin{enumerate}\n",contents,"\n\\end{enumerate}"}
  end

  function TeX.emphasis(s)
    return {"\\emph{",s,"}"}
  end

  function TeX.strong(s)
    return {"\\textbf{",s,"}"}
  end

  function TeX.blockquote(s)
    return {"\\begin{quote}\n",s,"\n\\end{quote}"}
  end

  function TeX.verbatim(s)
    return {"\\begin{verbatim}\n",s,"\\end{verbatim}"}
  end

  function TeX.header(s,level)
    local cmd
    if level == 1 then
      cmd = "\\section"
    elseif level == 2 then
      cmd = "\\subsection"
    elseif level == 3 then
      cmd = "\\subsubsection"
    elseif level == 4 then
      cmd = "\\paragraph"
    elseif level == 5 then
      cmd = "\\subparagraph"
    else
      cmd = ""
    end
    return {cmd,"{",s,"}"}
  end

  TeX.hrule = "\\hspace{\\fill}\\rule{.6\\linewidth}{0.4pt}\\hspace{\\fill}"

  function TeX.note(contents)
    return {"\\footnote{",contents,"}"}
  end

  function TeX.definitionlist(items)
    local buffer = {}
    for _,item in ipairs(items) do
      buffer[#buffer + 1] = format("\\item[%s]\n%s",
        item.term, util.intersperse(item.definitions, TeX.interblocksep))
    end
    local contents = util.intersperse(buffer, TeX.containersep)
    return {"\\begin{description}\n",contents,"\n\\end{description}"}
  end

  return TeX
end

return M
