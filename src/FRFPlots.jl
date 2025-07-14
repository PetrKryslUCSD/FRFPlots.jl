module FRFPlots

using PGFPlotsX
using DelimitedFiles
using DataDrop
using DataDrop: retrieve_json, with_extension
using JSON
using LinearAlgebra
using Statistics
using FRFComparisons

export frfplots, measurements, frequencies, savepdf, matrixplot, stats, collect_summaries, gof

const YELLOW = "rgb,255:red,255;green,225;blue,25"
const BLUE = "rgb,255:red,67;green,99;blue,216"
const ORANGE = "rgb,255:red,245;green,130;blue,49"
const LAVENDER = "rgb,255:red,220;green,190;blue,255"
const MAROON = "rgb,255:red,128;green,0;blue,0"
const RED = "rgb,255:red,255;green,0;blue,0"
const NAVY = "rgb,255:red,0;green,0;blue,117"
const GREY = "rgb,255:red,169;green,169;blue,169"
const WHITE = "rgb,255:red,255;green,255;blue,255"
const BLACK = "rgb,255:red,0;green,0;blue,0"

# Frequency [Hz],TPC L axial,Skull axial,TPC R axial,TPC L transverse,Skull transverse,TPC R transverse,Skull normal
const Frequency_Hz = ("Frequency [Hz]", "Frequency_Hz_")
const TPC_L_axial = ("L/AP", "TPC L axial", "TPCLAxial")
const Skull_axial = ("S/AP", "Skull axial", "SkullAxial")
const TPC_R_axial = ("R/AP", "TPC R axial", "TPCRAxial")
const TPC_L_transverse = ("L/ML", "TPC L transverse", "TPCLTransverse")
const Skull_transverse = ("S/ML", "Skull transverse", "SkullTransverse")
const TPC_R_transverse = ("R/ML", "TPC R transverse", "TPCRTransverse")
const Skull_normal = ("S/DV", "Skull normal", "SkullNormal")

colors = Dict(
    Skull_axial[1] => BLACK,
    Skull_transverse[1] => GREY,
    Skull_normal[1] => ORANGE,
    TPC_L_axial[1] => MAROON,
    TPC_R_axial[1] => LAVENDER,
    TPC_L_transverse[1] => NAVY,
    TPC_R_transverse[1] => RED,
    )

markers = Dict(
    Skull_axial[1] => "triangle",
    Skull_transverse[1] => "triangle*",
    Skull_normal[1] => "x",
    TPC_L_axial[1] => "square",
    TPC_R_axial[1] => "square*",
    TPC_L_transverse[1] => "diamond",
    TPC_R_transverse[1] => "diamond*",
    )

function _coldata(inputcsv, setnames)
    function loadcsv(inputcsv)
        contents = readdlm(inputcsv, ',', Float64, '\n'; header = true)
        return contents
    end
    contents = loadcsv(inputcsv)
    header = contents[2]
    theset = 0
    thekey = ""
    for k in setnames
        for i in eachindex(header)
            if k == header[i]
                theset = i
                thekey = k
                break
            end
        end
    end
    @assert theset > 0 && theset <= length(header) "Set name: $setname. Not found."
    return contents[1][:, theset], thekey
end

function frequencies(inputcsv)
    return _coldata(inputcsv, Frequency_Hz)
end

function measurements(inputcsv, label)
    return _coldata(inputcsv, label)
end

function frfplots(inputcsv, curves; kind = :accelerance, ylabel = "Amplitude [m/(s**2 Pa)]")
    @assert kind in [:accelerance, :mobility]
    plots = []

    @info "$(inputcsv)"

    freq, _ = frequencies(inputcsv)
    for c in curves
        d, k = measurements(inputcsv, c)
        if kind == :mobility
            @. d /= (2 * pi * freq)
        end
        leg = replace(c[1], "_" => " ")
        if length(r) > 3
            leg = r[4]
        end
        # , only_marks
        @pgf push!(plots, Plot({color = colors[c], mark=markers[c], mark_size=1.5, mark_repeat=20, }, Coordinates(freq, d)))
        @pgf push!(plots, LegendEntry(leg))
    end

    @pgf ax = SemiLogYAxis({
        title = "$(replace(inputcsv, "_" => "\\_"))",
        view = (0, 90),
        height = "7.0cm",
        width = "8.91cm",
        xlabel = "Frequency [Hz]",
        ylabel = ylabel,
        grid="major",
        "point meta min" = "1.0e-8",
    # "point meta max" = "0.0",
        enlargelimits = false,
        legend_pos = "outer north west"
        },
        plots...
        )

    return ax
end

