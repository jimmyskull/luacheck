local color = require "ansicolors"

local warnings = {
   global = "accessing undefined variable %s",
   redefined = "variable %s was previously defined in the same scope",
   unused = "unused variable %s"
}

local function format_file_report(report)
   local label = "Checking "..report.file
   local status = report.total == 0 and color "%{bright}%{green}OK" or color "%{bright}%{red}Failure"
   local buf = {label..(" "):rep(math.max(50 - #label, 1))..status}

   if report.total > 0 then
      table.insert(buf, "")

      for i=1, report.total do
         local warning = report[i]
         local location = ("%s:%d:%d"):format(report.file, warning.line, warning.column)
         local warning = warnings[warning.type]:format(color("%{bright}"..warning.name))
         table.insert(buf, ("    %s: %s"):format(location, warning))
      end

      table.insert(buf, "")
   end

   return table.concat(buf, "\n")
end

--- Creates a formatted message from a report. 
local function format_report(report)
   local buf = {[0] = "\n"}

   for i=1, #report do
      table.insert(buf, format_file_report(report[i]))
   end

   local total = ("Total: %s warnings"):format(color("%{bright}"..tostring(report.total)))

   if buf[#buf]:sub(-1, -1) ~= "\n" then
      table.insert(buf, "")
   end

   table.insert(buf, total)

   return table.concat(buf, "\n")
end

return format_report