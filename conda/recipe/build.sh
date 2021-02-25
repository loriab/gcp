
if [ "$(uname)" == "Darwin" ]; then
    OPTS="-msse4.1"


    # for FortranCInterface
    CMAKE_Fortran_FLAGS="${FFLAGS} -L${CONDA_BUILD_SYSROOT}/usr/lib/system/ ${OPTS} -O0"

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -H${SRC_DIR} \
        -Bbuild \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_Fortran_COMPILER=${GFORTRAN} \
        -DCMAKE_Fortran_FLAGS="${CMAKE_Fortran_FLAGS}" \
        -DENABLE_XHOST=OFF
fi


if [ "$(uname)" == "Linux" ]; then

    # Intel multiarch
    OPTS="-msse2 -axCORE-AVX512,CORE-AVX2,AVX -Wl,--as-needed -static-intel -wd10237"

    # load Intel compilers
    set +x
    LATEST_VERSION=$(ls -1 /opt/intel/oneapi/compiler/ | grep -v latest | sort | tail -1)
    source /opt/intel/oneapi/compiler/"$LATEST_VERSION"/env/vars.sh intel64
    set -x

    # link against conda GCC
    ALLOPTS="-gnu-prefix=${HOST}- ${OPTS}"

    # configure
    ${BUILD_PREFIX}/bin/cmake \
        -S${SRC_DIR} \
        -Bbuild \
        -GNinja \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_Fortran_COMPILER=ifort \
        -DCMAKE_Fortran_FLAGS="${ALLOPTS}" \
        -DENABLE_XHOST=OFF
fi

# build and install
cmake --build build --target install -j${CPU_COUNT}

# test
# no independent tests
