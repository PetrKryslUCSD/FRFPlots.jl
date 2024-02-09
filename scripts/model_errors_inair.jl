using FRFPlots; 
using FRFComparisons
using Statistics

const PLOT_DATA = "../../"

experiment = PLOT_DATA * "plots_TRANSDEC_28Aug2023/AccelOverPressureMs2Pa_RecordNI_amps_TRANSDEC_28Aug2023_0deg_run2.csv"
# experiment = "../plots_TRANSDEC_19Oct2023/AccelOverPressureMs2Pa_RecordNI_amps_TRANSDEC_19Oct2023_0deg_LF_plastic_run1.csv"
# experiment = "../plots_TRANSDEC_19Oct2023/AccelOverPressureMs2Pa_RecordNI_amps_TRANSDEC_19Oct2023_0deg_LF_plastic_bubble_run1.csv"

model = PLOT_DATA * "plots_sim/gw_fs_plastic_transdec_E=2_1_m=3_nev=400_rho=1008_a=0_lf=0_05_sw=1k.csv"

experiment = PLOT_DATA * "plots_TRANSDEC_13Sept2023/AccelOverPressureMs2Pa_RecordNI_amps_TRANSDEC_13Sep2023_0deg_LF_run5.csv"
model = PLOT_DATA * "plots_sim/gw_fs_real_transdec_Esk=7_2_Etp=31_5_m=3_nev=400_a=0_lft=0_1_sw=1k.csv"
model = PLOT_DATA * "plots_sim/gw_fs_real_transdec_Esk=7_2_Etp=35_m=3_nev=400_a=0_lft=0_1_sw=1k.csv"
model = PLOT_DATA * "plots_sim/gw_fs_real_transdec_Esk=8_Etp=35_m=3_nev=400_a=0_lft=0_1_sw=1k.csv"
model = PLOT_DATA * "plots_sim/gw_fs_real_transdec_Esk=8_8_Etp=35_m=3_nev=400_a=0_lft=0_05_sw=1k.csv"
model = PLOT_DATA * "plots_sim/gw_fs_real_transdec_Esk=8_Etp=31_5_m=3_nev=400_a=0_lft=0_05_sw=1k.csv"

experiment = PLOT_DATA * "plots_ALab_LACM/AccelMs2_AccelData_waveform_PlasticSkull_UDshaker_SkullBase_18Dec2023_run1.csv"
model = PLOT_DATA * "plots_sim/gw_fs_plastic_inair_E=2_1_m=3_nev=400_rho=1008_a=0_ft=forc_lf=0_05_sw=3k.csv"
# model = PLOT_DATA * "plots_sim/gw_fs_real_transdec_Esk=8_8_Etp=35_m=3_nev=400_a=0_lft=0_05_sw=1k.csv"
# model = PLOT_DATA * "plots_sim/gw_fs_real_transdec_Esk=8_Etp=31_5_m=3_nev=400_a=0_lft=0_1_sw=1k.csv"

# model = PLOT_DATA * "plots_sim/gw_fs_real_transdec_Esk=8_Etp=25_m=3_nev=41900_a=0_lft=0_01_sw=1k.csv"

# cssf_result, csac_result, frfsm_result = collect_summaries(experiment, model)
# @show stats(cssf_result)
# @show stats(csac_result)
# @show stats(frfsm_result)

ax = FRFPlots.frfplots([
    (experiment, FRFPlots.TPC_L_transverse, "E"),
    (model, FRFPlots.TPC_L_transverse, "M"),
    (experiment, FRFPlots.TPC_R_transverse, "E"),
    (model, FRFPlots.TPC_R_transverse, "M"),
    (experiment, FRFPlots.Skull_transverse, "E"),
    (model, FRFPlots.Skull_transverse, "M"),
    ]; kind = :mobility, ylabel = "Amplitude [m/s]")
display(ax)
# savepdf("replica-19Oct2023-bubble" * ".pdf", ax)

# @show gof(model, experiment)

nothing
