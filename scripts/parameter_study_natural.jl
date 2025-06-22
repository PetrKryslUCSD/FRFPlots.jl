using FRFPlots; 
using FRFComparisons
using Statistics
using DataDrop

experiment = "../plots_TRANSDEC_13Sept2023/AccelOverPressureMs2Pa_TRANSDEC_13Sep2023_0deg_LF_run5_Smooth20lowess.csv"


function compute_matrix_Esk_vs_lfs(experiment)
    Esks = ["7_2", "8", "8_8"]
    Etp =  "35"
    lft = "0_01"
    lfss = ["0_2", "0_3", "0_45"]
    M = zeros(length(Esks), length(lfss))
    for (i, Esk) in enumerate(Esks)
        for (j, lfs) in enumerate(lfss)
            # gw_fs_real_transdec_Esk=8_8_Etp=35_m=3_nev=400_a=0_lfs=0_2_lft=0_01_sw=1k
            current = "gw_fs_real_transdec_Esk=$(Esk)_Etp=$(Etp)_m=3_nev=400_a=0_lfs=$(lfs)_lft=$(lft)_sw=1k.csv"
            cssf_result, cssf2_result, csac_result, frfsm_result = collect_summaries(experiment, "../plots_sim/" * current)
            @show frfsm_result
            M[i, j] = stats(frfsm_result)[1]
            @show i, j, Esk, lfs, M[i, j]
        end
    end
    Esks, lfss, M
end

Esks, lfss, M =  compute_matrix_Esk_vs_lfs(experiment)

ax = matrixplot("E{sk}", "lfs", M)
display(ax)
savepdf("Parameter-study-real-Esk-lfs-13Sep2023", ax)


function compute_matrix_Esk_vs_Etp(experiment)
    Esks = ["7_2", "8", "8_8"]
    Etps =  ["31_5", "35", "38_5"]
    lft = "0_01"
    lfs = "0_3"
    M = zeros(length(Esks), length(Etps))
    for (i, Esk) in enumerate(Esks)
        for (j, Etp) in enumerate(Etps)
            # gw_fs_real_transdec_Esk=8_8_Etp=35_m=3_nev=400_a=0_lfs=0_2_lft=0_01_sw=1k
            current = "gw_fs_real_transdec_Esk=$(Esk)_Etp=$(Etp)_m=3_nev=400_a=0_lfs=$(lfs)_lft=$(lft)_sw=1k.csv"
            cssf_result, cssf2_result, csac_result, frfsm_result = collect_summaries(experiment, "../plots_sim/" * current)
            @show frfsm_result
            M[i, j] = stats(frfsm_result)[1]
            @show i, j, Esk, Etp, M[i, j]
        end
    end
    Esks, Etps, M
end

Esks, Etps, M =  compute_matrix_Esk_vs_Etp(experiment)

ax = matrixplot("E{sk}", "Etp", M)
display(ax)
savepdf("Parameter-study-real-Esk-Etp-13Sep2023", ax)

# data1 = experiment
# # data2 = "../plots_sim/gw_fs_plastic_transdec_E=$("1_56")_m=6_nev=400_rho=$("1109")_a=0_lf=0_05_sw=1k.csv"
# # data2 = "../plots_sim/" * "gw_fs_real_transdec_Esk=$("8_8")_Etp=$("35")_m=3_nev=400_a=0_lft=$("0_1")_sw=1k.csv"
# # data2 = "../plots_sim/" * "gw_fs_real_transdec_Esk=$("8_8")_Etp=$("35")_m=3_nev=400_a=0_lft=$("0_01")_sw=1k.csv"

# Esk = "8_8"
# Etp =  "35"
# lft = "0_01"
# lfs = "0_2"
# data2 = "../plots_sim/" * "gw_fs_real_transdec_Esk=$(Esk)_Etp=$(Etp)_m=3_nev=400_a=0_lfs=$(lfs)_lft=$(lft)_sw=1k.csv"


# ax = FRFPlots.frfplots([
#     (data1, FRFPlots.TPC_L_transverse, "E"),
#     (data2, FRFPlots.TPC_L_transverse, "M"),
#     ])
# display(ax)

# ax = FRFPlots.frfplots([
#     (data1, FRFPlots.TPC_R_transverse, "E"),
#     (data2, FRFPlots.TPC_R_transverse, "M"),
#     ])
# display(ax)
# # savepdf("junk" * ".pdf", ax)

# ax = FRFPlots.frfplots([
#     (data1, FRFPlots.Skull_transverse, "E"),
#     (data2, FRFPlots.Skull_transverse, "M"),
#     ])
# display(ax)
# savepdf("junk" * ".pdf", ax)

# shader = "interp",
# "colormap/jet",colormap_name="viridis",
# open("fig.tex", "w") do file
# print_tex(file, ax)
# end
# display(ax)

nothing
