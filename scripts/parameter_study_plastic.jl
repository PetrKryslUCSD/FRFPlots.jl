using FRFPlots; 
using FRFComparisons
using Statistics
using DataDrop

function compute_matrix(experiment)
    Es = ["1_56", "1_74", "1_91"]
    rhos =  ["907", "1008", "1109" ]
    M = zeros(length(Es), length(rhos))
    for (i, E) in enumerate(Es)
        for (j, rho) in enumerate(rhos)
            current = "gw_fs_plastic_transdec_E=$(E)_m=6_nev=400_rho=$(rho)_a=0_lf=0_05_sw=1k.csv"
            cssf_result, cssf2_result, csac_result, frfsm_result = collect_summaries(experiment, "../plots_sim/" * current)
            M[i, j] = stats(frfsm_result)[1]
            @show i, j, E, rho, M[i, j]
        end
    end
    Es, rhos, M
end

experiment = "../plots_TRANSDEC_19Oct2023/AccelOverPressureMs2Pa_RecordNI_amps_TRANSDEC_19Oct2023_0deg_LF_plastic_run1.csv"
# experiment = "../plots_TRANSDEC_28Aug2023/AccelOverPressureMs2Pa_RecordNI_amps_TRANSDEC_28Aug2023_0deg_run2.csv"
Es, rhos, M =  compute_matrix(experiment)

ax = matrixplot("E", "\\rho", M)
display(ax)
savepdf("Parameter-study-Plastic-19Oct2023", ax)

# data1 = experiment
# data2 = "../plots_sim/gw_fs_plastic_transdec_E=$("1_56")_m=6_nev=400_rho=$("1109")_a=0_lf=0_05_sw=1k.csv"
# data2 = "../plots_sim/gw_fs_plastic_transdec_E=$("1_91")_m=6_nev=400_rho=$("1109")_a=0_lf=0_05_sw=1k.csv"

# ax = FRFPlots.frfplots([
#     (data1, FRFPlots.TPC_L_transverse, "E"),
#     (data2, FRFPlots.TPC_L_transverse, "M"),
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
