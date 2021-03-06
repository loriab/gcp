REM load Intel compilers
for /f "tokens=* usebackq" %%f in (`dir /b "C:\Program Files (x86)\Intel\oneAPI\compiler\" ^| findstr /V latest ^| sort`) do @set "LATEST_VERSION=%%f"
echo %LATEST_VERSION%
@call "C:\Program Files (x86)\Intel\oneAPI\compiler\%LATEST_VERSION%\env\vars.bat"

cmake -G"Ninja" ^
      -S%SRC_DIR% ^
      -Bbuild ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DCMAKE_Fortran_COMPILER=ifort ^
      -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
      -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
      -DCMAKE_INSTALL_LIBDIR="%LIBRARY_LIB%" ^
      -DCMAKE_INSTALL_INCLUDEDIR="%LIBRARY_INC%" ^
      -DCMAKE_INSTALL_BINDIR="%LIBRARY_BIN%" ^
      -DCMAKE_INSTALL_DATADIR="%LIBRARY_PREFIX%" ^
      -DCMAKE_Fortran_FLAGS="/wd4101 /wd4996 /static %CFLAGS%" ^
      -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON ^
      -DBUILD_SHARED_LIBS=ON ^
      -DBUILD_TESTING=OFF
if errorlevel 1 exit 1

REM build and install
cmake --build build ^
      --config Release ^
      --target install ^
      -- -j %CPU_COUNT% ^
      --verbose
if errorlevel 1 exit 1

REM test
REM no independent tests
