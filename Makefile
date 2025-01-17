CHAINPREFIX=/opt/miyoo
CROSS_COMPILE=$(CHAINPREFIX)/bin/arm-miyoo-linux-uclibcgnueabi-

BUILDTIME=$(shell date +'\"%Y-%m-%d %H:%M\"')

CC = $(CROSS_COMPILE)gcc
CXX = $(CROSS_COMPILE)g++
STRIP = $(CROSS_COMPILE)strip
SYSROOT     := $(CHAINPREFIX)/arm-miyoo-linux-uclibcgnueabi/sysroot
SDL_CFLAGS  := $(shell $(SYSROOT)/usr/bin/sdl-config --cflags)

OUTPUTNAME = daemon

DEFINES = -DHAVE_STDINT_H
INCLUDES = -Iinclude $(SDL_CFLAGS)
OPT_FLAGS  = -Ofast -fdata-sections -fdata-sections -fno-common -fno-PIC -flto
EXTRA_LDFLAGS = -Wl,--as-needed -Wl,--gc-sections -flto -s

CFLAGS = $(DEFINES) $(INCLUDES) $(OPT_FLAGS) -std=gnu11
CXXFLAGS = $(DEFINES) $(INCLUDES) $(OPT_FLAGS) -std=gnu++11
LDFLAGS = -Wl,--start-group -lSDL -lSDL_image -lpng -ljpeg -lSDL_mixer -lfreetype -lSDL_ttf -logg -lvorbisidec -lm -pthread -lz -lstdc++ $(EXTRA_LDFLAGS) -Wl,--end-group

# Redream (main engine)
OBJS =  \
	main.o

.c.o:
	$(CC) $(CFLAGS) -c -o $@ $<

.cpp.o:
	$(CXX) $(CXXFLAGS) -c -o $@ $<

all: executable

executable : $(OBJS)
	$(CC) -o $(OUTPUTNAME) $(OBJS) $(CFLAGS) $(LDFLAGS)

clean:
	rm $(OBJS) $(OUTPUTNAME)
