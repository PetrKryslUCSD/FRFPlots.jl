using FRFPlots; 
using FRFComparisons
using Statistics


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

experiment = "../plots_TRANSDEC_28Aug2023/AccelOverPressureMs2Pa_RecordNI_amps_TRANSDEC_28Aug2023_0deg_run2.csv"
experiment = "../plots_TRANSDEC_19Oct2023/AccelOverPressureMs2Pa_RecordNI_amps_TRANSDEC_19Oct2023_0deg_LF_plastic_run1.csv"
model = "../plots_sim/gw_fs_plastic_transdec_E=2_1_m=3_nev=400_rho=1080_a=0_lf=0_05_sw=1k.csv"
cssf_result, csac_result, frfsm_result = collect_summaries(experiment, model)
@show stats(cssf_result)
@show stats(csac_result)
@show stats(frfsm_result)


ax = FRFPlots.frfplots([
    (experiment, FRFPlots.TPC_L_transverse, true),
    (model, FRFPlots.TPC_L_transverse, false),
    ])
display(ax)


ax = FRFPlots.frfplots([
    (experiment, FRFPlots.TPC_R_transverse, true),
    (model, FRFPlots.TPC_R_transverse, false),
    ])
display(ax)

ax = FRFPlots.frfplots([
    (experiment, FRFPlots.Skull_transverse, true),
    (model, FRFPlots.Skull_transverse, false),
    ])
display(ax)


nothing
