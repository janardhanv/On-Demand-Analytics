#
# ${R_HOME}/src/extra/zlib/Makefile


srcdir = .
top_srcdir = ../../..

top_builddir = ../../..
subdir = src/extra/zlib
R_HOME = $(top_builddir)

include $(top_builddir)/Makeconf

ZLIB_CPPFLAGS = -I$(srcdir)  -DUSE_MMAP
ALL_CPPFLAGS = $(ZLIB_CPPFLAGS) $(R_XTRA_CPPFLAGS) $(CPPFLAGS) $(DEFS)
## need to be PIC for use in grDevices
ALL_CFLAGS = $(R_XTRA_CFLAGS) $(R_OPENMP_CFLAGS) $(MAIN_CFLAGS) $(CFLAGS) $(CPICFLAGS)

SOURCES = adler32.c compress.c crc32.c deflate.c infback.c \
  inffast.c inflate.c inftrees.c trees.c uncompr.c zutil.c
HEADERS = crc32.h deflate.h inffast.h inffixed.h inflate.h inftrees.h \
  trees.h zconf.h zlib.h zutil.h
DEPENDS = $(SOURCES:.c=.d)
OBJECTS = $(SOURCES:.c=.o)
#ALL_CFLAGS = $(ALL_CFLAGS_LO) -fvisibility=hidden


distdir = $(top_builddir)/$(PACKAGE)-$(VERSION)/$(subdir)
DISTFILES = R_changes README Makefile.in Makefile.win Rzlib.def \
  $(SOURCES) $(HEADERS)
noinst_LIBRARIES =  libz.a
libz_a_SOURCES = $(SOURCES)
libz_a_OBJECTS = $(OBJECTS)


all: Makefile Makedeps R

Makefile: $(srcdir)/Makefile.in \
  $(top_builddir)/config.status \
  $(SOURCES)
	@cd $(top_builddir) && $(SHELL) ./config.status $(subdir)/$@

Makedeps: Makefile $(DEPENDS)
	@cat $(DEPENDS) >> Makefile
	@touch $@

R: Makefile
	@$(MAKE) Makedeps
	@$(MAKE) $(noinst_LIBRARIES)

libz.a: $(libz_a_OBJECTS)
	rm -f $@
	$(AR) cr $@ $(libz_a_OBJECTS)
	$(RANLIB) $@


mostlyclean: clean
clean:
	@-rm -f Makedeps *.d *.o *.lo *.a
distclean: clean
	@-rm -f Makefile
maintainer-clean: distclean

install install-strip uninstall TAGS info dvi check:

distdir: $(DISTFILES)
	@for f in $(DISTFILES); do \
	  test -f $(distdir)/$${f} \
	    || ln $(srcdir)/$${f} $(distdir)/$${f} 2>/dev/null \
	    || cp -p $(srcdir)/$${f} $(distdir)/$${f}; \
	done

## Automagically generated dependencies:

adler32.o: adler32.c zutil.h zlib.h zconf.h ../../../src/include/config.h
compress.o: compress.c zlib.h zconf.h ../../../src/include/config.h
crc32.o: crc32.c zutil.h zlib.h zconf.h ../../../src/include/config.h \
 crc32.h
deflate.o: deflate.c deflate.h zutil.h zlib.h zconf.h \
 ../../../src/include/config.h
infback.o: infback.c zutil.h zlib.h zconf.h ../../../src/include/config.h \
 inftrees.h inflate.h inffast.h inffixed.h
inffast.o: inffast.c zutil.h zlib.h zconf.h ../../../src/include/config.h \
 inftrees.h inflate.h inffast.h
inflate.o: inflate.c zutil.h zlib.h zconf.h ../../../src/include/config.h \
 inftrees.h inflate.h inffast.h inffixed.h
inftrees.o: inftrees.c zutil.h zlib.h zconf.h \
 ../../../src/include/config.h inftrees.h
trees.o: trees.c deflate.h zutil.h zlib.h zconf.h \
 ../../../src/include/config.h trees.h
uncompr.o: uncompr.c zlib.h zconf.h ../../../src/include/config.h
zutil.o: zutil.c zutil.h zlib.h zconf.h ../../../src/include/config.h
