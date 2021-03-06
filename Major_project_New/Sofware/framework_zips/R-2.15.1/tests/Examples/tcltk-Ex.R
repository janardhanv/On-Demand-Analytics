pkgname <- "tcltk"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
q()

assign(".oldSearch", search(), pos = 'CheckExEnv')
cleanEx()
nameEx("TclInterface")
### * TclInterface

flush(stderr()); flush(stdout())

### Name: TclInterface
### Title: Low-level Tcl/Tk Interface
### Aliases: TclInterface .Tcl .Tcl.objv .Tcl.callback .Tcl.args
###   .Tcl.args.objv tclvar tclVar as.character.tclVar tclArray [[.tclArray
###   [[<-.tclArray $.tclArray $<-.tclArray names.tclArray length.tclArray
###   names<-.tclArray length<-.tclArray tclvalue tclvalue<-
###   tclvalue.default tclvalue<-.default tclvalue.tclVar tclvalue<-.tclVar
###   tclvalue.tclObj as.character.tclObj as.integer.tclObj
###   as.double.tclObj as.logical.tclObj as.raw.tclObj as.tclObj is.tclObj
###   tclObj print.tclObj tclObj<- tclObj.tclVar tclObj<-.tclVar .Tk.ID
###   .Tk.newwin .Tk.subwin is.tkwin tkdestroy .TkRoot addTclPath
###   tclRequire
### Keywords: misc

### ** Examples

## Not run: 
##D ## These cannot be run by example() but should be OK when pasted
##D ## into an interactive R session with the tcltk package loaded
##D .Tcl("format \"%s\n\" \"Hello, World!\"")
##D f <- function()cat("HI!\n")
##D .Tcl.callback(f)
##D .Tcl.args(text="Push!", command=f) # NB: Different address
##D 
##D xyzzy <- tclVar(7913)
##D tclvalue(xyzzy)
##D tclvalue(xyzzy) <- "foo"
##D as.character(xyzzy)
##D tcl("set", as.character(xyzzy))
##D 
##D top <- tktoplevel() # a Tk widget, see Tk-widgets
##D ls(envir=top$env, all=TRUE)
##D ls(envir=.TkRoot$env, all=TRUE)# .Tcl.args put a callback ref in here
## End(Not run)



cleanEx()
nameEx("TkCommands")
### * TkCommands

flush(stderr()); flush(stdout())

### Name: TkCommands
### Title: Tk non-widget commands
### Aliases: TkCommands tcl tktitle tktitle<- tkbell tkbind tkbindtags
###   tkfocus tklower tkraise tkclipboard.append tkclipboard.clear
###   tkevent.add tkevent.delete tkevent.generate tkevent.info
###   tkfont.actual tkfont.configure tkfont.create tkfont.delete
###   tkfont.families tkfont.measure tkfont.metrics tkfont.names tkgrab
###   tkgrab.current tkgrab.release tkgrab.set tkgrab.status tkimage.cget
###   tkimage.configure tkimage.create tkimage.names tkXselection.clear
###   tkXselection.get tkXselection.handle tkXselection.own tkwait.variable
###   tkwait.visibility tkwait.window tkwinfo tkwm.aspect tkwm.client
###   tkwm.colormapwindows tkwm.command tkwm.deiconify tkwm.focusmodel
###   tkwm.frame tkwm.geometry tkwm.grid tkwm.group tkwm.iconbitmap
###   tkwm.iconify tkwm.iconmask tkwm.iconname tkwm.iconposition
###   tkwm.iconwindow tkwm.maxsize tkwm.minsize tkwm.overrideredirect
###   tkwm.positionfrom tkwm.protocol tkwm.resizable tkwm.sizefrom
###   tkwm.state tkwm.title tkwm.transient tkwm.withdraw tkgrid tkgrid.bbox
###   tkgrid.columnconfigure tkgrid.configure tkgrid.forget tkgrid.info
###   tkgrid.location tkgrid.propagate tkgrid.rowconfigure tkgrid.remove
###   tkgrid.size tkgrid.slaves tkpack tkpack.configure tkpack.forget
###   tkpack.info tkpack.propagate tkpack.slaves tkplace tkplace.configure
###   tkplace.forget tkplace.info tkplace.slaves tkgetOpenFile
###   tkgetSaveFile tkchooseDirectory tkmessageBox tkdialog tkpopup
###   tclfile.tail tclfile.dir tclopen tclclose tclputs tclread
### Keywords: misc

### ** Examples

## Not run: 
##D ## These cannot be run by examples() but should be OK when pasted
##D ## into an interactive R session with the tcltk package loaded
##D 
##D tt <- tktoplevel()
##D tkpack(l1<-tklabel(tt,text="Heave"), l2<-tklabel(tt,text="Ho"))
##D tkpack.configure(l1, side="left")
##D 
##D ## Try stretching the window and then
##D 
##D tkdestroy(tt)
## End(Not run)




cleanEx()
nameEx("TkWidgetcmds")
### * TkWidgetcmds

flush(stderr()); flush(stdout())

