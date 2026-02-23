# AES-XOR Async Integration Notes

## Overview

This document summarizes the implementation added for:

- Asynchronous AES submission from firmware
- Integrated AES->XOR execution without `while(AES_START_REG)` waiting
- Pipeline-like multi in-flight AES jobs
- Completion tracking by `AES_LAST_DONE_ID` (contiguous max completed ID)

The implementation follows the agreed rule:

- Firmware compares its expected ID with `AES_LAST_DONE_ID`
- A job is considered complete when `expected_id <= AES_LAST_DONE_ID`

## New Files

### riscv-isa-sim side

- `rocket-chip/riscv-isa-sim/riscv/mmio_devices/aes_xor_async_addrmap.h`
  - New MMIO address map and bit fields for async AES-XOR block.
- `rocket-chip/riscv-isa-sim/riscv/mmio_devices/aes_device_async_id.h`
  - New async AES device with in-flight queue and contiguous done-ID commit logic.
- `rocket-chip/riscv-isa-sim/riscv/mmio_devices/xor_device_async.h`
  - New XOR backend for integrated execution using XOR config metadata.

### spike_simulation side

- `rocket-chip/mmio_project/spike_simulation/mmio_reg/aes_xor_async_reg.h`
  - Firmware MMIO register macros for the async block.
- `rocket-chip/mmio_project/spike_simulation/inc/aes_xor_async.h`
  - Firmware helper API: nonce write, cfg pack, submit, done check.

## Modified Files

### riscv-isa-sim side

- `rocket-chip/riscv-isa-sim/riscv/mmio_devices/spm_device.h`
  - No new DMA-ID API required for this async path.

- `rocket-chip/riscv-isa-sim/riscv/sim.cc`
  - Registered the new async AES block at:
  - `aes_xor_async_addrmap_t::BASE`
  - Wired async XOR backend with SPM and AXIM:
  - `bind_spm(spm.get())`
  - `bind_axim(axim.get())`

## MMIO Spec (Async AES-XOR Block)

Base:

- `AES_XOR_ASYNC_BASE = MEMREQ_BASE + MEMREQ_CTRL_SIZE`

Registers:

- `+0x00 .. +0x38`: `NONCE_0..7` (W, 64B nonce)
- `+0x40`: `CTRL` (W)
  - bit0: `START`
  - bit1: `LAST_IN_GROUP`
  - bit33:2: `AES_ID[31:0]`
- `+0x48`: `XOR_CFG` (W)
  - bit0: `XOR_IN_FROM_REQIO`
  - bit1: `XOR_OUT_TO_REQIO`
  - bit30:2: `SPM_OFFSET[28:0]`
  - bit62:31: `DMA_ID[31:0]`
- `+0x50`: `LAST_DONE_ID` (R)
  - Contiguous maximum completed AES ID
- `+0x58`: `STATUS` (R)
  - bit0: queue full
- `+0x60`: `INFLIGHT` (R)
  - current in-flight job count

## Data Path Integration (Implemented)

`xor_device_async.h` now applies XOR config fields to actual data movement:

Input side:

- `input_from_reqio = 1`
  - Source data from AXIM buffer (`axim->copy`)
- `input_from_reqio = 0`
  - Source data from SPM (`spm->read_local_64(spm_offset)`)

Output side:

- `output_to_reqio = 1`
  - Write result to AXIM read buffer (`axim->write`)
- `output_to_reqio = 0`
  - Write result back to SPM (`spm->write_local_64(spm_offset)`)

DMA freshness guard:

- Before SPM source copy, XOR path checks SPM completion state using
  existing SPM-side complete-ID access (device API / complete-id register read).
- If `dma_id > complete_id`, the integrated XOR run is rejected for that cycle.

## Completion Rule

In `aes_device_async_id.h`:

- Job completion can occur internally in any timing.
- `LAST_DONE_ID` is updated only when contiguous IDs are completed.
- The device keeps a set of completed-but-not-committed IDs and advances:
  - `while (last_done_id + 1 is completed) last_done_id++`

This exactly matches the agreed firmware check rule.

## Firmware Operation (Expected)

Using `inc/aes_xor_async.h`:

1. Prepare nonce words (8x64-bit).
2. Build XOR config (`input_dir`, `output_dir`, `spm_offset`, `dma_id`).
3. Submit with `aes_id` and `last_in_group`.
4. Poll `AES_XOR_ASYNC_LAST_DONE_REG`.
5. Complete when `expected_id <= last_done_id`.

Helper functions:

- `aes_xor_async_submit64(...)`
- `aes_xor_async_last_done_id()`
- `aes_xor_async_is_done(expected_id)`

## Notes

- Legacy AES/XOR path remains present; async path is added as a new block.
- Existing firmware files were not refactored in this change.
- This document reflects only the implementation done in this work session.
