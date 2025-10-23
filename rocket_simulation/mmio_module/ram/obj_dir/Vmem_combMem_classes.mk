# Verilated -*- Makefile -*-
# DESCRIPTION: Verilator output: Make include file with class lists
#
# This file lists generated Verilated files, for including in higher level makefiles.
# See Vmem_combMem.mk for the caller.

### Switches...
# C11 constructs required?  0/1 (always on now)
VM_C11 = 1
# Timing enabled?  0/1
VM_TIMING = 0
# Coverage output mode?  0/1 (from --coverage)
VM_COVERAGE = 0
# Parallel builds?  0/1 (from --output-split)
VM_PARALLEL_BUILDS = 0
# Tracing output mode?  0/1 (from --trace/--trace-fst)
VM_TRACE = 1
# Tracing output mode in VCD format?  0/1 (from --trace)
VM_TRACE_VCD = 1
# Tracing output mode in FST format?  0/1 (from --trace-fst)
VM_TRACE_FST = 0

### Object file lists...
# Generated module classes, fast-path, compile with highest optimization
VM_CLASSES_FAST += \
	Vmem_combMem \
	Vmem_combMem___024root__DepSet_hd928937b__0 \
	Vmem_combMem___024root__DepSet_he26e3fc5__0 \
	Vmem_combMem_dpi_mem_pkg__DepSet_h75d22068__0 \

# Generated module classes, non-fast-path, compile with low/medium optimization
VM_CLASSES_SLOW += \
	Vmem_combMem___024root__Slow \
	Vmem_combMem___024root__DepSet_hd928937b__0__Slow \
	Vmem_combMem___024root__DepSet_he26e3fc5__0__Slow \
	Vmem_combMem_dpi_mem_pkg__Slow \
	Vmem_combMem_dpi_mem_pkg__DepSet_h8e37ccb4__0__Slow \

# Generated support classes, fast-path, compile with highest optimization
VM_SUPPORT_FAST += \
	Vmem_combMem__Dpi \
	Vmem_combMem__Trace__0 \

# Generated support classes, non-fast-path, compile with low/medium optimization
VM_SUPPORT_SLOW += \
	Vmem_combMem__Syms \
	Vmem_combMem__Trace__0__Slow \
	Vmem_combMem__TraceDecls__0__Slow \

# Global classes, need linked once per executable, fast-path, compile with highest optimization
VM_GLOBAL_FAST += \
	verilated \
	verilated_dpi \
	verilated_vcd_c \
	verilated_threads \

# Global classes, need linked once per executable, non-fast-path, compile with low/medium optimization
VM_GLOBAL_SLOW += \


# Verilated -*- Makefile -*-
