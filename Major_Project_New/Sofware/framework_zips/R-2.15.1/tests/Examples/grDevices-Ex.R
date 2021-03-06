pkgname <- "grDevices"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('grDevices')

assign(".oldSearch", search(), pos = 'CheckExEnv')
cleanEx()
nameEx("Devices")
### * Devices

flush(stderr()); flush(stdout())

### Name: Devices
### Title: List of Graphical Devices
### Aliases: Devices device
### Keywords: device

### ** Examples
## Not run: 
##D ## open the default screen device on this platform if no device is
##D ## open
##D if(dev.cur() == 1) dev.new()
## End(Not run)


cleanEx()
nameEx("Hershey")
### * Hershey

flush(stderr()); flush(stdout())

### Name: Hershey
### Title: Hershey Vector Fonts in R
### Aliases: Hershey
### Keywords: aplot

### ** Examples

Hershey

## for tables of examples, see demo(Hershey)



cleanEx()
nameEx("Japanese")
### * Japanese

flush(stderr()); flush(stdout())

### Name: Japanese
### Title: Japanese characters in R
### Aliases: Japanese
### Keywords: aplot

### ** Examples

require(graphics)

plot(1:9, type="n", axes=FALSE, frame=TRUE, ylab="",
     main= "example(Japanese)", xlab= "using Hershey fonts")
par(cex=3)
Vf <- c("serif", "plain")
text(4, 2, "\\#J2438\\#J2421\\#J2451\\#J2473", vfont = Vf)
text(4, 4, "\\#J2538\\#J2521\\#J2551\\#J2573", vfont = Vf)
text(4, 6, "\\#J467c\\#J4b5c", vfont = Vf)
text(4, 8, "Japan", vfont = Vf)
par(cex=1)
text(8, 2, "Hiragana")
text(8, 4, "Katakana")
text(8, 6, "Kanji")
text(8, 8, "English")



graphics::par(get("par.postscript", pos = 'CheckExEnv'))
cleanEx()
nameEx("Type1Font")
### * Type1Font

flush(stderr()); flush(stdout())

### Name: Type1Font
### Title: Type 1 and CID Fonts
### Aliases: Type1Font CIDFont
### Keywords: device

### ** Examples

## This duplicates "ComputerModernItalic".
CMitalic <- Type1Font("ComputerModern2",
                      c("CM_regular_10.afm", "CM_boldx_10.afm",
                        "cmti10.afm", "cmbxti10.afm",
                        "CM_symbol_10.afm"),
                      encoding = "TeXtext.enc")

## Not run: 
##D ## This could be used by
##D postscript(family = CMitalic)
##D ## or
##D postscriptFonts(CMitalic = CMitalic)  # once in a session
##D postscript(family = "CMitalic", encoding = "TeXtext.enc")
## End(Not run)


cleanEx()
nameEx("adjustcolor")
### * adjustcolor

flush(stderr()); flush(stdout())

### Name: adjustcolor
### Title: Adjust Colors in One or More Directions Conveniently.
### Aliases: adjustcolor

### ** Examples

## Illustrative examples :
opal <- palette("default")
stopifnot(identical(adjustcolor(1:8,       0.75),
                    adjustcolor(palette(), 0.75)))
cbind(palette(), adjustcolor(1:8, 0.75))

##  alpha = 1/2 * previous alpha --> opaque colors
x <- palette(adjustcolor(palette(), 0.5))

sines <- outer(1:20, 1:4, function(x, y) sin(x / 20 * pi * y))
matplot(sines, type = "b", pch = 21:23, col = 2:5, bg = 2:5,
        main = "Using an 'opaque ('translucent') color palette")

x. <- adjustcolor(x, offset=c(0.5,0.5,0.5, 0), # <- "more white"
                  transform=diag(c(.7, .7, .7, 0.6)))
cbind(x, x.)
op <- par(bg=adjustcolor("goldenrod",offset=-rep(.4,4)), xpd=NA)
plot(0:9,0:9, type="n",axes=FALSE, xlab="",ylab="",
     main="adjustcolor() -> translucent")
text(1:8, labels=paste(x,"++",sep=""), col=x., cex=8)
par(op)

## and

(M <- cbind( rbind( matrix(1/3, 3,3), 0), c(0,0,0,1)))
adjustcolor(x, transform = M)

## revert to previous palette: active
palette(opal)



graphics::par(get("par.postscript", pos = 'CheckExEnv'))
cleanEx()
nameEx("as.raster")
### * as.raster

flush(stderr()); flush(stdout())

### Name: as.raster
### Title: Create a Raster Object
### Aliases: is.raster as.raster as.raster.logical as.raster.numeric
###   as.raster.character as.raster.matrix as.raster.array
### Keywords: dplot

### ** Examples

# A red gradient
as.raster(matrix(hcl(0, 80, seq(50, 80, 10)),
                 nrow=4, ncol=5))

# Vectors are 1-column matrices ...
#   character vectors are color names ...
as.raster(hcl(0, 80, seq(50, 80, 10)))
#   numeric vectors are greyscale ...
as.raster(1:5, max=5)
#   locigal vectors are black and white ...
as.raster(1:10 %% 2 == 0)

# ... unless nrow/ncol are supplied ...
as.raster(1:10 %% 2 == 0, nrow=1)

# Matrix can also be logical or numeric ...
as.raster(matrix(c(TRUE, FALSE), nrow=3, ncol=2))
as.raster(matrix(1:3/4, nrow=3, ncol=4))

# An array can be 3-plane numeric (R, G, B planes) ...
as.raster(array(c(0:1, rep(0.5, 4)), c(2, 1, 3)))

# ... or 4-plane numeric (R, G, B, A planes)
as.raster(array(c(0:1, rep(0.5, 6)), c(2, 1, 4)))

