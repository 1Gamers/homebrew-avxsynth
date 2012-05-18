include config.mak
include config.targets

ifeq ($(SRCPATH),.)
        SRCPATH="$(shell pwd)"
endif

DIRS = \
	avxutils                           \
	avxsynth/builtinfunctions          \
	avxsynth/core                      \
	plugins/autocrop                   \
	plugins/avxffms2                   \
	plugins/avxframecapture            \
	plugins/avxsubtitle                \
	apps/avxframeserver/frameserverapp \
	apps/AVXEdit

INSTALLED = \
	$(libdir)/libavxutils$(SONAME)            \
	$(libdir)/libavxsynth$(SONAME)            \
	$(pcdir)/avxsynth.pc                      \
	$(pluginsdir)/libautocrop$(SONAME)        \
	$(pluginsdir)/libavxffms2$(SONAME)        \
	$(pluginsdir)/libavxframecapture$(SONAME) \
	$(pluginsdir)/libavxsubtitle$(SONAME)     \
	$(bindir)/avxFrameServer$(EXE)            \
	$(bindir)/AVXEdit$(EXE)

HEADERS = \
	avxiface.h                              \
	avxlog.h                                \
	avxplugin.h                             \
	utils/AvxTextRender.h                   \
	utils/AvxString.h                       \
	utils/Path.h                            \
	utils/Size.h                            \
	utils/AvxException.h                    \
	utils/TextConfig.h                      \
	utils/TextLayout.h                      \
	windowsPorts/MMRegLinux.h               \
	windowsPorts/WinNTLinux.h               \
	windowsPorts/VfwLinux.h                 \
	windowsPorts/excptLinux.h               \
	windowsPorts/basicDataTypeConversions.h \
	windowsPorts/WinBaseLinux.h             \
	windowsPorts/WinDefLinux.h              \
	windowsPorts/windows2linux.h            \
	windowsPorts/WinGDILinux.h              \
	windowsPorts/UnknwnLinux.h

avxutils:
	$(MAKE) -f $(SRCPATH)/avxutils/Makefile -C avxutils
builtinfunctions: avxutils
	$(MAKE) -f $(SRCPATH)/avxsynth/builtinfunctions/Makefile -C avxsynth/builtinfunctions
core: avxutils builtinfunctions
	$(MAKE) -f $(SRCPATH)/avxsynth/core/Makefile -C avxsynth/core
autocrop: core
	$(MAKE) -f $(SRCPATH)/plugins/autocrop/Makefile -C plugins/autocrop
avxffms2: core
	$(MAKE) -f $(SRCPATH)/plugins/avxffms2/Makefile -C plugins/avxffms2
avxframecapture: core
	$(MAKE) -f $(SRCPATH)/plugins/avxframecapture/Makefile -C plugins/avxframecapture
avxsubtitle: core
	$(MAKE) -f $(SRCPATH)/plugins/avxsubtitle/Makefile -C plugins/avxsubtitle
frameserverlib: core
	$(MAKE) -f $(SRCPATH)/apps/avxframeserver/frameserverlib/Makefile -C apps/avxframeserver/frameserverlib
avxframeserver: frameserverlib
	$(MAKE) -f $(SRCPATH)/apps/avxframeserver/frameserverapp/Makefile -C apps/avxframeserver/frameserverapp
avxedit: frameserverlib
	$(MAKE) -f $(SRCPATH)/apps/AVXEdit/Makefile -C apps/AVXEdit

core-install: core header-install
	$(MAKE) -f $(SRCPATH)/avxutils/Makefile -C avxutils install
	$(MAKE) -f $(SRCPATH)/avxsynth/builtinfunctions/Makefile -C avxsynth/builtinfunctions install
	$(MAKE) -f $(SRCPATH)/avxsynth/core/Makefile -C avxsynth/core install
autocrop-install: autocrop
	$(MAKE) -f $(SRCPATH)/plugins/autocrop/Makefile -C plugins/autocrop install
avxffms2-install: avxffms2
	$(MAKE) -f $(SRCPATH)/plugins/avxffms2/Makefile -C plugins/avxffms2 install
avxframecapture-install: avxframecapture
	$(MAKE) -f $(SRCPATH)/plugins/avxframecapture/Makefile -C plugins/avxframecapture install
avxsubtitle-install: avxsubtitle
	$(MAKE) -f $(SRCPATH)/plugins/avxsubtitle/Makefile -C plugins/avxsubtitle install
avxframeserver-install: avxframeserver
	$(MAKE) -f $(SRCPATH)/apps/avxframeserver/frameserverapp/Makefile -C apps/avxframeserver/frameserverapp install
avxedit-install: avxedit
	$(MAKE) -f $(SRCPATH)/apps/AVXEdit/Makefile -C apps/AVXEdit install

header-install:
	install -T -m 644 -D avxsynth.pc $(pcdir)/avxsynth.pc
	for header in $(HEADERS); do \
		install -T -m 644 -D $(SRCPATH)/include/$$header $(includedir)/$$header; \
	done

clean:
	for dir in $(DIRS); do \
		$(MAKE) -f $(SRCPATH)/$$dir/Makefile -C $$dir clean; \
	done

distclean: clean
	-rm config.log config.mak config.targets avxsynth.pc

test:
	echo "Testing..."

uninstall:
	-rm $(INSTALLED)
	-rmdir $(pluginsdir)
	-rmdir $(pcdir)
	-for header in $(HEADERS); do \
		rm $(includedir)/$$header; \
	done
	-rmdir $(includedir)/utils $(includedir)/windowsPorts
	-rmdir $(includedir)
	-rmdir $(libdir)
	-rmdir $(bindir)

.PHONY: avxutils builtinfunctions core autocrop avxffms2 avxframecapture \
	avxsubtitle avxframeserver avxedit core-install autocrop-install \
	avxffms2-install avxframecapture-install avxsubtitle-install \
	avxframeserver-install avxedit-install header-install default install \
	clean distclean test uninstall
