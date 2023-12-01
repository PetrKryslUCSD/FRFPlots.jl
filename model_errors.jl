using FRFPlots; 
using FRFComparisons
using Statistics


experiment = "../plots_TRANSDEC_28Aug2023/AccelOverPressureMs2Pa_RecordNI_amps_TRANSDEC_28Aug2023_0deg_run2.csv"
experiment = "../plots_TRANSDEC_19Oct2023/AccelOverPressureMs2Pa_RecordNI_amps_TRANSDEC_19Oct2023_0deg_LF_plastic_run1.csv"
# experiment = "../plots_TRANSDEC_19Oct2023/AccelOverPressureMs2Pa_RecordNI_amps_TRANSDEC_19Oct2023_0deg_LF_plastic_bubble_run1.csv"
model = "../plots_sim/gw_fs_plastic_transdec_E=1_74_m=3_nev=400_rho=1008_a=0_lf=0_05_sw=1k.csv"
# model = "../plots_sim/gw_fs_plastic_transdec_E=1.74_m=3_nev=400_rho=1008_a=0_lf=0.05_sw=1kapproxp.csv"
cssf_result, csac_result, frfsm_result = collect_summaries(experiment, model)
@show stats(cssf_result)
@show stats(csac_result)
@show stats(frfsm_result)

ax = FRFPlots.frfplots([
    (experiment, FRFPlots.TPC_L_transverse, "E"),
    (model, FRFPlots.TPC_L_transverse, "M"),
    (experiment, FRFPlots.TPC_R_transverse, "E"),
    (model, FRFPlots.TPC_R_transverse, "M"),
    (experiment, FRFPlots.Skull_transverse, "E"),
    (model, FRFPlots.Skull_transverse, "M"),
    ])
display(ax)
# savepdf("replica-19Oct2023-bubble" * ".pdf", ax)


nothing
