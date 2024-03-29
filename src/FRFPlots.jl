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
const Frequency_Hz = "Frequency [Hz]"
const TPC_L_axial = "TPC L axial"
const Skull_axial = "Skull axial"
const TPC_R_axial = "TPC R axial"
const TPC_L_transverse = "TPC L transverse"
const Skull_transverse = "Skull transverse"
const TPC_R_transverse = "TPC R transverse"
const Skull_normal = "Skull normal"

colors = Dict(
    Skull_axial => BLACK,
    Skull_transverse => GREY,
    Skull_normal => ORANGE,
    TPC_L_axial => MAROON,
    TPC_R_axial => LAVENDER,
    TPC_L_transverse => NAVY,
    TPC_R_transverse => RED,
    )

markers = Dict(
    Skull_axial => "triangle",
    Skull_transverse => "triangle*",
    Skull_normal => "x",
    TPC_L_axial => "square",
    TPC_R_axial => "square*",
    TPC_L_transverse => "diamond",
    TPC_R_transverse => "diamond*",
    )

function _coldata(inputcsv, setname)
    function loadcsv(inputcsv)
        contents = readdlm(inputcsv, ',', Float64, '\n'; header = true)
        return contents
    end
    contents = loadcsv(inputcsv)
    header = contents[2]
    theset = 0
    for i in eachindex(header)
        if setname == header[i]
            theset = i
            break
        end
    end
    @assert theset > 0 && theset <= length(header) "Set name: $setname. Not found."
    return contents[1][:, theset]
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

    freq = frequencies(inputcsv)
    for c in curves
        d = measurements(inputcsv, c)
        if kind == :mobility
            @. d /= (2 * pi * freq)
        end
        # , only_marks
        @pgf push!(plots, Plot({color = colors[c], mark=markers[c], mark_size=1.5, mark_repeat=20, }, Coordinates(freq, d)))
        @pgf push!(plots, LegendEntry(replace(c, "_" => " ")))
    end

    @pgf ax = SemiLogYAxis({
        title = "$(replace(inputcsv, "_" => "\\_"))",
        view = (0, 90),
        height = "7.2cm",
        width = "9.16cm",
        xlabel = "Frequency [Hz]",
        ylabel = ylabel,
        grid="major",
    # "point meta min" = "-60.0",
    # "point meta max" = "0.0",
        enlargelimits = false,
        legend_pos = "outer north east"
        },
        plots...
        )

    return ax
end

function frfplots(requests; kind = :accelerance, ylabel = "Amplitude [m/(s**2 Pa)]", fudge_factor = 0.25)
    @assert kind in [:accelerance, :mobility]
    plots = []
    for (j, r) in enumerate(requests)
        inputcsv = r[1]
        freq = frequencies(inputcsv)
        c = r[2]
        label = r[3]
        d = measurements(inputcsv, c)
        if kind == :mobility
            @. d /= (2 * pi * freq)
        end
        if label == "E"
            @. d *= fudge_factor # TO DO REMOVE!!!
            @pgf push!(plots, Plot({color = colors[c], mark=markers[c], mark_size=1.5, mark_repeat=20, line_width=1 }, Coordinates(freq, d)))
            @pgf push!(plots, LegendEntry("E: " * replace(c, "_" => " ")))
        else
            @pgf push!(plots, Plot({color = colors[c], line_width=2 }, Coordinates(freq, d)))
            @pgf push!(plots, LegendEntry("M: " * replace(c, "_" => " ")))
        end
    end

    @pgf ax = SemiLogYAxis({
        view = (0, 90),
        height = "9.0cm",
        width = "11.454cm",
        xlabel = "Frequency [Hz]",
        ylabel = ylabel,
        grid="major",
        # "point meta min" = "-60.0",
        # "point meta max" = "0.0",
        enlargelimits = false,
        legend_pos = "outer north east"
        },
        plots...
        )
    return ax
end

function frfamplificationplots(requests, reference)
    r = reference
    inputcsv = r[1]
    reffreq = frequencies(inputcsv)
    c = r[2]
    label = r[3]
    refd = measurements(inputcsv, c)
    plots = []
    for (j, r) in enumerate(requests)
        inputcsv = r[1]
        freq = frequencies(inputcsv)
        c = r[2]
        label = r[3]
        d = measurements(inputcsv, c)
        if label == "E"
            @pgf push!(plots, Plot({color = colors[c], mark=markers[c], mark_size=1.5, mark_repeat=20, line_width=1 }, Coordinates(freq, d ./ refd)))
            @pgf push!(plots, LegendEntry("E: " * replace(c, "_" => " ")))
        else
            @pgf push!(plots, Plot({color = colors[c], line_width=2 }, Coordinates(freq, d ./ refd)))
            @pgf push!(plots, LegendEntry("M: " * replace(c, "_" => " ")))
        end
    end

    @pgf ax = SemiLogYAxis({
        view = (0, 90),
        height = "9.0cm",
        width = "11.454cm",
        xlabel = "Frequency [Hz]",
        ylabel = "Amplification [ND]",
        grid="major",
        # "point meta min" = "-60.0",
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
        height = "8cm",
        width = "8cm",
        xlabel = cols,
        ylabel = rows,
        xticklabels = "{,,low,,nom,,hig}",
        yticklabels = "{,,low,,nom,,hig}",
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
    csac_result = []
    frfsm_result = []
    for c in all_sensors
        f = frequencies(n1)
        d1 = measurements(n1, c)
        f = frequencies(n2)
        d2 = measurements(n2, c)
            # push!(cssf_result, cssf(f, log10.(d2), log10.(d1)))
            # push!(csac_result, csac(f, log10.(d2), log10.(d1)))
            # push!(frfsm_result, frfsm(f, log10.(d2), log10.(d1)))
        push!(cssf_result, cssf(f, d1, d2))
        push!(csac_result, csac(f, d2, d1))
        push!(frfsm_result, frfsm(f, d2, d1))
    end

    cssf_result, csac_result, frfsm_result
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
        f = frequencies(n1)
        d1 = measurements(n1, c)
        f = frequencies(n2)
        d2 = measurements(n2, c)
        push!(_result, _gof(d1, d2))
    end

    _result
end

function _gof(O, E)
    sum(@. (O - E)^2 / E)
end

end # module FRFPlots
