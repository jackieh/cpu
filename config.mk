# Caution: files must not have the same name -- they get flattened down
# later!

RTL_COMMON = \
	rtl/mcpu.v \
	rtl/MCPU_int.v \
	rtl/mc/MCPU_MEM_ltc.v \
	rtl/mc/MCPU_MEM_LTC_bram.sv \
	rtl/mc/MCPU_MEM_arb.v \
	rtl/mc/MCPU_MEM_preload.v \
	rtl/lib/FIFO.v \
	rtl/lib/register.v \
	rtl/lib/reg_2.v \
	rtl/lib/altsyncram.v \
	rtl/core/MCPU_core.v \
	rtl/core/MCPU_CORE_stage_fetch.v \
	rtl/core/MCPU_CORE_stage_fetchtlb.v \
	rtl/core/MCPU_CORE_decode.v \
	rtl/core/MCPU_CORE_alu.v \
	rtl/core/MCPU_CORE_regfile.v \
	rtl/core/MCPU_CORE_scoreboard.v \
	rtl/core/cache/MCPU_CACHE_ic_dummy.v \
	rtl/core/cache/MCPU_CACHE_tlb_dummy.v \
	rtl/core/MCPU_CORE_coproc.v \
	rtl/core/MCPU_CORE_exn_encode.v \
	rtl/core/MCPU_CORE_stage_mem.v \
	rtl/soc/uart.v \
	rtl/soc/MCPU_SOC_mmio.v

RTL_FPGA = \
	$(wildcard rtl/mc/lpddr2_phy/*.v rtl/mc/lpddr2_phy/*.sv) \
	rtl/mc/lpddr2_phy.v \
	rtl/mc/MCPU_mc.v
	
RTL_SIM = \
	rtl/tb/TB_MCPU_MEM_arb.v \
	rtl/tb/TB_MCPU_MEM_preload.v \
	rtl/tb/TB_MCPU_core.v

# .vh files and other misc things needed for sim or synth
RTL_INC = \
	$(wildcard rtl/mc/lpddr2_phy/*.hex) \
	rtl/mc/MCPU_MEM_ltc.vh \
	rtl/lib/clog2.vh \
	rtl/core/oper_type.vh \
	rtl/core/exn_codes.vh


SIM_TOP_FILE = mcpu.v
SIM_TOP_NAME = mcpu

FPGA_PROJ = mcpu

# Not necessary yet, but if we become larger and run out of address space,
# we'll need this.
#
# FPGA_TOOL_BITS = --64bit

### Tests ###

# Testplans available:
#  L0: basic sanity: L0 should pass *quickly*.
#  L1: slightly longer tests: L1 may take a little longer.
#  L9: randoms: L9 is expected to grow to be an hour or so.

ALL_TESTPLANS = L0 L1 L9

TESTPLAN_L0_name  = level0 sanity
TESTPLAN_L0_tests =

TESTPLAN_L1_name  = level1 regressions
TESTPLAN_L1_tests = 

TESTPLAN_L9_name  = level9 randoms
TESTPLAN_L9_tests =

# L2C tests

TB_ltc_top  = MCPU_MEM_ltc
TB_ltc_cpps = ltc.cpp Sim.cpp Cmod_MCPU_MEM_mc.cpp Stim_MCPU_MEM.cpp Check_MCPU_MEM.cpp
ALL_TBS += ltc

TEST_ltc_basic_tb   = ltc
TEST_ltc_basic_env  = LTC_DIRECTED_TEST_NAME=basic

TEST_ltc_backtoback_tb   = ltc
TEST_ltc_backtoback_env  = LTC_DIRECTED_TEST_NAME=backtoback

TEST_ltc_evict_tb   = ltc
TEST_ltc_evict_env  = LTC_DIRECTED_TEST_NAME=evict

TEST_ltc_regress_two_set_tb   = ltc
TEST_ltc_regress_two_set_env  = LTC_DIRECTED_TEST_NAME=regress_two_set

TESTPLAN_L0_tests += ltc_basic ltc_backtoback ltc_evict
TESTPLAN_L1_tests += ltc_regress_two_set
ALL_TESTS += ltc_basic ltc_backtoback ltc_evict ltc_regress_two_set

TEST_ltc_random_0_tb = ltc
TEST_ltc_random_0_env = LTC_DIRECTED_TEST_NAME=random SIM_RANDOM_SEED=0 LTC_RANDOM_ADDRESSES=256 LTC_RANDOM_OPERATIONS=4096
TESTPLAN_L1_tests += ltc_random_0
ALL_TESTS += ltc_random_0

TEST_ltc_random_long_tb = ltc
TEST_ltc_random_long_env = LTC_DIRECTED_TEST_NAME=random LTC_RANDOM_OPERATIONS=262144
TESTPLAN_L9_tests += ltc_random_long
ALL_TESTS += ltc_random_long


# ARB tests

TB_arb_top  = TB_MCPU_MEM_arb
TB_arb_cpps = arb.cpp Sim.cpp Stim_MCPU_MEM.cpp Check_MCPU_MEM.cpp Cmod_MCPU_MEM_mc.cpp
ALL_TBS += arb

TEST_arb_basic_tb  = arb
TEST_arb_basic_env =

TEST_arb_random_0_tb  = arb
TEST_arb_random_0_env = ARB_DIRECTED_TEST_NAME=random SIM_RANDOM_SEED=0 ARB_RANDOM_ADDRESSES=256 ARB_RANDOM_OPERATIONS=4096

TEST_arb_random_long_tb  = arb
TEST_arb_random_long_env = ARB_DIRECTED_TEST_NAME=random ARB_RANDOM_OPERATIONS=262144

TESTPLAN_L0_tests += arb_basic
TESTPLAN_L1_tests += arb_random_0
TESTPLAN_L9_tests += arb_random_long
ALL_TESTS += arb_basic arb_random_0 arb_random_long

# Preloader tests

TB_pre_top = TB_MCPU_MEM_preload
TB_pre_cpps = pre.cpp Sim.cpp Stim_MCPU_MEM.cpp Check_MCPU_MEM.cpp Cmod_MCPU_MEM_mc.cpp
ALL_TBS += pre

TEST_pre_basic_tb = pre
TEST_pre_basic_env =
TEST_pre_basic_rom = sim/rom/bytes.hex
ALL_TESTS += pre_basic

TB_int_top = MCPU_int
TB_int_cpps =
ALL_TBS += int

TB_core_sim_top = MCPU_core
TB_core_sim_cpps = core_sim.cpp Sim.cpp
ALL_TBS += core_sim

TB_core_sys_top = TB_MCPU_core
TB_core_sys_cpps = core_sys.cpp Sim.cpp
ALL_TBS += core_sys

