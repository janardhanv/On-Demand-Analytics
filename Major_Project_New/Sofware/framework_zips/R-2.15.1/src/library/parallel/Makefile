#
# ${R_HOME}/src/library/parallel/Makefile


srcdir = .
top_srcdir = ../../..

top_builddir = ../../..
subdir = src/library/parallel

include $(top_builddir)/Makeconf

distdir = $(top_builddir)/$(PACKAGE)-$(VERSION)/$(subdir)
DISTFILES = AUTHORS DESCRIPTION.in Makefile.in Makefile.win NAMESPACE

pkg = parallel

RSRC = `LC_COLLATE=C ls $(srcdir)/R/*.R $(srcdir)/R/$(R_OSTYPE)/*.R`
INSTDIRS = doc

R_EXE = $(top_builddir)/bin/R --vanilla --slave
DEFPKGS = NULL

all: Makefile DESCRIPTION
	@$(ECHO) "building package '$(pkg)'"
	@$(MKINSTALLDIRS) $(top_builddir)/library/$(pkg)
	@$(MKINSTALLDIRS) $(top_builddir)/library/$(pkg)/doc
	@$(MAKE) mkR1 mkdesc instdirs mkpo
	@$(MAKE) mksrc
#	@$(MAKE) mklazy
	@$(MAKE) mklazycomp

mkR: mkR1

include $(top_srcdir)/share/make/basepkg.mk
include $(top_srcdir)/share/make/lazycomp.mk
