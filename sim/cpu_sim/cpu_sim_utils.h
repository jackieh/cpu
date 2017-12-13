#pragma once

#include "cpu_sim.h"

#include <string>

// Explicitly label an unused parameter or unused variable when needed, such
// as when a function is not yet implemented. An unused parameter indicates
// either an incomplete function or a function with an incorrect type signature.
#define UNUSED(name) name __attribute__((unused))

// Order must match instruction encoding.
typedef enum {
    LSL,
    LSR,
    ASR,
    ROR
} shift_type;

std::string string_format(const std::string fmt_str, ...);
uint32_t shiftwith(uint32_t value, uint32_t shiftamt, shift_type stype);
uint32_t rand32();