# subsetting
r <- as.raster(matrix(colors()[1:100], ncol=10))
r[, 2]
r[2:4, 2:5]

# assigning to subset
r[2:4, 2:5] <- "white"

# comparison
r == "white"

## Don't show: 
stopifnot(r[] == r,
          identical(r[3:5], colors()[3:5]))
r[2:4] <- "black"
stopifnot(identical(r[1:4, 1], as.raster(c("white", rep("black",3)))))
## End Don't show



cleanEx()
nameEx("axisTicks")
### * axisTicks

flush(stderr()); flush(stdout())

### Name: axisTicks
### Title: Compute Pretty Axis Tick Scales
### Aliases: axisTicks .axisPars
### Keywords: dplot

### ** Examples

##--- Demonstrating correspondence between graphics'
##--- axis() and the graphics-engine agnostic  axisTicks() :

require("graphics")
plot(10*(0:10)); (pu <- par("usr"))
aX <- function(side, at, ...)
    axis(side, at=at, labels=FALSE, lwd.ticks=2, col.ticks=2, tck=0.05, ...)
aX(1, print(xa <- axisTicks(pu[1:2], log=FALSE)))# x axis
aX(2, print(ya <- axisTicks(pu[3:4], log=FALSE)))# y axis

axisTicks(pu[3:4], log=FALSE, n = 10)

plot(10*(0:10), log="y"); (pu <- par("usr"))
aX(2, print(ya <- axisTicks(pu[3:4], log=TRUE)))# y axis

plot(2^(0:9), log="y"); (pu <- par("usr"))
aX(2, print(ya <- axisTicks(pu[3:4], log=TRUE)))# y axis




graphics::par(get("par.postscript", pos = 'CheckExEnv'))
cleanEx()
nameEx("boxplot.stats")
### * boxplot.stats

flush(stderr()); flush(stdout())

### Name: boxplot.stats
### Title: Box Plot Statistics
### Aliases: boxplot.stats
### Keywords: dplot

### ** Examples

require(stats)
x <- c(1:100, 1000)
(b1 <- boxplot.stats(x))
(b2 <- boxplot.stats(x, do.conf=FALSE, do.out=FALSE))
stopifnot(b1 $ stats == b2 $ stats) # do.out=F is still robust
boxplot.stats(x, coef = 3, do.conf=FALSE)
## no outlier treatment:
boxplot.stats(x, coef = 0)

boxplot.stats(c(x, NA)) # slight change : n is 101
(r <- boxplot.stats(c(x, -1:1/0)))
stopifnot(r$out == c(1000, -Inf, Inf))

## Don't show: 
 ## Difference between quartiles and hinges :
 nn <- 1:17 ;  n4 <- nn %% 4
 hin <- sapply(sapply(nn, seq), function(x) boxplot.stats(x)$stats[c(2,4)])
 q13 <- sapply(sapply(nn, seq), quantile, probs = c(1,3)/4, names = FALSE)
 m <- t(rbind(q13,hin))[, c(1,3,2,4)]
 dimnames(m) <- list(paste(nn), c("q1","lH", "q3","uH"))
 stopifnot(m[n4==1, 1:2] == (nn[n4==1] + 3)/4,# quart. = hinge
           m[n4==1, 3:4] == (3*nn[n4==1]+1)/4,
           m[,"lH"] == ( (nn+3) %/% 2) / 2,
           m[,"uH"] == ((3*nn+2)%/% 2) / 2)
 cm <- noquote(format(m))
 cm[m[,2] == m[,1], 2] <- " = "
 cm[m[,4] == m[,3], 4] <- " = "
 cm
## End Don't show




cleanEx()
nameEx("check.options")
### * check.options

flush(stderr()); flush(stdout())

### Name: check.options
### Title: Set Options with Consistency Checks
### Aliases: check.options
### Keywords: utilities programming

### ** Examples

(L1 <- list(a=1:3, b=pi, ch="CH"))
check.options(list(a=0:2), name.opt = "L1")
check.options(NULL, reset = TRUE, name.opt = "L1")



cleanEx()
nameEx("chull")
### * chull

flush(stderr()); flush(stdout())

### Name: chull
### Title: Compute Convex Hull of a Set of Points
### Aliases: chull
### Keywords: graphs

### ** Examples

require(stats)
X <- matrix(rnorm(2000), ncol = 2)
chull(X)
## Not run: 
##D   # Example usage from graphics package
##D   plot(X, cex = 0.5)
##D   hpts <- chull(X)
##D   hpts <- c(hpts, hpts[1])
##D   lines(X[hpts, ])
## End(Not run)



cleanEx()
nameEx("cm")
### * cm

flush(stderr()); flush(stdout())

### Name: cm
### Title: Unit Transformation
### Aliases: cm
### Keywords: dplot

### ** Examples

cm(1)# = 2.54

## Translate *from* cm *to* inches:

10 / cm(1) # -> 10cm  are 3.937 inches



cleanEx()
nameEx("col2rgb")
### * col2rgb

flush(stderr()); flush(stdout())

### Name: col2rgb
### Title: Color to RGB Conversion
### Aliases: col2rgb
### Keywords: color dplot

### ** Examples

col2rgb("peachpuff")
col2rgb(c(blu = "royalblue", reddish = "tomato")) # names kept

col2rgb(1:8)# the ones from the palette() :

col2rgb(paste("gold", 1:4, sep=""))

col2rgb("#08a0ff")
## all three kind of colors mixed :
col2rgb(c(red="red", palette= 1:3, hex="#abcdef"))

##-- NON-INTRODUCTORY examples --

grC <- col2rgb(paste("gray",0:100,sep=""))
table(print(diff(grC["red",])))# '2' or '3': almost equidistant
## The 'named' grays are in between {"slate gray" is not gray, strictly}
col2rgb(c(g66="gray66", darkg= "dark gray", g67="gray67",
          g74="gray74", gray =      "gray", g75="gray75",
          g82="gray82", light="light gray", g83="gray83"))

