# XojoCodeAssistants
A set of Code Assistant scripts for people who do a lot of declare work.

## Background

When I was first working for Xojo, Joe Ranieri was "the guy" that you went to if you ever needed to quickly get a correctly formatted Declare for macOS or iOS. When Joe departed, I became one of the engineers to maintain the macOS and iOS frameworks and, as such, the new "guy". Before leaving Xojo in 2022, I was working on a new feature that allows users to add xojo scripts to the code editor's contextual menu called "Code Assistants" which can modify selections of code in lots of helpful ways. 

This library of scripts is designed for people who do a lot of declare work. There are scripts for:

- Insert Alloc & Init Declares
- Insert quick code for converting an NSDate to a Xojo DateTime object
- Insert declares for getting error codes and descriptions from NSErrors
- InitClass which inserts declares for NSClassFromString, alloc and init and a code snippet to start
- Insert NSClassFromString declare
- Insert NSSelectorFromString declare
- Insert release declare
- Insert retain declare
- Insert SetDelegate declare
- Insert Class and SuperClass declares
- NSClass constant lookup code
- ***Creating Declares from Apple's Objective-C docs - SEE BELOW***

As well as four scripts for wrapping selections compiler directives:

- #If TargetiOS - CMD-OPT-SHIFT-I
- #if TargetMacOS - CMD-OPT-SHIFT-M
- #If TargetiOS Or TargetMacOS - CMD-OPT-SHIFT-N
- #If False (for disabling code)

And a few strictly for convenience:

- Paste Text - CMD-OPT-SHIFT-V - which takes whatever is on the clipboard and converts it so it will be represented the exact same way as xojo code. That is, quotes are doubled up, line endings are converted to EndOfLine followed by _

- Split Declaration - 

  - Converts a line like this: `Dim x as string = "Hello World"`
  - Replaces it with `x = "Hello World"`
  - Puts `Dim x as string` onto the clipboard so you can move it elsewhere in your code

- Swap Handlers

  - For lines which begin with the keyword AddHandler, it replaces with RemoveHandler and vice versa.

- Text to CHR

  - Converts a quoted string into a series of chrb() calls with a comment afterwards as to what the original string was.
  - `"Hello World"` becomes `chrb(72) + chrb(101) + chrb(108) + chrb(108) + chrb(111) + chrb(32) + chrb(87) + chrb(111) + chrb(114) + chrb(108) + chrb(100) // Hello World`

- Wrap in IsDarkMode

  - For people finally getting around to adding Dark Mode support to their apps, this script will wrap the current selection like this so you can put the new code in the empty block
    ```Xojo
    If IsDarkMode Then
    
    Else
        // Current Code Goes here
    End If
    ```

    

## Installation

I find the easiest place to put scripts these days is in the Xojo folder in your user directory. That directory can be found on macOS at:

`/Users/Your Name/Documents/Xojo/IDE/Scripts/`

or similar location on the other platforms. The easiest way to find it is to use Xojo to find:

`SpecialFolder.Documents`

and then look in (or create) Xojo, IDE and Scripts folders.



## Usage

To use these scripts, you'll find them in one of two places. The scripts which have key-equivalents will appear in the IDE's File menu under File > IDE Scripts. Everything else (the ones with the `.xojo_code_assistant` extension) appear in the code editor's contextual menu. You can access them by going to a code editor and right-clicking the mouse. These scripts will appear under submenus of the "Code Assistants" menu by category.

## Creating Declares

Because I don't want to be the only guy that creates declares for Xojo, I created a special script which largely allows you to copy & paste from Apple's docs. That said, you still need to know a little bit about how Apple's Frameworks and Objective-C work, but this script takes a large chunk of the tedium out of the process. 

As an example of a declare that I converted recently, I suspected that the exception from the Xojo framework saying that SpecialFolder.Temporary was invalid on iOS was incorrect and I was able to find the property I was looking for here:

https://developer.apple.com/documentation/foundation/nsfilemanager/1642996-temporarydirectory

Now as a property of NSFileManager, you still need an instance of that class which Apple conveniently provides in the form of a shared method called defaultManager, and we also need a way to convert its return value of NSURL into something we can use in Xojo, so we need three commands:

1. A way to get the defaultManager property of NSFileManager 
   `@property(class, readonly, strong) NSFileManager *defaultManager;`
2. A way to get the temporaryDirectory property of the shared manager
   `@property(readonly, copy) NSURL *temporaryDirectory;`
3. A way to get the URL path of the returned NSURL
   `@property(nullable, readonly, copy) NSString *absoluteString;`

The way this script works, is you go to Apple's docs and then select and copy the Objective-C declaration of the property or method:

`@property(class, readonly, strong) NSFileManager *defaultManager;`

Click on the code editor in the Xojo IDE, right-click and select Code Assistants > Convert > macOS & iOS Declare Maker. What's pasted into the code editor is this:

```
// @property(class, readonly, strong) NSFileManager *defaultManager;
Declare Function getDefaultManager Lib "Foundation" selector "defaultManager" (cls as ptr) as Ptr
```

If we do that for the other two we end up with this:

```
// @property(class, readonly, strong) NSFileManager *defaultManager;
Declare Function getDefaultManager Lib "Foundation" Selector "defaultManager" (cls As ptr) As Ptr

// @property(readonly, copy) NSURL *temporaryDirectory;
Declare Function getTemporaryDirectory Lib "Foundation" Selector "temporaryDirectory" (obj As ptr) As Ptr

// @property(nullable, readonly, copy) NSString *absoluteString;
Declare Function getAbsoluteString Lib "Foundation" selector "absoluteString" (obj as ptr) as CFStringRef
```

As you can see, it really does most of the work for you. There's one final declare that we need to make these useful, which is NSClassFromString which (conveniently) is one of the scripts I listed above so you can easily insert that too.

`Declare Function NSClassFromString Lib "Foundation" (name As cfstringref) As ptr`

With these four declares, getting a folderitem of the current user's temporary directory is "simple", and I suggest wrapping it in appropriate compiler directives.

```
#If TargetIOS Or TargetMacOS
    Dim NSFileManager as Ptr = NSClassFromString("NSFileManager")
    Dim manager as Ptr = getDefaultManager(NSFileManager)
    Dim tempDir as Ptr = getTemporaryDirectory(manager)
    Dim path as string = getAbsoluteString(tempDir)
    Dim f as New FolderItem(path, FolderItem.PathModes.URL)
#EndIf
```
