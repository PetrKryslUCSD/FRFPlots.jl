using FRFPlots; 
using FRFComparisons

all = [
FRFPlots.TPC_L_transverse,
FRFPlots.TPC_L_axial,
FRFPlots.TPC_R_transverse,
FRFPlots.TPC_R_axial,
FRFPlots.Skull_transverse,
FRFPlots.Skull_axial,
]



# ax = FRFPlots.frfplots("../simulations/gw_fs_plastic_transdec_E=2_1_m=10_nev=400_rho=1080_a=0_lf=0_05_sw=1k.csv",
#     all)
# display(ax)

# ax = FRFPlots.frfplots("../plots_TRANSDEC_28Aug2023/AccelOverPressureMs2Pa_RecordNI_amps_TRANSDEC_28Aug2023_0deg_run2.csv",
#     all)
# display(ax)

# f = frequencies("../simulations/gw_fs_plastic_transdec_E=2_1_m=10_nev=400_rho=1188_a=0_lf=0_05_sw=1k.csv")
# f = frequencies("../plots_TRANSDEC_28Aug2023/AccelOverPressureMs2Pa_RecordNI_amps_TRANSDEC_28Aug2023_0deg_run2.csv")

# for c in all
#     n1 = "../simulations/gw_fs_plastic_transdec_E=2_1_m=10_nev=400_rho=1188_a=0_lf=0_05_sw=1k.csv"
#     f = frequencies(n1)
#     d1 = measurements(n1, c)
#     n2 = "../simulations/gw_fs_plastic_transdec_E=2_1_m=13_nev=400_rho=1188_a=0_lf=0_05_sw=1k.csv"
#     f = frequencies(n2)
#     d2 = measurements(n2, c)
#     @show c
#     @show cssf(f, d1, d2)
# # cssf(f, d2, d1)
#     @show csac(f, d2, d1)
# # csac(f, d1, d2)
#     @show frfsm(f, d2, d1)
# end

data1 = "../plots_sim/gw_fs_plastic_transdec_E=1_74_m=3_nev=400_rho=1080_a=0_lf=0_05_sw=1k.csv"
data2 = "../plots_sim/gw_fs_plastic_transdec_E=2_1_m=3_nev=400_rho=1080_a=0_lf=0_05_sw=1k.csv"

data1 = "../plots_sim/pp_E=1_74_m=13_nev=400_rho=1008_a=0_lf=0_05_sw=1k.csv"
data2 = "../plots_sim/pp_E=1_74_m=13_nev=400_rho=1008_a=0_lf=0_05_sw=1kalt.csv"

ax = FRFPlots.frfplots([
    (data1, FRFPlots.TPC_L_transverse, "M1"),
    (data2, FRFPlots.TPC_L_transverse, "E"),
    ])
display(ax)
savepdf("TPC_L_transverse" * ".pdf", ax)


ax = FRFPlots.frfplots([
    (data1, FRFPlots.TPC_R_transverse, "M1"),
    (data2, FRFPlots.TPC_R_transverse, "E"),
    ])
display(ax)
savepdf("TPC_R_transverse" * ".pdf", ax)

ax = FRFPlots.frfplots([
    (data1, FRFPlots.Skull_transverse, "M1"),
    (data2, FRFPlots.Skull_transverse, "E"),
    ])
display(ax)
savepdf("Skull_transverse", ax)

ax = FRFPlots.frfplots([
    (data1, FRFPlots.Skull_axial, "M1"),
    (data2, FRFPlots.Skull_axial, "E"),
    ])
display(ax)
savepdf("Skull_axial", ax)


nothing