function frfplots(requests; kind = :accelerance, ylabel = "Amplitude [m/(s**2 Pa)]")
    @assert kind in [:accelerance, :mobility]
    plots = []
    for (j, r) in enumerate(requests)
        inputcsv = r[1]
        freq, _ = frequencies(inputcsv)
        c = r[2]
        label = r[3]
        d, k = measurements(inputcsv, c)
        if kind == :mobility
            @. d /= (2 * pi * freq)
        end
        leg = replace(c[1], "_" => " ")
        if length(r) > 3
            leg = r[4]
        end
        # @show extrema(freq)
        # @show extrema(d)
        if label == "E"
            @pgf push!(plots, Plot({color = colors[c[1]], mark=markers[c[1]], mark_size=1.5, mark_repeat=20, line_width=1 }, Coordinates(freq, d)))
            @pgf push!(plots, LegendEntry("E: " * leg))
        else
            @pgf push!(plots, Plot({color = colors[c[1]], line_width=2 }, Coordinates(freq, d)))
            @pgf push!(plots, LegendEntry("M: " * leg))
        end
    end

    @pgf ax = SemiLogYAxis({
        view = (0, 90),
        height = "7.0cm",
        width = "8.91cm",
        xlabel = "Frequency [Hz]",
        ylabel = ylabel,
        grid="major",
        # "point meta min" = "1.0e-5",
        # "point meta max" = "1.0e-1",
        ymin = 1.0e-6,
        ymax = 1.0e-1,
        enlargelimits = false,
        legend_pos = "south east"
        },
        plots...
        )
    return ax
end

function frfamplificationplots(requests, reference)
    r = reference
    inputcsv = r[1]
    reffreq, _ = frequencies(inputcsv)
    c = r[2]
    label = r[3]
    refd, _ = measurements(inputcsv, c)
    plots = []
    for (j, r) in enumerate(requests)
        inputcsv = r[1]
        freq, _ = frequencies(inputcsv)
        c = r[2]
        label = r[3]
        leg = replace(c[1], "_" => " ")
        if length(r) > 3
            leg = r[4]
        end
        d, _ = measurements(inputcsv, c)
        if label == "E"
            @pgf push!(plots, Plot({color = colors[c[1]], mark=markers[c[1]], mark_size=1.5, mark_repeat=20, line_width=1 }, 
                        Coordinates(reffreq, d ./ refd)))
            @pgf push!(plots, LegendEntry("E: " * leg))
        else
            @pgf push!(plots, Plot({color = colors[c[1]], line_width=2 }, Coordinates(freq, d ./ refd)))
            @pgf push!(plots, LegendEntry("M: " * leg))
        end
    end

    @pgf ax = SemiLogYAxis({
        view = (0, 90),
        height = "7.0cm",
        width = "8.91cm",
        xlabel = "Frequency [Hz]",
        ylabel = "Amplification [ND]",
        grid="major",
        "ymin" = "0.1",
        # "point meta max" = "0.0",
        enlargelimits = false,
        legend_pos = "south east"
        },
        plots...
        )
    return ax
end

function savepdf(filename, ax)
    pgfsave(with_extension(filename, ".pdf"), ax)
end

function matrixplot(rows, cols, M)
    plots = []
    @pgf push!(plots, Plot3({matrix_plot, nodes_near_coords=raw"\pgfmathprintnumber[precision=3]\pgfplotspointmeta"}, Table(1:size(M', 1), 1:size(M', 2), M')))
    @pgf ax = Axis({
        view = (0, 90),
        height = "6cm",
        width = "6cm",
        xlabel = cols,
        ylabel = rows,
        # xticklabels = "{,,low,,nom,,hig}",
        # yticklabels = "{,,low,,nom,,hig}",
        xticklabels = "{,,low,nom,hig}",
        yticklabels = "{,,low,nom,hig}",
        # grid="major",
        shader="flat corner",
        colorbar,
        "colormap/viridis", # viridis
            # "point meta min" = "-60.0",
            # "point meta max" = "0.0",
        enlargelimits = false
    },
    plots...
    )
    return ax
end

function stats(q)
    q_m = median(q)
    q_m_ad = 1.4826 * median(abs.(q .- q_m))
    q_m, q_m_ad
end

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
    cssf2_result = []
    csac_result = []
    frfsm_result = []
    for c in all_sensors
        f, _ = frequencies(n1)
        d1, k1 = measurements(n1, c)
        f, _ = frequencies(n2)
        d2, k2 = measurements(n2, c)
            # push!(cssf_result, cssf(f, log10.(d2), log10.(d1)))
            # push!(csac_result, csac(f, log10.(d2), log10.(d1)))
            # push!(frfsm_result, frfsm(f, log10.(d2), log10.(d1)))
        push!(cssf_result, cssf(f, d1, d2))
        push!(cssf2_result, cssf2(f, d1, d2))
        push!(csac_result, csac(f, d2, d1))
        push!(frfsm_result, frfsm(f, d2, d1))
    end

    cssf_result, cssf2_result, csac_result, frfsm_result
end

function gof(n1, n2)
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

    _result = []
    for c in all_sensors
        f, _ = frequencies(n1)
        d1, k1 = measurements(n1, c)
        f = frequencies(n2)
        d2, k2 = measurements(n2, c)
        push!(_result, _gof(d1, d2))
    end

    _result
end

function _gof(O, E)
    sum(@. (O - E)^2 / E)
end


function format_number(v)
    if typeof(v) <: Number && round(v) == v
        v = Int(v)
    end
    s = "$(v)"
    return replace(s, "." => "_")
end


end # module FRFPlots
