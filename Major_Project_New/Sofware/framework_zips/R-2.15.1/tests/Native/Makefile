#
# ${R_HOME}/tests/Native/Makefile


srcdir = .
top_srcdir = ../..

top_builddir = ../..
subdir = tests/Native

include $(top_builddir)/Makeconf

distdir = $(top_builddir)/$(PACKAGE)-$(VERSION)/$(subdir)

SOURCES_R = check.S
SOURCES_C = Tests.c

DISTFILES = Makefile.in $(SOURCES_R) $(SOURCES_C)

R=$(top_builddir)/bin/R 

all: Makefile R-sources check

Makefile: $(srcdir)/Makefile.in $(top_builddir)/config.status
	@cd $(top_builddir) && $(SHELL) ./config.status $(subdir)/$@

R-sources:
	@if test "$(BUILDDIR_IS_SRCDIR)" = no ; then \
	  for f in $(SOURCES_R); \
	    do $(INSTALL_DATA) $(srcdir)/$${f} .; \
	  done; \
	fi

check: check.S Tests$(SHLIB_EXT)
	$(R) --vanilla < check.S

Tests$(SHLIB_EXT): Tests.o
	$(SHLIB_LINK) -o $@ Tests.o

mostlyclean: clean
clean:
	@if test "$(BUILDDIR_IS_SRCDIR)" = no ; then \
	  rm -f $(SOURCES_R); \
	fi
	@-rm -rf .libs _libs
	@-rm -f *.o *$(SHLIB_EXT) Rplots.ps
distclean: clean
	@-rm -f Makefile
maintainer-clean: distclean

distdir: $(DISTFILES)
	@for f in $(DISTFILES); do \
	  test -f $(distdir)/$${f} \
	    || ln $(srcdir)/$${f} $(distdir)/$${f} 2>/dev/null \
	    || cp -p $(srcdir)/$${f} $(distdir)/$${f}; \
	done