### Name: TkWidgetcmds
### Title: Tk widget commands
### Aliases: TkWidgetcmds tkactivate tkadd tkaddtag tkbbox tkcanvasx
###   tkcanvasy tkcget tkcompare tkconfigure tkcoords tkcreate
###   tkcurselection tkdchars tkdebug tkdelete tkdelta tkdeselect
###   tkdlineinfo tkdtag tkdump tkentrycget tkentryconfigure tkfind tkflash
###   tkfraction tkget tkgettags tkicursor tkidentify tkindex tkinsert
###   tkinvoke tkitembind tkitemcget tkitemconfigure tkitemfocus
###   tkitemlower tkitemraise tkitemscale tkmark.gravity tkmark.names
###   tkmark.next tkmark.previous tkmark.set tkmark.unset tkmove tknearest
###   tkpost tkpostcascade tkpostscript tkscan.mark tkscan.dragto tksearch
###   tksee tkselect tkselection.adjust tkselection.anchor
###   tkselection.clear tkselection.from tkselection.includes
###   tkselection.present tkselection.range tkselection.set tkselection.to
###   tkset tksize tktoggle tktag.add tktag.bind tktag.cget tktag.configure
###   tktag.delete tktag.lower tktag.names tktag.nextrange tktag.prevrange
###   tktag.raise tktag.ranges tktag.remove tktype tkunpost tkwindow.cget
###   tkwindow.configure tkwindow.create tkwindow.names tkxview
###   tkxview.moveto tkxview.scroll tkyposition tkyview tkyview.moveto
###   tkyview.scroll
### Keywords: misc

### ** Examples

## Not run: 
##D ## These cannot be run by examples() but should be OK when pasted
##D ## into an interactive R session with the tcltk package loaded
##D 
##D tt <- tktoplevel()
##D tkpack(txt.w <- tktext(tt))
##D tkinsert(txt.w, "0.0", "plot(1:10)")
##D 
##D # callback function 
##D eval.txt <- function()
##D    eval(parse(text=tclvalue(tkget(txt.w, "0.0", "end"))))
##D tkpack(but.w <- tkbutton(tt,text="Submit", command=eval.txt))
##D 
##D ## Try pressing the button, edit the text and when finished:
##D 
##D tkdestroy(tt)
## End(Not run)




cleanEx()
nameEx("TkWidgets")
### * TkWidgets

flush(stderr()); flush(stdout())

### Name: TkWidgets
### Title: Tk widgets
### Aliases: TkWidgets tkwidget tkbutton tkcanvas tkcheckbutton tkentry
###   tkframe tklabel tklistbox tkmenu tkmenubutton tkmessage tkradiobutton
###   tkscale tkscrollbar tktext tktoplevel ttkbutton ttkcheckbutton
###   ttkcombobox ttkentry ttkframe ttkimage ttklabel ttklabelframe
###   ttkmenubutton ttknotebook ttkpanedwindow ttkprogressbar
###   ttkradiobutton ttkscrollbar ttkseparator ttksizegrip ttktreeview
### Keywords: misc

### ** Examples

## Not run: 
##D ## These cannot be run by examples() but should be OK when pasted
##D ## into an interactive R session with the tcltk package loaded
##D 
##D tt <- tktoplevel()
##D label.widget <- tklabel(tt, text="Hello, World!")
##D button.widget <- tkbutton(tt, text="Push",
##D                           command=function()cat("OW!\n"))
##D tkpack(label.widget, button.widget) # geometry manager
##D                                     # see Tk-commands
##D 
##D ## Push the button and then...
##D 
##D tkdestroy(tt)
##D 
##D ## test for themed widgets
##D if(as.character(tcl("info", "tclversion")) >= "8.5") {
##D   # make use of themed widgets
##D   # list themes
##D   as.character(tcl("ttk::style", "theme", "names"))
##D   # select a theme -- here pre-XP windows
##D   tcl("ttk::style", "theme use", "winnative")
##D } else {
##D   # use Tk 8.0 widgets
##D }
## End(Not run)


cleanEx()
nameEx("tclServiceMode")
### * tclServiceMode

flush(stderr()); flush(stdout())

### Name: tclServiceMode
### Title: Allow Tcl events to be serviced or not
### Aliases: tclServiceMode
### Keywords: misc

### ** Examples

## see demo(tkcanvas) for an example
## Not run: 
##D     
##D oldmode <- tclServiceMode(FALSE)
##D # Do some work to create a nice picture.
##D # Nothing will be displayed until...
##D tclServiceMode(oldmode)
## End(Not run)
## another idea is to use tkwm.withdraw() ... tkwm.deiconify()



cleanEx()
nameEx("tkProgressBar")
### * tkProgressBar

flush(stderr()); flush(stdout())

### Name: tkProgressBar
### Title: Progress Bars via Tk
### Aliases: tkProgressBar getTkProgressBar setTkProgressBar
###   close.tkProgressBar
### Keywords: utilities

### ** Examples


cleanEx()
nameEx("tk_choose.dir")
### * tk_choose.dir

flush(stderr()); flush(stdout())

### Name: tk_choose.dir
### Title: Choose a Folder Interactively
### Aliases: tk_choose.dir
### Keywords: file

### ** Examples
## Not run: 
##D tk_choose.dir(getwd(), "Choose a suitable folder")
## End(Not run)


cleanEx()
nameEx("tk_choose.files")
### * tk_choose.files

flush(stderr()); flush(stdout())

### Name: tk_choose.files
### Title: Choose a List of Files Interactively
### Aliases: tk_choose.files
### Keywords: file

### ** Examples

Filters <- matrix(c("R code", ".R", "R code", ".s",
                    "Text", ".txt", "All files", "*"),
                  4, 2, byrow = TRUE)
Filters
if(interactive()) tk_choose.files(filter = Filters)



### * <FOOTER>
###
cat("Time elapsed: ", proc.time() - get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
