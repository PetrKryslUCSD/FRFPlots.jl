using FRFPlots; 
using FRFComparisons
using Statistics
using DataDrop: with_extension

const PLOT_DATA = "../"

# Plastic skull in water
experiment = "../plots_TRANSDEC_13Sept2023/AccelOverPressureMs2Pa_TRANSDEC_13Sep2023_0deg_LF_run5_Smooth20lowess.csv"

ax = FRFPlots.frfamplificationplots([
    (experiment, FRFPlots.TPC_L_transverse, "E", "L/ML"),
    (experiment, FRFPlots.TPC_R_transverse, "E", "R/ML"),
    ],
    (experiment, FRFPlots.Skull_transverse, "E"),
    )
display(ax)
savepdf(with_extension(with_extension(basename(experiment), "") * "-ML-amplification", ".pdf"), ax)

f, _ = frequencies(experiment)
eL_ML, _ = measurements(experiment, FRFPlots.TPC_L_transverse)
eR_ML, _ = measurements(experiment, FRFPlots.TPC_R_transverse)
eS_ML, _ = measurements(experiment, FRFPlots.Skull_transverse)

model = PLOT_DATA * "plots_sim/gw_fs_real_transdec_Esk=8_Etp=35_m=3_nev=400_a=0_lfs=0_3_lft=0_05_sw=1k.csv"

ax = FRFPlots.frfamplificationplots([
    (model, FRFPlots.TPC_L_transverse, "M", "L/ML"),
    (model, FRFPlots.TPC_R_transverse, "M", "R/ML"),
    ],
    (model, FRFPlots.Skull_transverse, "M"),
    )
display(ax)
savepdf(with_extension(with_extension(basename(model), "") * "-ML-amplification", ".pdf"), ax)

f, _ = frequencies(model)
mL_ML, _ = measurements(model, FRFPlots.TPC_L_transverse)
mR_ML, _ = measurements(model, FRFPlots.TPC_R_transverse)
mS_ML, _ = measurements(model, FRFPlots.Skull_transverse)

@show frfsm(f, eL_ML, mL_ML)
@show frfsm(f, eR_ML, mR_ML)
@show frfsm(f, eL_ML + eR_ML, mL_ML + mR_ML)

nothing
