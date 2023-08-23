CC = gcc
CFLAGS = -Iinclude/imgtotxt -I/usr/include/ffmpeg -I/usr/include/glib-2.0 -I/usr/lib/glib-2.0/include -I/usr/include/libavformat -Iinclude/miniaudio -O1 `pkg-config --cflags gio-2.0 chafa libavformat fftw3f`
LIBS =  -lpthread -lrt -pthread -lm -lfreeimage -lglib-2.0 `pkg-config --libs gio-2.0 chafa libavformat fftw3f`

OBJDIR = src/obj

SRCS = src/soundgapless.c src/songloader.c src/file.c src/chafafunc.c src/cache.c src/metadata.c src/printfunc.c src/playlist.c src/stringfunc.c src/term.c  src/settings.c src/player.c src/albumart.c src/visuals.c src/cue.c
OBJS = $(SRCS:src/%.c=$(OBJDIR)/%.o)

all: cue

$(OBJDIR)/%.o: src/%.c Makefile | $(OBJDIR)
	$(CC) $(CFLAGS) -c -o $@ $<

$(OBJDIR)/write_ascii.o: include/imgtotxt/write_ascii.c Makefile | $(OBJDIR)
	$(CC) $(CFLAGS) -c -o $@ $<

$(OBJDIR):
	mkdir -p $(OBJDIR)

cue: $(OBJDIR)/write_ascii.o $(OBJS) Makefile
	$(CC) -o cue $(OBJDIR)/write_ascii.o $(OBJS) $(LIBS)

.PHONY: install
install: all
	cp cue /usr/local/bin/

.PHONY: clean
clean:
	rm -rf $(OBJDIR) cue