crgb <- col2rgb(cc <- colors())
colnames(crgb) <- cc
t(crgb)## The whole table

ccodes <- c(256^(2:0) %*% crgb)## = internal codes
## How many names are 'aliases' of each other:
table(tcc <- table(ccodes))
length(uc <- unique(sort(ccodes))) # 502
## All the multiply named colors:
mult <- uc[tcc >= 2]
cl <- lapply(mult, function(m) cc[ccodes == m])
names(cl) <- apply(col2rgb(sapply(cl, function(x)x[1])),
                   2, function(n)paste(n, collapse=","))
utils::str(cl)
## Not run: 
##D  if(require(xgobi)) { ## Look at the color cube dynamically :
##D    tc <- t(crgb[, !duplicated(ccodes)])
##D    table(is.gray <- tc[,1] == tc[,2] & tc[,2] == tc[,3])# (397, 105)
##D    xgobi(tc, color = c("gold", "gray")[1 + is.gray])
##D  }
## End(Not run)



cleanEx()
nameEx("colorRamp")
### * colorRamp

flush(stderr()); flush(stdout())

### Name: colorRamp
### Title: Color interpolation
### Aliases: colorRamp colorRampPalette
### Keywords: color

### ** Examples

## Both return a *function* :
colorRamp(c("red","green"))( (0:4)/4 ) ## (x) , x in [0,1]
colorRampPalette(c("blue","red"))( 4 ) ## (n)
## Don't show: 
## special case, invalid in R <= 2.15.0:
bb <- colorRampPalette(2)(4)
stopifnot(bb[1] == bb)
## End Don't show
require(graphics)

## Here space="rgb" gives palettes that vary only in saturation,
## as intended.
## With space="Lab" the steps are more uniform, but the hues
## are slightly purple.
filled.contour(volcano,
               color.palette =
                   colorRampPalette(c("red", "white", "blue")),
               asp = 1)
filled.contour(volcano,
               color.palette =
                   colorRampPalette(c("red", "white", "blue"),
                                    space = "Lab"),
               asp = 1)

## Interpolating a 'sequential' ColorBrewer palette
YlOrBr <- c("#FFFFD4", "#FED98E", "#FE9929", "#D95F0E", "#993404")
filled.contour(volcano,
               color.palette = colorRampPalette(YlOrBr, space = "Lab"),
               asp = 1)
filled.contour(volcano,
               color.palette = colorRampPalette(YlOrBr, space = "Lab",
                                                bias = 0.5),
               asp = 1)

## 'jet.colors' is "as in Matlab"
## (and hurting the eyes by over-saturation)
jet.colors <-
  colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan",
                     "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
filled.contour(volcano, color = jet.colors, asp = 1)

## space="Lab" helps when colors don't form a natural sequence
m <- outer(1:20,1:20,function(x,y) sin(sqrt(x*y)/3))
rgb.palette <- colorRampPalette(c("red", "orange", "blue"),
                                space = "rgb")
Lab.palette <- colorRampPalette(c("red", "orange", "blue"),
                                space = "Lab")
filled.contour(m, col = rgb.palette(20))
filled.contour(m, col = Lab.palette(20))



cleanEx()
nameEx("colors")
### * colors

flush(stderr()); flush(stdout())

### Name: colors
### Title: Color Names
### Aliases: colors colours
### Keywords: color dplot sysdata

### ** Examples

cl <- colors()
length(cl); cl[1:20]

### ----------- Show (almost) all named colors ---------------------

## 1) with traditional 'graphics' package:
showCols1 <- function(bg = "gray", cex = 0.75, srt = 30) {
    m <- ceiling(sqrt(n <- length(cl <- colors())))
    length(cl) <- m*m; cm <- matrix(cl, m)
    ##
    require("graphics")
    op <- par(mar=rep(0,4), ann=FALSE, bg = bg); on.exit(par(op))
    plot(1:m,1:m, type="n", axes=FALSE)
    text(col(cm), rev(row(cm)), cm,  col = cl, cex=cex, srt=srt)
}
showCols1()

## 2) with 'grid' package:
showCols2 <- function(bg = "grey", cex = 0.75, rot = 30) {
    m <- ceiling(sqrt(n <- length(cl <- colors())))
    length(cl) <- m*m; cm <- matrix(cl, m)
    ##
    require("grid")
    grid.newpage(); vp <- viewport(w = .92, h = .92)
    grid.rect(gp=gpar(fill=bg))
    grid.text(cm, x = col(cm)/m, y = rev(row(cm))/m, rot = rot,
              vp=vp, gp=gpar(cex = cex, col = cm))
}
showCols2()
showCols2(bg = "gray33")



graphics::par(get("par.postscript", pos = 'CheckExEnv'))
cleanEx()
nameEx("contourLines")
### * contourLines

flush(stderr()); flush(stdout())

### Name: contourLines
### Title: Calculate Contour Lines
### Aliases: contourLines
### Keywords: dplot

### ** Examples

x <- 10*1:nrow(volcano)
y <- 10*1:ncol(volcano)
contourLines(x, y, volcano)



cleanEx()
nameEx("convertColor")
### * convertColor

flush(stderr()); flush(stdout())

### Name: convertColor
### Title: Convert between Colour Spaces
### Aliases: convertColor colorspaces
### Keywords: color

### ** Examples

require(graphics); require(stats) # for na.omit
par(mfrow=c(2,2))
## The displayable colors from four planes of Lab space
ab <- expand.grid(a=(-10:15)*10,b=(-15:10)*10)

Lab <- cbind(L=20,ab)
srgb <- convertColor(Lab,from="Lab",to="sRGB",clip=NA)
clipped <- attr(na.omit(srgb),"na.action")
srgb[clipped,] <- 0
cols <- rgb(srgb[,1],srgb[,2],srgb[,3])
image((-10:15)*10,(-15:10)*10,matrix(1:(26*26),ncol=26),col=cols,
  xlab="a",ylab="b",main="Lab: L=20")

