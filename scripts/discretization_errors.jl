using FRFPlots; 
using FRFComparisons
using Statistics

const PLOT_DATA = "../"

cssf_result, cssf2_result, csac_result, frfsm_result = collect_summaries(
    PLOT_DATA * "plots_sim/gw_fs_plastic_transdec_E=2_1_m=13_nev=400_rho=1008_a=0_lf=0_05_sw=1k.csv",
    PLOT_DATA * "plots_sim/gw_fs_plastic_transdec_E=2_1_m=10_nev=400_rho=1008_a=0_lf=0_05_sw=1k.csv",
    )
@show stats(cssf_result)
@show stats(cssf2_result)
@show stats(csac_result)
@show stats(frfsm_result)


cssf_result, cssf2_result, csac_result, frfsm_result = collect_summaries(
    PLOT_DATA * "plots_sim/gw_fs_plastic_transdec_E=2_1_m=10_nev=400_rho=1008_a=0_lf=0_05_sw=1k.csv",
    PLOT_DATA * "plots_sim/gw_fs_plastic_transdec_E=2_1_m=6_nev=400_rho=1008_a=0_lf=0_05_sw=1k.csv",
    )
@show stats(cssf_result)
@show stats(cssf2_result)
@show stats(csac_result)
@show stats(frfsm_result)

cssf_result, cssf2_result, csac_result, frfsm_result = collect_summaries(
    PLOT_DATA * "plots_sim/gw_fs_plastic_transdec_E=2_1_m=6_nev=400_rho=1008_a=0_lf=0_05_sw=1k.csv",
    PLOT_DATA * "plots_sim/gw_fs_plastic_transdec_E=2_1_m=3_nev=400_rho=1008_a=0_lf=0_05_sw=1k.csv",
    )
@show stats(cssf_result)
@show stats(cssf2_result)
@show stats(csac_result)
@show stats(frfsm_result)

nothing
