using FRFPlots; 
using FRFComparisons
using Statistics
using DataDrop: with_extension

const PLOT_DATA = "../"

# Plastic skull in water
expdir = "plots_TRANSDEC_28Aug2023"
experiment = PLOT_DATA * "$(expdir)/AccelOverPressureMs2Pa_TRANSDEC_28Aug2023_0deg_run2_Smooth20lowess.csv"

ax = FRFPlots.frfamplificationplots([
    (experiment, FRFPlots.TPC_L_transverse, "E", "L/ML"),
    (experiment, FRFPlots.TPC_R_transverse, "E", "R/ML"),
    ],
    (experiment, FRFPlots.Skull_transverse, "E"),
    )
display(ax)
savepdf(with_extension(with_extension(basename(experiment), "") * "-ML-amplification", ".pdf"), ax)


expdir = "plots_TRANSDEC_19Oct2023"
experiment = PLOT_DATA * "$(expdir)/AccelOverPressureMs2Pa_TRANSDEC_19Oct2023_0deg_LF_bone_run1_Smooth20lowess.csv"

ax = FRFPlots.frfamplificationplots([
    (experiment, FRFPlots.TPC_L_transverse, "E", "L/ML"),
    (experiment, FRFPlots.TPC_R_transverse, "E", "R/ML"),
    ],
    (experiment, FRFPlots.Skull_transverse, "E"),
    )
display(ax)
savepdf(with_extension(with_extension(basename(experiment), "") * "-ML-amplification", ".pdf"), ax)

model = PLOT_DATA * "plots_sim/gw_fs_plastic_transdec_E=2_1_m=3_nev=400_rho=1008_a=0_lf=0_05_sw=1k.csv"

ax = FRFPlots.frfamplificationplots([
    (model, FRFPlots.TPC_L_transverse, "M", "L/ML"),
    (model, FRFPlots.TPC_R_transverse, "M", "R/ML"),
    ],
    (model, FRFPlots.Skull_transverse, "M"),
    )
display(ax)
savepdf(with_extension(with_extension(basename(model), "") * "-ML-amplification", ".pdf"), ax)

nothing