Lab <- cbind(L=40,ab)
srgb <- convertColor(Lab,from="Lab",to="sRGB",clip=NA)
clipped <- attr(na.omit(srgb),"na.action")
srgb[clipped,] <- 0
cols <- rgb(srgb[,1],srgb[,2],srgb[,3])
image((-10:15)*10,(-15:10)*10,matrix(1:(26*26),ncol=26),col=cols,
  xlab="a",ylab="b",main="Lab: L=40")

Lab <- cbind(L=60,ab)
srgb <- convertColor(Lab,from="Lab",to="sRGB",clip=NA)
clipped <- attr(na.omit(srgb),"na.action")
srgb[clipped,] <- 0
cols <- rgb(srgb[,1],srgb[,2],srgb[,3])
image((-10:15)*10,(-15:10)*10,matrix(1:(26*26),ncol=26),col=cols,
  xlab="a",ylab="b",main="Lab: L=60")

Lab <- cbind(L=80,ab)
srgb <- convertColor(Lab,from="Lab",to="sRGB",clip=NA)
clipped <- attr(na.omit(srgb),"na.action")
srgb[clipped,] <- 0
cols <- rgb(srgb[,1],srgb[,2],srgb[,3])
image((-10:15)*10,(-15:10)*10,matrix(1:(26*26),ncol=26),col=cols,
  xlab="a",ylab="b",main="Lab: L=80")

(cols <- t(col2rgb(palette())))
zapsmall(lab <- convertColor(cols,from="sRGB",to="Lab",scale.in=255))
round(convertColor(lab,from="Lab",to="sRGB",scale.out=255))



graphics::par(get("par.postscript", pos = 'CheckExEnv'))
cleanEx()
nameEx("densCols")
### * densCols

flush(stderr()); flush(stdout())

### Name: densCols
### Title: Colors for Smooth Density Plots
### Aliases: densCols blues9
### Keywords: dplot

### ** Examples

x1  <- matrix(rnorm(1e3), ncol=2)
x2  <- matrix(rnorm(1e3, mean=3, sd=1.5), ncol=2)
x   <- rbind(x1,x2)

dcols <- densCols(x)
graphics::plot(x, col = dcols, pch=20, main = "n = 1000")



cleanEx()
nameEx("dev")
### * dev

flush(stderr()); flush(stdout())

### Name: dev
### Title: Control Multiple Devices
### Aliases: dev.cur dev.list dev.next dev.prev dev.off dev.set dev.new
###   graphics.off
### Keywords: device iplot

### ** Examples

## Not run: 
##D ## Unix-specific example
##D x11()
##D plot(1:10)
##D x11()
##D plot(rnorm(10))
##D dev.set(dev.prev())
##D abline(0,1)# through the 1:10 points
##D dev.set(dev.next())
##D abline(h=0, col="gray")# for the residual plot
##D dev.set(dev.prev())
##D dev.off(); dev.off()#- close the two X devices
## End(Not run)



cleanEx()
nameEx("dev.capabilities")
### * dev.capabilities

flush(stderr()); flush(stdout())

### Name: dev.capabilities
### Title: Query Capabilities of the Current Graphics Device
### Aliases: dev.capabilities
### Keywords: dplot

### ** Examples

dev.capabilities()



cleanEx()
nameEx("dev.interactive")
### * dev.interactive

flush(stderr()); flush(stdout())

### Name: dev.interactive
### Title: Is the Current Graphics Device Interactive?
### Aliases: dev.interactive deviceIsInteractive
### Keywords: device

### ** Examples

dev.interactive()
print(deviceIsInteractive(NULL))



cleanEx()
nameEx("dev.size")
### * dev.size

flush(stderr()); flush(stdout())

### Name: dev.size
### Title: Find Size of Device Surface
### Aliases: dev.size
### Keywords: dplot

### ** Examples

dev.size("cm")



cleanEx()
nameEx("dev2")
### * dev2

flush(stderr()); flush(stdout())

### Name: dev2
### Title: Copy Graphics Between Multiple Devices
### Aliases: dev.copy dev.print dev.copy2eps dev.copy2pdf dev.control
### Keywords: device

### ** Examples

## Not run: 
##D x11() # on a Unix-alike
##D plot(rnorm(10), main="Plot 1")
##D dev.copy(device=x11)
##D mtext("Copy 1", 3)
##D dev.print(width=6, height=6, horizontal=FALSE) # prints it
##D dev.off(dev.prev())
##D dev.off()
## End(Not run)



cleanEx()
nameEx("extendrange")
### * extendrange

flush(stderr()); flush(stdout())

### Name: extendrange
### Title: Extend a Numerical Range by a Small Percentage
### Aliases: extendrange
### Keywords: dplot

### ** Examples

x <- 1:5
(r <- range(x))         # 1    5
extendrange(x)          # 0.8  5.2
extendrange(x, f= 0.01) # 0.96 5.04
## Use 'r' if you have it already:
stopifnot(identical(extendrange(r=r),
                    extendrange(x)))



cleanEx()
nameEx("getGraphicsEvent")
### * getGraphicsEvent

flush(stderr()); flush(stdout())

### Name: getGraphicsEvent
### Title: Wait for a mouse or keyboard event from a graphics window
### Aliases: getGraphicsEvent setGraphicsEventHandlers getGraphicsEventEnv
###   setGraphicsEventEnv
### Keywords: iplot

### ** Examples




graphics::par(get("par.postscript", pos = 'CheckExEnv'))
cleanEx()
nameEx("gray")
### * gray

flush(stderr()); flush(stdout())

### Name: gray
### Title: Gray Level Specification
### Aliases: gray grey
### Keywords: color

