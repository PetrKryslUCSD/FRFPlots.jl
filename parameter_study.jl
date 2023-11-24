using FRFPlots; 
using FRFComparisons
using Statistics
using DataDrop

function collect_summaries(n1, n2)
    all_sensors = [
    FRFPlots.TPC_L_transverse,
    FRFPlots.TPC_L_axial,
    FRFPlots.TPC_R_transverse,
    FRFPlots.TPC_R_axial,
    FRFPlots.Skull_transverse,
    FRFPlots.Skull_axial,
    FRFPlots.Skull_normal,
    ]
    f = frequencies(n1)

    cssf_result = []
    csac_result = []
    frfsm_result = []
    for c in all_sensors
        f = frequencies(n1)
        d1 = measurements(n1, c)
        f = frequencies(n2)
        d2 = measurements(n2, c)
        push!(cssf_result, cssf(f, d1, d2))
        push!(csac_result, csac(f, d2, d1))
        push!(frfsm_result, frfsm(f, d2, d1))
    end

    cssf_result, csac_result, frfsm_result
end

function stats(v)
    mean(v), stdm(v, mean(v))
end

function compute_matrix()
    experiment = "../plots_TRANSDEC_19Oct2023/AccelOverPressureMs2Pa_RecordNI_amps_TRANSDEC_19Oct2023_0deg_LF_plastic_run1.csv"
    experiment = "../plots_TRANSDEC_28Aug2023/AccelOverPressureMs2Pa_RecordNI_amps_TRANSDEC_28Aug2023_0deg_run2.csv"
    Es = ["1_89", "2_1", "2_3"]
    rhos =  ["972", "1080", "1188" ]
    M = zeros(length(Es), length(rhos))
    for (i, E) in enumerate(Es)
        for (j, rho) in enumerate(rhos)
            current = "gw_fs_plastic_transdec_E=$(E)_m=6_nev=400_rho=$(rho)_a=0_lf=0_05_sw=1k.csv"
            cssf_result, csac_result, frfsm_result = collect_summaries(experiment, "../plots_sim/" * current)
            M[i, j] = stats(frfsm_result)[1]
            @show E, rho, M[i, j]
        end
    end
    M
end
@show compute_matrix()

# m1  = "../plots_sim/" * "gw_fs_plastic_transdec_E=2_1_m=6_nev=400_rho=1080_a=0_lf=0_05_sw=1k.csv"
# m2 =  "../plots_sim/" * "gw_fs_plastic_transdec_E=1_89_m=6_nev=400_rho=972_a=0_lf=0_05_sw=1k.csv"
# ax = FRFPlots.frfplots([
#     (m1, FRFPlots.TPC_L_transverse, false),
#     (m2, FRFPlots.TPC_L_transverse, false),
#     ])
# display(ax)
# savepdf("TPC_L_transverse" * ".pdf", ax)


# ax = FRFPlots.frfplots([
#     (experiment, FRFPlots.TPC_R_transverse, true),
#     (model, FRFPlots.TPC_R_transverse, false),
#     ])
# display(ax)
# savepdf("TPC_R_transverse" * ".pdf", ax)

# ax = FRFPlots.frfplots([
#     (experiment, FRFPlots.Skull_transverse, true),
#     (model, FRFPlots.Skull_transverse, false),
#     ])
# display(ax)
# savepdf("Skull_transverse", ax)

# ax = FRFPlots.frfplots([
#     (experiment, FRFPlots.Skull_axial, true),
#     (model, FRFPlots.Skull_axial, false),
#     ])
# display(ax)
# savepdf("Skull_axial", ax)

nothing
