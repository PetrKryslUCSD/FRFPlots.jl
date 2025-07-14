using PGFPlotsX
using FRFPlots
using FRFPlots: format_number
using FRFComparisons
using Statistics
using DataDrop

experiment = "../plots_TRANSDEC_13Sept2023/AccelOverPressureMs2Pa_TRANSDEC_13Sep2023_0deg_LF_run5_Smooth20lowess.csv"

function single(Esk, Etp, rho_bone, rho_tpc, loss_factor_skull, loss_factor_tpc)
    s = "gw_fs_real_transdec_Esk=$(format_number(Esk))_Etp=$(format_number(Etp))_m=3_nev=400_rhos=$(format_number(rho_bone))_rhot=$(format_number(rho_tpc))_a=0_lfs=$(format_number(loss_factor_skull))_lft=$(format_number(loss_factor_tpc))_sw=1kd.csv"
    cssf_result, cssf2_result, csac_result, frfsm_result = collect_summaries(experiment, "../plots_sim/" * s)
    return stats(frfsm_result)[1]
end

Esks = [7.2, 8.8]
Etps = [31.5, 38.5]
rho_bones = [990, 1210]
rho_tpcs = [2250, 2750]
loss_factor_skulls = [0.2, 0.45]
loss_factor_tpcs = [0.01, 0.1]

v = []
combination = []
for Esk in Esks # [7.2, 8.8] #[8] #10
    for Etp in Etps # [31.5,  38.5] # [35] #
        for rho_bone in rho_bones # [990, 1210]
            for rho_tpc in rho_tpcs # [2250,  2750]
                for loss_factor_tpc in loss_factor_tpcs # [0.01,  0.1]
                    for loss_factor_skull in loss_factor_skulls # [0.2,  0.45]
                        r = single(Esk, Etp, rho_bone, rho_tpc, loss_factor_skull, loss_factor_tpc)
                        push!(v, r)
                        push!(combination, (Esk, Etp, rho_bone, rho_tpc, loss_factor_skull, loss_factor_tpc))
                    end
                end
            end
        end
    end
end

plots = []   

s = "gw_fs_real_transdec_Esk=8_Etp=35_m=3_nev=400_rhos=1100_rhot=2500_a=0_lfs=0_3_lft=0_05_sw=1kd.csv"
    cssf_result, cssf2_result, csac_result, frfsm_result = collect_summaries(experiment, "../plots_sim/" * s)
nominal = stats(frfsm_result)[1]
@pgf push!(plots, Plot({color = "black", line_width = 2},
    Coordinates([1, length(v)], [nominal, nominal])))

@pgf push!(plots, Plot({color = "red", mark = "o", mark_size = 2.5, line_width = 1, "only marks",},
    Coordinates(1:length(v), v)))
@pgf ax = Axis({
        view = (0, 90),
        height = "7.0cm",
        width = "8.91cm",
        xlabel = "Run [ND]",
        ylabel = "FRFSM [ND]",
        grid="major",
        # "ymin" = "0.1",
        # "point meta max" = "0.0",
        enlargelimits = false,
        legend_pos = "south east"
        },
        plots...
        )

display(ax)
savepdf("Parameter-study-real-13Sep2023-scatter", ax)

nothing