### ** Examples

gray(0:8 / 8)



cleanEx()
nameEx("gray.colors")
### * gray.colors

flush(stderr()); flush(stdout())

### Name: gray.colors
### Title: Gray Color Palette
### Aliases: gray.colors grey.colors
### Keywords: color

### ** Examples

require(graphics)

pie(rep(1,12), col = gray.colors(12))
barplot(1:12, col = gray.colors(12))



cleanEx()
nameEx("hcl")
### * hcl

flush(stderr()); flush(stdout())

### Name: hcl
### Title: HCL Color Specification
### Aliases: hcl
### Keywords: color dplot

### ** Examples

require(graphics)

# The Foley and Van Dam PhD Data.
csd <- matrix(c( 4,2,4,6, 4,3,1,4, 4,7,7,1,
                 0,7,3,2, 4,5,3,2, 5,4,2,2,
                 3,1,3,0, 4,4,6,7, 1,10,8,7,
                 1,5,3,2, 1,5,2,1, 4,1,4,3,
                 0,3,0,6, 2,1,5,5), nrow=4)

csphd <- function(colors)
  barplot(csd, col = colors, ylim = c(0,30),
          names = 72:85, xlab = "Year", ylab = "Students",
          legend = c("Winter", "Spring", "Summer", "Fall"),
          main = "Computer Science PhD Graduates", las = 1)

# The Original (Metaphorical) Colors (Ouch!)
csphd(c("blue", "green", "yellow", "orange"))

# A Color Tetrad (Maximal Color Differences)
csphd(hcl(h = c(30, 120, 210, 300)))

# Same, but lighter and less colorful
# Turn off automatic correction to make sure
# that we have defined real colors.
csphd(hcl(h = c(30, 120, 210, 300),
          c = 20, l = 90, fixup = FALSE))

# Analogous Colors
# Good for those with red/green color confusion
csphd(hcl(h = seq(60, 240, by = 60)))

# Metaphorical Colors
csphd(hcl(h = seq(210, 60, length = 4)))

# Cool Colors
csphd(hcl(h = seq(120, 0, length = 4) + 150))

# Warm Colors
csphd(hcl(h = seq(120, 0, length = 4) - 30))

# Single Color
hist(stats::rnorm(1000), col = hcl(240))



cleanEx()
nameEx("hsv")
### * hsv

flush(stderr()); flush(stdout())

### Name: hsv
### Title: HSV Color Specification
### Aliases: hsv
### Keywords: color dplot

### ** Examples

require(graphics)

hsv(.5,.5,.5)

## Red tones:
n <- 20;  y <- -sin(3*pi*((1:n)-1/2)/n)
op <- par(mar=rep(1.5,4))
plot(y, axes = FALSE, frame.plot = TRUE,
     xlab = "", ylab = "", pch = 21, cex = 30,
     bg = rainbow(n, start=.85, end=.1),
     main = "Red tones")
par(op)



graphics::par(get("par.postscript", pos = 'CheckExEnv'))
cleanEx()
nameEx("make.rgb")
### * make.rgb

flush(stderr()); flush(stdout())

### Name: make.rgb
### Title: Create colour spaces
### Aliases: make.rgb colorConverter
### Keywords: color

### ** Examples

(pal <- make.rgb(red=  c(0.6400, 0.3300),
                 green=c(0.2900, 0.6000),
                 blue= c(0.1500, 0.0600),
                 name = "PAL/SECAM RGB"))

## converter for sRGB in #rrggbb format
hexcolor <- colorConverter(toXYZ = function(hex,...) {
                            rgb <- t(col2rgb(hex))/255
                            colorspaces$sRGB$toXYZ(rgb, ...) },
                           fromXYZ = function(xyz,...) {
                              rgb <- colorspaces$sRGB$fromXYZ(xyz, ..)
                              rgb <- round(rgb,5)
                              if (min(rgb) < 0 || max(rgb) > 1)
                                   as.character(NA)
                              else rgb(rgb[1], rgb[2], rgb[3])},
                           white = "D65", name = "#rrggbb")

(cols <- t(col2rgb(palette())))
zapsmall(luv <- convertColor(cols,from="sRGB", to="Luv", scale.in=255))
(hex <- convertColor(luv, from="Luv",  to=hexcolor, scale.out=NULL))

## must make hex a matrix before using it
(cc <- round(convertColor(as.matrix(hex), from= hexcolor, to= "sRGB",
                          scale.in=NULL, scale.out=255)))
stopifnot(cc == cols)



cleanEx()
nameEx("n2mfrow")
### * n2mfrow

flush(stderr()); flush(stdout())

### Name: n2mfrow
### Title: Compute Default mfrow From Number of Plots
### Aliases: n2mfrow
### Keywords: dplot utilities

### ** Examples

require(graphics)

n2mfrow(8) # 3 x 3

n <- 5 ; x <- seq(-2,2, len=51)
## suppose now that 'n' is not known {inside function}
op <- par(mfrow = n2mfrow(n))
for (j in 1:n)
   plot(x, x^j, main = substitute(x^ exp, list(exp = j)), type = "l",
   col = "blue")

sapply(1:10, n2mfrow)



graphics::par(get("par.postscript", pos = 'CheckExEnv'))
cleanEx()
nameEx("nclass")
### * nclass

flush(stderr()); flush(stdout())

### Name: nclass
### Title: Compute the Number of Classes for a Histogram
### Aliases: nclass.Sturges nclass.scott nclass.FD
### Keywords: univar

### ** Examples

set.seed(1)
x <- stats::rnorm(1111)
nclass.Sturges(x)

## Compare them:
NC <- function(x) c(Sturges = nclass.Sturges(x),
      Scott = nclass.scott(x), FD = nclass.FD(x))
NC(x)
onePt <- rep(1, 11)
NC(onePt) # no longer gives NaN



