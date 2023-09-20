// KeyboardShortcut = CMD-OPT-SHIFT-F
// Wraps the current selection in #If False
// Great for disabling a section of code temporarily

// Get all of the lines
Dim sa() As String = Split(Text, EndOfLine)

// Find the lines that contain the start and end of the selection (if there is one)
dim startline as integer = 0
dim endline as integer = -1

if sellength > 0 then
  dim st as integer = selstart
  dim nd as integer = selstart + sellength
  dim p as integer = 0
  while p < st
    p = p + len(sa(startline)) + len(endofline)    
    startline = startline + 1
  wend
  endline = startline
  
  while p < nd
    p = p + len(sa(endline)) + len(endofline)    
    endline = endline + 1
  wend
end if

// add the #if before the selection
sa.insert(startline, "#If False")

// Add the #endif after the selection
if endline = -1 then
  sa.append "#EndIf"
else
  sa.insert(endline+1,"#EndIf")
end if

text = join(sa, endofline)

// Fix the indent
text = text + endofline

// Undo to fix formatting issue in the IDE
DoCommand("Undo")
