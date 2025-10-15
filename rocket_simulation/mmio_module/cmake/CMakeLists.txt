cmake_minimum_required(VERSION 3.20)
project(emulator C CXX)

# ===== inputs from Makefile =====
set(TOP "" CACHE STRING "Verilog top module")
set(PREFIX "" CACHE STRING "Verilator class prefix (e.g., VTestHarness)")
set(FILELIST "" CACHE FILEPATH "Path to filelist.f")
set(CSRC "" CACHE STRING "Semicolon-separated list of C++ sources")
set(PLUSARGS "" CACHE FILEPATH "Path to <Config>.plusArgs")
set(SPIKE_ROOT "" CACHE PATH "SPIKE/fesvr prefix")
set(VSRC_DIR "" CACHE PATH "Extra include dir for Verilog -I")

if(NOT EXISTS "${FILELIST}")
  message(FATAL_ERROR "FILELIST not found: ${FILELIST}")
endif()

# ===== deps =====
find_package(Threads REQUIRED)
find_package(Verilator REQUIRED) # needs Verilator's CMake package

include_directories(${SPIKE_ROOT}/include)
link_directories(${SPIKE_ROOT}/lib)

# ===== parse filelist.f into absolute RTL paths =====
file(STRINGS "${FILELIST}" RTL_LINES)
set(RTL_SOURCES "")
get_filename_component(FL_DIR "${FILELIST}" DIRECTORY)
foreach(L IN LISTS RTL_LINES)
  string(STRIP "${L}" L2)
  if(L2 STREQUAL "" OR L2 MATCHES "^#")
    continue()
  endif()
  if(NOT IS_ABSOLUTE "${L2}")
    set(L2 "${FL_DIR}/${L2}")
  endif()
  list(APPEND RTL_SOURCES "${L2}")
endforeach()

# ===== exe target =====
add_executable(emulator ${CSRC})

# ===== C++ flags: Verilator前提のヘッダ/マクロを前置 =====
# -include VTestHarness.h / verilator.h / <Config>.plusArgs
# TEST_HARNESS=PREFIX, VCD トレース有効化
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
  -DVERILATOR -DVM_TRACE=1 -DTEST_HARNESS=${PREFIX} \
  -include VTestHarness.h -include verilator.h -include ${PLUSARGS} \
  -isystem /usr/include/c++/13")

# ===== verilate(): Verilog -> C++ 生成 & ライブラリ作成 =====
set(VERILATOR_ARGS
  -Wno-UNOPTTHREADS -Wno-STMTDLY -Wno-LATCH -Wno-WIDTH
  --trace
  --no-timing
  --x-assign unique
  --output-split 20000
  --output-split-cfuncs 20000
  --max-num-width 1048576
  -I${VSRC_DIR}
)
verilate(emulator
  SOURCES       ${RTL_SOURCES}
  TOP_MODULE    ${TOP}
  PREFIX        ${PREFIX}
  VERILATOR_ARGS ${VERILATOR_ARGS}
)

# ===== link =====
target_link_libraries(emulator PRIVATE Threads::Threads)
target_link_libraries(emulator PRIVATE fesvr -lstdc++)
