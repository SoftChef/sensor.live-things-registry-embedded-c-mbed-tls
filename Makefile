CC = gcc
WARNING_CFLAGS ?= -Wall -W -Wdeclaration-after-statement
LDFLAGS ?=

ifdef WINDOWS
WINDOWS_BUILD=1
endif

ifdef WINDOWS_BUILD
DLEXT=dll
EXEXT=.exe
LOCAL_LDFLAGS += -lws2_32
ifdef SHARED
SHARED_SUFFIX=.$(DLEXT)
endif
else
DLEXT ?= so
EXEXT=
SHARED_SUFFIX=
endif

# RSCS=$(wildcard *.c)
# JOB=$(patsubst %.c,%$(EXEXT),$(RSCS))
JOB:= create_key_pair create_certificate create_csr

LOCAL_CFLAGS = $(WARNING_CFLAGS) -I../include -D_FILE_OFFSET_BITS=64
LOCAL_CXXFLAGS = $(WARNING_CXXFLAGS) -I../include -D_FILE_OFFSET_BITS=64
LOCAL_LDFLAGS = -L../library 			\
		-lmbedtls$(SHARED_SUFFIX)	\
		-lmbedx509$(SHARED_SUFFIX)	\
		-lmbedcrypto$(SHARED_SUFFIX)

.SILENT:
all: $(JOB)
.PHONY: all
.PHONY:clean

create_key_pair: create_key_pair.c
	echo "create_key_pair.c"
	$(CC) $(LOCAL_CFLAGS) create_key_pair.c $(LOCAL_LDFLAGS) $(LDFLAGS) -o $@

create_certificate: create_certificate.c
	echo "create_certificate.c"
	$(CC) $(LOCAL_CFLAGS) create_certificate.c $(LOCAL_LDFLAGS) $(LDFLAGS) -o $@

create_csr: create_csr.c
	echo "create_csr"
	$(CC) $(LOCAL_CFLAGS) create_csr.c $(LOCAL_LDFLAGS) $(LDFLAGS) -o $@

clean:
	rm -rf $(JOB)