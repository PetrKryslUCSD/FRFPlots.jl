module FRFPlots

using PGFPlotsX
using DelimitedFiles
using DataDrop
using DataDrop: retrieve_json
using JSON
using LinearAlgebra
using Statistics
using FRFComparisons

export frfplots, measurements, frequencies

const yellow = "rgb,255:red,255;green,225;blue,25"
const blue = "rgb,255:red,67;green,99;blue,216"
const orange = "rgb,255:red,245;green,130;blue,49"
const lavender = "rgb,255:red,220;green,190;blue,255"
const maroon = "rgb,255:red,128;green,0;blue,0"
const red = "rgb,255:red,255;green,0;blue,0"
const navy = "rgb,255:red,0;green,0;blue,117"
const grey = "rgb,255:red,169;green,169;blue,169"
const white = "rgb,255:red,255;green,255;blue,255"
const black = "rgb,255:red,0;green,0;blue,0"

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
    Skull_axial => black,
    Skull_transverse => grey,
    Skull_normal => orange,
    TPC_L_axial => maroon,
    TPC_R_axial => lavender,
    TPC_L_transverse => navy,
    TPC_R_transverse => red,
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

function frfplots(inputcsv, curves)
    plots = []

    @info "$(inputcsv)"

    freq = frequencies(inputcsv)
    for c in curves
        d = measurements(inputcsv, c)
# , only_marks
        @pgf push!(plots, Plot({color = colors[c], mark=markers[c], mark_size=1.5, mark_repeat=20, }, Coordinates(freq, d)))
        @pgf push!(plots, LegendEntry(replace(c, "_" => " ")))
    end

    @pgf ax = SemiLogYAxis({
        title = "$(replace(inputcsv, "_" => "\\_"))",
        view = (0, 90),
        height = "9.0cm",
        width = "11.454cm",
        xlabel = "Frequency [Hz]",
        ylabel = "Amplitude [m/(s**2 Pa)]",
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

function frfplots(requests)
    plots = []
    for (j, r) in enumerate(requests)
        inputcsv = r[1]
        freq = frequencies(inputcsv)
        c = r[2]
        experimental = r[3]
        d = measurements(inputcsv, c)
        if experimental
            @pgf push!(plots, Plot({color = colors[c], mark=markers[c], mark_size=1.5, mark_repeat=20, }, Coordinates(freq, d)))
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
        ylabel = "Amplitude [m/(s**2 Pa)]",
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


end # module FRFPlots