cleanEx()
nameEx("palette")
### * palette

flush(stderr()); flush(stdout())

### Name: palette
### Title: Set or View the Graphics Palette
### Aliases: palette
### Keywords: color sysdata

### ** Examples

require(graphics)

palette()               # obtain the current palette
palette(rainbow(6))     # six color rainbow

(palette(gray(seq(0,.9,len=25)))) # gray scales; print old palette
matplot(outer(1:100,1:30), type='l', lty=1,lwd=2, col=1:30,
        main = "Gray Scales Palette",
        sub = "palette(gray(seq(0,.9,len=25)))")
palette("default")      # reset back to the default

## on a device where alpha-transparency is supported,
##  use 'alpha = 0.3' transparency with the default palette :
mycols <- adjustcolor(palette(), alpha.f = 0.3)
opal <- palette(mycols)
x <- rnorm(1000); xy <- cbind(x, 3*x + rnorm(1000))
plot (xy, lwd=2,
       main = "Alpha-Transparency Palette\n alpha = 0.3")
xy[,1] <- -xy[,1]
points(xy, col=8, pch=16, cex = 1.5)
palette("default")



cleanEx()
nameEx("palettes")
### * palettes

flush(stderr()); flush(stdout())

### Name: Palettes
### Title: Color Palettes
### Aliases: rainbow heat.colors terrain.colors topo.colors cm.colors
### Keywords: color dplot

### ** Examples

require(graphics)
# A Color Wheel
pie(rep(1,12), col=rainbow(12))

##------ Some palettes ------------
demo.pal <-
  function(n, border = if (n<32) "light gray" else NA,
           main = paste("color palettes;  n=",n),
           ch.col = c("rainbow(n, start=.7, end=.1)", "heat.colors(n)",
                      "terrain.colors(n)", "topo.colors(n)",
                      "cm.colors(n)"))
{
    nt <- length(ch.col)
    i <- 1:n; j <- n / nt; d <- j/6; dy <- 2*d
    plot(i,i+d, type="n", yaxt="n", ylab="", main=main)
    for (k in 1:nt) {
        rect(i-.5, (k-1)*j+ dy, i+.4, k*j,
             col = eval(parse(text=ch.col[k])), border = border)
        text(2*j,  k * j +dy/4, ch.col[k])
    }
}
n <- if(.Device == "postscript") 64 else 16
     # Since for screen, larger n may give color allocation problem
demo.pal(n)



cleanEx()
nameEx("pdf")
### * pdf

flush(stderr()); flush(stdout())

### Name: pdf
### Title: PDF Graphics Device
### Aliases: pdf
### Keywords: device

### ** Examples

## Not run: 
##D ## Test function for encodings
##D TestChars <- function(encoding="ISOLatin1", ...)
##D {
##D     pdf(encoding=encoding, ...)
##D     par(pty="s")
##D     plot(c(-1,16), c(-1,16), type="n", xlab="", ylab="",
##D          xaxs="i", yaxs="i")
##D          title(paste("Centred chars in encoding", encoding))
##D     grid(17, 17, lty=1)
##D     for(i in c(32:255)) {
##D         x <- i %% 16
##D         y <- i %/% 16
##D         points(x, y, pch=i)
##D     }
##D     dev.off()
##D }
##D ## there will be many warnings.
##D TestChars("ISOLatin2")
##D ## this does not view properly in older viewers.
##D TestChars("ISOLatin2", family="URWHelvetica")
##D ## works well for viewing in gs-based viewers, and often in xpdf.
## End(Not run)


cleanEx()
nameEx("pdf.options")
### * pdf.options

flush(stderr()); flush(stdout())

### Name: pdf.options
### Title: Auxiliary Function to Set/View Defaults for Arguments of pdf
### Aliases: pdf.options
### Keywords: device

### ** Examples

pdf.options(bg = "pink")
utils::str(pdf.options())
pdf.options(reset = TRUE) # back to factory-fresh



cleanEx()
nameEx("pictex")
### * pictex

flush(stderr()); flush(stdout())

### Name: pictex
### Title: A PicTeX Graphics Driver
### Aliases: pictex
### Keywords: device

### ** Examples

require(graphics)

pictex()
plot(1:11,(-5:5)^2, type='b', main="Simple Example Plot")
dev.off()
##--------------------
## Not run: 
##D %% LaTeX Example
##D \documentclass{article}
##D \usepackage{pictex}
##D \usepackage{graphics} % for \rotatebox
##D \begin{document}
##D %...
##D \begin{figure}[h]
##D   \centerline{\input{Rplots.tex}}
##D   \caption{}
##D \end{figure}
##D %...
##D \end{document}
## End(Not run)
##--------------------
unlink("Rplots.tex")



cleanEx()
nameEx("plotmath")
### * plotmath

flush(stderr()); flush(stdout())

### Name: plotmath
### Title: Mathematical Annotation in R
### Aliases: plotmath symbol plain bold italic bolditalic hat bar dot ring
###   widehat widetilde displaystyle textstyle scriptstyle
###   scriptscriptstyle underline phantom over frac atop integral inf sup
###   group bgroup
### Keywords: aplot

### ** Examples

require(graphics)

x <- seq(-4, 4, len = 101)
y <- cbind(sin(x), cos(x))
matplot(x, y, type = "l", xaxt = "n",
        main = expression(paste(plain(sin) * phi, "  and  ",
                                plain(cos) * phi)),
        ylab = expression("sin" * phi, "cos" * phi), # only 1st is taken
        xlab = expression(paste("Phase Angle ", phi)),
        col.main = "blue")
axis(1, at = c(-pi, -pi/2, 0, pi/2, pi),
     labels = expression(-pi, -pi/2, 0, pi/2, pi))


