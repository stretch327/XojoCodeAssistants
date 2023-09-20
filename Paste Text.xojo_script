// KeyboardShortcut = CMD-OPT-SHIFT-V
// Converts a string on your clipboard for insertion in the code editor

dim s as string = clipboard
s = Trim(s)
s = ReplaceAll(s, """", """""")
s = ReplaceAll(s, Chr(13)+Chr(10), Chr(13))
s = ReplaceAll(s, Chr(10), Chr(13))
s = ReplaceAll(s, Chr(13), """ + EndOfLine + _" + Chr(13) + """")
s = """" + s + """"
selText = s
