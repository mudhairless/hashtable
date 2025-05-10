COMPILER = fbc
COMPILE_OPTS = -i inc -g -w all -exx
LINK_OPTS = -lib
TEST_COMPILE_OPTS = -i inc -p lib -g -w all -exx

all: lib/libhashtable.a lib/libhashtablemt.a

%.o: %.bas 
	$(COMPILER) $(COMPILE_OPTS) -c $< -o $@

%.mt.o: %.bas
	$(COMPILER) $(COMPILE_OPTS) -mt -c $< -o $@

lib/libhashtable.a: src/core.o src/byte.o src/ubyte.o src/short.o src/ushort.o src/long.o src/ulong.o src/integer.o src/uinteger.o src/longint.o src/ulongint.o src/single.o src/double.o src/string.o
	$(COMPILER) $(LINK_OPTS) -x lib/libhashtable.a src/core.o src/byte.o src/ubyte.o src/short.o src/ushort.o src/long.o src/ulong.o src/integer.o src/uinteger.o src/longint.o src/ulongint.o src/single.o src/double.o src/string.o

lib/libhashtablemt.a: src/core.mt.o src/byte.mt.o src/ubyte.mt.o src/short.mt.o src/ushort.mt.o src/long.mt.o src/ulong.mt.o src/integer.mt.o src/uinteger.mt.o src/longint.mt.o src/ulongint.mt.o src/single.mt.o src/double.mt.o src/string.mt.o
	$(COMPILER) $(LINK_OPTS) -x lib/libhashtablemt.a src/core.mt.o src/byte.mt.o src/ubyte.mt.o src/short.mt.o src/ushort.mt.o src/long.mt.o src/ulong.mt.o src/integer.mt.o src/uinteger.mt.o src/longint.mt.o src/ulongint.mt.o src/single.mt.o src/double.mt.o src/string.mt.o

clean:
	rm src/*.o lib/*.a 

.PHONY: clean