## How to combine "math" and numeric variables :
plot(1:10, type="n", xlab="", ylab="", main = "plot math & numbers")
theta <- 1.23 ; mtext(bquote(hat(theta) == .(theta)), line= .25)
for(i in 2:9)
    text(i,i+1, substitute(list(xi,eta) == group("(",list(x,y),")"),
                           list(x=i, y=i+1)))
## note that both of these use calls rather than expressions.
##
text(1,10,  "Derivatives:", adj=0)
text(1,9.6, expression(
 "             first: {f * minute}(x) " == {f * minute}(x)), adj=0)
text(1,9.0, expression(
 "     second: {f * second}(x) "        == {f * second}(x)), adj=0)


plot(1:10, 1:10)
text(4, 9, expression(hat(beta) == (X^t * X)^{-1} * X^t * y))
text(4, 8.4, "expression(hat(beta) == (X^t * X)^{-1} * X^t * y)",
     cex = .8)
text(4, 7, expression(bar(x) == sum(frac(x[i], n), i==1, n)))
text(4, 6.4, "expression(bar(x) == sum(frac(x[i], n), i==1, n))",
     cex = .8)
text(8, 5, expression(paste(frac(1, sigma*sqrt(2*pi)), " ",
                            plain(e)^{frac(-(x-mu)^2, 2*sigma^2)})),
     cex = 1.2)

## some other useful symbols
plot.new(); plot.window(c(0,4), c(15,1))
text(1, 1, "universal", adj=0); text(2.5, 1,  "\\042")
text(3, 1, expression(symbol("\042")))
text(1, 2, "existential", adj=0); text(2.5, 2,  "\\044")
text(3, 2, expression(symbol("\044")))
text(1, 3, "suchthat", adj=0); text(2.5, 3,  "\\047")
text(3, 3, expression(symbol("\047")))
text(1, 4, "therefore", adj=0); text(2.5, 4,  "\\134")
text(3, 4, expression(symbol("\134")))
text(1, 5, "perpendicular", adj=0); text(2.5, 5,  "\\136")
text(3, 5, expression(symbol("\136")))
text(1, 6, "circlemultiply", adj=0); text(2.5, 6,  "\\304")
text(3, 6, expression(symbol("\304")))
text(1, 7, "circleplus", adj=0); text(2.5, 7,  "\\305")
text(3, 7, expression(symbol("\305")))
text(1, 8, "emptyset", adj=0); text(2.5, 8,  "\\306")
text(3, 8, expression(symbol("\306")))
text(1, 9, "angle", adj=0); text(2.5, 9,  "\\320")
text(3, 9, expression(symbol("\320")))
text(1, 10, "leftangle", adj=0); text(2.5, 10,  "\\341")
text(3, 10, expression(symbol("\341")))
text(1, 11, "rightangle", adj=0); text(2.5, 11,  "\\361")
text(3, 11, expression(symbol("\361")))



cleanEx()
nameEx("postscriptFonts")
### * postscriptFonts

flush(stderr()); flush(stdout())

### Name: postscriptFonts
### Title: PostScript and PDF Font Families
### Aliases: postscriptFonts pdfFonts
### Keywords: device

### ** Examples

postscriptFonts()
## This duplicates "ComputerModernItalic".
CMitalic <- Type1Font("ComputerModern2",
                      c("CM_regular_10.afm", "CM_boldx_10.afm",
                        "cmti10.afm", "cmbxti10.afm",
                         "CM_symbol_10.afm"),
                      encoding = "TeXtext.enc")
postscriptFonts(CMitalic = CMitalic)

## A CID font for Japanese using a different CMap and
## corresponding cmapEncoding.
`Jp_UCS-2` <- CIDFont("TestUCS2",
                  c("Adobe-Japan1-UniJIS-UCS2-H.afm",
                    "Adobe-Japan1-UniJIS-UCS2-H.afm",
                    "Adobe-Japan1-UniJIS-UCS2-H.afm",
                    "Adobe-Japan1-UniJIS-UCS2-H.afm"),
                  "UniJIS-UCS2-H", "UCS-2")
pdfFonts(`Jp_UCS-2` = `Jp_UCS-2`)
names(pdfFonts())



cleanEx()
nameEx("pretty.Date")
### * pretty.Date

flush(stderr()); flush(stdout())

### Name: pretty.Date
### Title: Pretty Breakpoints for Date-Time Classes
### Aliases: pretty.Date pretty.POSIXt
### Keywords: dplot

### ** Examples


steps <-
    list("10 secs", "1 min", "5 mins", "30 mins", "6 hours", "12 hours",
         "1 DSTday", "2 weeks", "1 month", "6 months", "1 year",
         "10 years", "50 years", "1000 years")

names(steps) <- paste("span =", unlist(steps))

x <- as.POSIXct("2002-02-02 02:02")
lapply(steps,
       function(s) {
           at <- pretty(seq(x, by = s, length = 2), n = 5)
           attr(at, "labels")
       })




cleanEx()
nameEx("ps.options")
### * ps.options

flush(stderr()); flush(stdout())

### Name: ps.options
### Title: Auxiliary Function to Set/View Defaults for Arguments of
###   postscript
### Aliases: ps.options setEPS setPS
### Keywords: device

### ** Examples

ps.options(bg = "pink")
utils::str(ps.options())

### ---- error checking of arguments: ----
ps.options(width=0:12, onefile=0, bg=pi)
# override the check for 'width', but not 'bg':
ps.options(width=0:12, bg=pi, override.check = c(TRUE,FALSE))
utils::str(ps.options())
ps.options(reset = TRUE) # back to factory-fresh



cleanEx()
nameEx("recordGraphics")
### * recordGraphics

flush(stderr()); flush(stdout())

### Name: recordGraphics
### Title: Record Graphics Operations
### Aliases: recordGraphics
### Keywords: device

### ** Examples

require(graphics)

