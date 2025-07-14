using FRFPlots
using FRFPlots: format_number
using FRFComparisons
using Statistics
using DataDrop

experiment = "../plots_TRANSDEC_13Sept2023/AccelOverPressureMs2Pa_TRANSDEC_13Sep2023_0deg_LF_run5_Smooth20lowess.csv"

function factor_average(Esks, Etps, rho_bones, rho_tpcs, loss_factor_skulls, loss_factor_tpcs)
    n = 0
    result = 0.0
    for Esk in Esks # [7.2, 8.8] #[8] #10
        for Etp in Etps # [31.5,  38.5] # [35] #
            for rho_bone in rho_bones # [990, 1210]
                for rho_tpc in rho_tpcs # [2250,  2750]
                    for loss_factor_tpc in loss_factor_tpcs # [0.01,  0.1]
                        for loss_factor_skull in loss_factor_skulls # [0.2,  0.45]
                            s = "gw_fs_real_transdec_Esk=$(format_number(Esk))_Etp=$(format_number(Etp))_m=3_nev=400_rhos=$(format_number(rho_bone))_rhot=$(format_number(rho_tpc))_a=0_lfs=$(format_number(loss_factor_skull))_lft=$(format_number(loss_factor_tpc))_sw=1kd.csv"
                            cssf_result, cssf2_result, csac_result, frfsm_result = collect_summaries(experiment, "../plots_sim/" * s)
                            result += stats(frfsm_result)[1]
                            n += 1
                        end
                    end
                end
            end
        end
    end
    return result / n
end

Esks = [7.2, 8.8]
Etps = [31.5,  38.5]
rho_bones = [990, 1210]
rho_tpcs = [2250, 2750]
loss_factor_skulls = [0.2, 0.45]
loss_factor_tpcs = [0.01, 0.1]

MF_Esk = (factor_average(Esks[end], Etps, rho_bones, rho_tpcs, loss_factor_skulls, loss_factor_tpcs) -
          factor_average(Esks[1], Etps, rho_bones, rho_tpcs, loss_factor_skulls, loss_factor_tpcs)
)
@show MF_Esk
MF_Etp = (factor_average(Esks, Etps[end], rho_bones, rho_tpcs, loss_factor_skulls, loss_factor_tpcs) -
          factor_average(Esks, Etps[1], rho_bones, rho_tpcs, loss_factor_skulls, loss_factor_tpcs)
)
@show MF_Etp
MF_rhos = (factor_average(Esks, Etps, rho_bones[end], rho_tpcs, loss_factor_skulls, loss_factor_tpcs) -
          factor_average(Esks, Etps, rho_bones[1], rho_tpcs, loss_factor_skulls, loss_factor_tpcs)
)
@show MF_rhos
MF_rhot = (factor_average(Esks, Etps, rho_bones, rho_tpcs[end], loss_factor_skulls, loss_factor_tpcs) -
          factor_average(Esks, Etps, rho_bones, rho_tpcs[1], loss_factor_skulls, loss_factor_tpcs)
)
@show MF_rhot
MF_lfs = (factor_average(Esks, Etps, rho_bones, rho_tpcs, loss_factor_skulls[end], loss_factor_tpcs) -
          factor_average(Esks, Etps, rho_bones, rho_tpcs, loss_factor_skulls[1], loss_factor_tpcs)
)
@show MF_lfs
MF_lft = (factor_average(Esks, Etps, rho_bones, rho_tpcs, loss_factor_skulls, loss_factor_tpcs[end]) -
          factor_average(Esks, Etps, rho_bones, rho_tpcs, loss_factor_skulls, loss_factor_tpcs[1])
)
@show MF_lft

nothing
