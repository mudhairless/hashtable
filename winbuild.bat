@IF "%fbc%"=="" (
    @echo Please run SET FBC=fbc32 or your preferred compiler first
    @goto :eof
)

@echo Clearing Old Build Files
del src\*.o
del lib\*.a
del tests\*.exe
del examples\*.exe

@echo Building Components
%fbc% -c -i inc -w all -g -exx src/core.bas
%fbc% -c -i inc -w all -g -exx src/byte.bas
%fbc% -c -i inc -w all -g -exx src/ubyte.bas
%fbc% -c -i inc -w all -g -exx src/short.bas
%fbc% -c -i inc -w all -g -exx src/ushort.bas
%fbc% -c -i inc -w all -g -exx src/long.bas
%fbc% -c -i inc -w all -g -exx src/ulong.bas
%fbc% -c -i inc -w all -g -exx src/integer.bas
%fbc% -c -i inc -w all -g -exx src/uinteger.bas
%fbc% -c -i inc -w all -g -exx src/longint.bas
%fbc% -c -i inc -w all -g -exx src/ulongint.bas
%fbc% -c -i inc -w all -g -exx src/single.bas
%fbc% -c -i inc -w all -g -exx src/double.bas
%fbc% -c -i inc -w all -g -exx src/string.bas


@echo Building Libraries
%fbc% -lib src/core.o src/byte.o src/ubyte.o src/short.o src/ushort.o src/long.o src/ulong.o src/integer.o src/uinteger.o src/longint.o src/ulongint.o src/single.o src/double.o src/string.o -x lib/libhashtable.a

@echo Building MT Components
@del src\*.o
%fbc% -c -i inc -w all -g -mt -exx src/core.bas
%fbc% -c -i inc -w all -g -mt -exx src/core.bas
%fbc% -c -i inc -w all -g -mt -exx src/byte.bas
%fbc% -c -i inc -w all -g -mt -exx src/ubyte.bas
%fbc% -c -i inc -w all -g -mt -exx src/short.bas
%fbc% -c -i inc -w all -g -mt -exx src/ushort.bas
%fbc% -c -i inc -w all -g -mt -exx src/long.bas
%fbc% -c -i inc -w all -g -mt -exx src/ulong.bas
%fbc% -c -i inc -w all -g -mt -exx src/integer.bas
%fbc% -c -i inc -w all -g -mt -exx src/uinteger.bas
%fbc% -c -i inc -w all -g -mt -exx src/longint.bas
%fbc% -c -i inc -w all -g -mt -exx src/ulongint.bas
%fbc% -c -i inc -w all -g -mt -exx src/single.bas
%fbc% -c -i inc -w all -g -mt -exx src/double.bas
%fbc% -c -i inc -w all -g -mt -exx src/string.bas

@echo Building MT Libraries
%fbc% -mt -lib src/core.o src/byte.o src/ubyte.o src/short.o src/ushort.o src/long.o src/ulong.o src/integer.o src/uinteger.o src/longint.o src/ulongint.o src/single.o src/double.o src/string.o -x lib/libhashtablemt.a

@echo Running Tests
%fbc% -p lib -i inc -w all -g -exx tests/tests.bas
tests\tests.exe

@echo Building examples
%fbc% -p lib -i inc -w all -g -exx examples/basic.bas
%fbc% -p lib -i inc -w all -g -exx examples/iterator.bas
%fbc% -p lib -i inc -w all -g -exx examples/udt.bas