plot(1:10)
# This rectangle remains 1inch wide when the device is resized
recordGraphics(
  {
    rect(4, 2,
         4 + diff(par("usr")[1:2])/par("pin")[1], 3)
  },
  list(),
  getNamespace("graphics"))



graphics::par(get("par.postscript", pos = 'CheckExEnv'))
cleanEx()
nameEx("rgb")
### * rgb

flush(stderr()); flush(stdout())

### Name: rgb
### Title: RGB Color Specification
### Aliases: rgb
### Keywords: color

### ** Examples

rgb(0,1,0)

rgb((0:15)/15, green=0, blue=0, names=paste("red",0:15,sep="."))

rgb(0, 0:12, 0, max = 255)# integer input

ramp <- colorRamp(c("red", "white"))
rgb( ramp(seq(0, 1, length = 5)), max = 255)



cleanEx()
nameEx("rgb2hsv")
### * rgb2hsv

flush(stderr()); flush(stdout())

### Name: rgb2hsv
### Title: RGB to HSV Conversion
### Aliases: rgb2hsv
### Keywords: color dplot

### ** Examples

## These (saturated, bright ones) only differ by hue
(rc <- col2rgb(c("red", "yellow","green","cyan", "blue", "magenta")))
(hc <- rgb2hsv(rc))
6 * hc["h",] # the hues are equispaced

## Don't show: 
set.seed(151)
## End Don't show
(rgb3 <- floor(256 * matrix(stats::runif(3*12), 3,12)))
(hsv3 <- rgb2hsv(rgb3))
## Consistency :
stopifnot(rgb3 == col2rgb(hsv(h=hsv3[1,], s=hsv3[2,], v=hsv3[3,])),
          all.equal(hsv3, rgb2hsv(rgb3/255, maxColorValue = 1)))

## A (simplified) pure R version -- originally by Wolfram Fischer --
## showing the exact algorithm:
rgb2hsvR <- function(rgb, gamma = 1, maxColorValue = 255)
{
    if(!is.numeric(rgb)) stop("rgb matrix must be numeric")
    d <- dim(rgb)
    if(d[1] != 3) stop("rgb matrix must have 3 rows")
    n <- d[2]
    if(n == 0) return(cbind(c(h=1,s=1,v=1))[,0])
    rgb <- rgb/maxColorValue
    if(gamma != 1) rgb <- rgb ^ (1/gamma)

    ## get the max and min
    v <- apply( rgb, 2, max)
    s <- apply( rgb, 2, min)
    D <- v - s # range

    ## set hue to zero for undefined values (gray has no hue)
    h <- numeric(n)
    notgray <- ( s != v )

    ## blue hue
    idx <- (v == rgb[3,] & notgray )
    if (any (idx))
        h[idx] <- 2/3 + 1/6 * (rgb[1,idx] - rgb[2,idx]) / D[idx]
    ## green hue
    idx <- (v == rgb[2,] & notgray )
    if (any (idx))
        h[idx] <- 1/3 + 1/6 * (rgb[3,idx] - rgb[1,idx]) / D[idx]
    ## red hue
    idx <- (v == rgb[1,] & notgray )
    if (any (idx))
        h[idx] <-       1/6 * (rgb[2,idx] - rgb[3,idx]) / D[idx]

    ## correct for negative red
    idx <- (h < 0)
    h[idx] <- 1+h[idx]

    ## set the saturation
    s[! notgray] <- 0;
    s[notgray] <- 1 - s[notgray] / v[notgray]

    rbind( h=h, s=s, v=v )
}

## confirm the equivalence:
all.equal(rgb2hsv (rgb3),
          rgb2hsvR(rgb3), tol=1e-14) # TRUE



cleanEx()
nameEx("trans3d")
### * trans3d

flush(stderr()); flush(stdout())

### Name: trans3d
### Title: 3D to 2D Transformation for Perspective Plots
### Aliases: trans3d
### Keywords: dplot

### ** Examples

## See  help(persp) {after attaching the 'graphics' package}
##      -----------



cleanEx()
nameEx("xy.coords")
### * xy.coords

flush(stderr()); flush(stdout())

### Name: xy.coords
### Title: Extracting Plotting Structures
### Aliases: xy.coords
### Keywords: dplot

### ** Examples

xy.coords(stats::fft(c(1:9)), NULL)

with(cars, xy.coords(dist ~ speed, NULL)$xlab ) # = "speed"

xy.coords(1:3, 1:2, recycle=TRUE)
xy.coords(-2:10,NULL, log="y")
##> warning: 3 y values <=0 omitted ..



cleanEx()
nameEx("xyTable")
### * xyTable

flush(stderr()); flush(stdout())

### Name: xyTable
### Title: Multiplicities of (x,y) Points, e.g., for a Sunflower Plot
### Aliases: xyTable
### Keywords: dplot

### ** Examples

xyTable(iris[,3:4], digits = 6)

## Discretized uncorrelated Gaussian:
## Don't show: 
set.seed(1)
## End Don't show
require(stats)
xy <- data.frame(x = round(sort(rnorm(100))), y = rnorm(100))
xyTable(xy, digits = 1)



cleanEx()
nameEx("xyz.coords")
### * xyz.coords

flush(stderr()); flush(stdout())

### Name: xyz.coords
### Title: Extracting Plotting Structures
### Aliases: xyz.coords
### Keywords: dplot

### ** Examples

xyz.coords(data.frame(10*1:9, -4), y = NULL, z = NULL)

xyz.coords(1:5, stats::fft(1:5), z = NULL, xlab = "X", ylab = "Y")

y <- 2 * (x2 <- 10 + (x1 <- 1:10))
xyz.coords(y ~ x1 + x2, y = NULL, z = NULL)

xyz.coords(data.frame(x = -1:9, y = 2:12, z = 3:13), y = NULL, z = NULL,
           log = "xy")
##> Warning message: 2 x values <= 0 omitted ...



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
