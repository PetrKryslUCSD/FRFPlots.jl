using FRFPlots; 
using FRFComparisons
using Statistics
using DataDrop: with_extension, clean_file_name

experiment = "../plots_TRANSDEC_28Aug2023/AccelOverPressureMs2Pa_RecordNI_amps_TRANSDEC_28Aug2023_0deg_run2.csv"
experiment = "../plots_TRANSDEC_13Sept2023/AccelOverPressureMs2Pa_RecordNI_amps_TRANSDEC_13Sep2023_0deg_LF_run5.csv"
# experiment = "../plots_TRANSDEC_14Sept2023/AccelOverPressureMs2Pa_RecordNI_amps_TRANSDEC_14Sep2023_0deg_LF_bubble_run1.csv"
# experiment = "../plots_TRANSDEC_19Oct2023/AccelOverPressureMs2Pa_RecordNI_amps_TRANSDEC_19Oct2023_0deg_LF_plastic_run1.csv"
# experiment = "../plots_TRANSDEC_19Oct2023/AccelOverPressureMs2Pa_RecordNI_amps_TRANSDEC_19Oct2023_0deg_LF_plastic_bubble_run1.csv"

# ax = FRFPlots.frfplots([
#     (experiment, FRFPlots.TPC_L_transverse, "E"),
#     (experiment, FRFPlots.TPC_R_transverse, "E"),
#     (experiment, FRFPlots.Skull_transverse, "E"),
#     ])
# display(ax)
# savepdf(with_extension(with_extension(basename(experiment), "") * "-transverse", ".pdf"), ax)

# ax = FRFPlots.frfplots([
#     (experiment, FRFPlots.TPC_L_axial, "E"),
#     (experiment, FRFPlots.TPC_R_axial, "E"),
#     (experiment, FRFPlots.Skull_axial, "E"),
#     ])
# display(ax)
# savepdf(with_extension(with_extension(basename(experiment), "") * "-axial", ".pdf"), ax)


ax = FRFPlots.frfamplificationplots([
    (experiment, FRFPlots.TPC_L_transverse, "E"),
    (experiment, FRFPlots.TPC_R_transverse, "E"),
    ],
    (experiment, FRFPlots.Skull_transverse, "E"),
    )
display(ax)
savepdf(with_extension(with_extension(basename(experiment), "") * "-transverse-amplification", ".pdf"), ax)


ax = FRFPlots.frfamplificationplots([
    (experiment, FRFPlots.TPC_L_axial, "E"),
    (experiment, FRFPlots.TPC_R_axial, "E"),
    ],
    (experiment, FRFPlots.Skull_axial, "E"),
    )
display(ax)
savepdf(with_extension(with_extension(basename(experiment), "") * "-axial-amplification", ".pdf"), ax)


nothing
