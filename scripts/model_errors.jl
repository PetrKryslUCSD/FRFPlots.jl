using FRFPlots; 
using FRFComparisons
using Statistics

const PLOT_DATA = "../"

# Plastic skull in water
expdir = "plots_TRANSDEC_28Aug2023"
experiment = PLOT_DATA * "$(expdir)/AccelOverPressureMs2Pa_TRANSDEC_28Aug2023_0deg_run2_Smooth20lowess.csv"
# expdir = "plots_TRANSDEC_19Oct2023"
# experiment = PLOT_DATA * "$(expdir)/AccelOverPressureMs2Pa_TRANSDEC_19Oct2023_0deg_LF_bone_run1_Smooth20lowess.csv"
model = PLOT_DATA * "plots_sim/gw_fs_plastic_transdec_E=2_1_m=3_nev=400_rho=1008_a=0_lf=0_05_sw=1k.csv"
filebase = "replica-$(expdir)"

# Natural skull in water
expdir = "plots_TRANSDEC_13Sept2023"
experiment = PLOT_DATA * "$(expdir)/AccelOverPressureMs2Pa_TRANSDEC_13Sep2023_0deg_LF_run5_Smooth20lowess.csv"
model = PLOT_DATA * "plots_sim/gw_fs_real_transdec_Esk=8_Etp=35_m=3_nev=400_a=0_lfs=0_3_lft=0_01_sw=1k.csv"
filebase = "real-$(expdir)"

# Plastic skull in air
# experiment = PLOT_DATA * "plots_ALab_LACM/AccelMs2_AccelData_waveform_PlasticSkull_UDshaker_SkullBase_18Dec2023_run1.csv"
# model = PLOT_DATA * "plots_sim/gw_fs_plastic_inair_E=2_1_m=3_nev=400_rho=1008_a=0_ft=forc_lf=0_05_sw=3k.csv"

# model = PLOT_DATA * "plots_sim/gw_fs_real_transdec_Esk=8_8_Etp=35_m=3_nev=400_a=0_lft=0_05_sw=1k.csv"
# model = PLOT_DATA * "plots_sim/gw_fs_real_transdec_Esk=8_Etp=31_5_m=3_nev=400_a=0_lft=0_1_sw=1k.csv"

# model = PLOT_DATA * "plots_sim/gw_fs_real_transdec_Esk=8_Etp=25_m=3_nev=41900_a=0_lft=0_01_sw=1k.csv"

@info "$(filebase)"
cssf_result, cssf2_result, csac_result, frfsm_result = collect_summaries(experiment, model)
@show stats(cssf_result)
@show stats(cssf2_result)
@show stats(csac_result)
@show stats(frfsm_result)

for setnames in [
    FRFPlots.TPC_L_transverse,
    FRFPlots.TPC_R_transverse,
    FRFPlots.Skull_transverse,
    FRFPlots.Skull_axial,
]
    ax = FRFPlots.frfplots([
        (experiment, setnames, "E"),
        (model, setnames, "M"),
    ])
    display(ax)

    savepdf("$(filebase)-" * replace(setnames[1], "/" => "_") * ".pdf", ax)
end



nothing
