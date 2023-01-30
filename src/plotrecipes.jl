using Distributions

"""
c.f. https://root.cern.ch/doc/v608/TH1_8cxx_source.html#l08189
"""
function poissonerrs(n; alpha=0.3173105)
    n == 0 && return (0, 0)
    (n - quantile(Gamma(n, 1), alpha/2),
     cquantile(Gamma(n+1, 1), alpha/2) - n)
end

"""
Wait until this settles: https://github.com/JuliaLang/julia/issues/13942
"""
unzip2tuples(x) = tuple(getindex.(x, 1), getindex.(x, 2))

centers(x) = (x[1:end-1]+x[2:end])/2

using Plots, RecipesBase

"""
The two functions here are to make `yerror` customizable.

See also https://github.com/JuliaPlots/Plots.jl/issues/2156
"""
function errorcap_coords(errorbar, errordata, otherdata; capsize)
    ed = Vector{Plots.float_extended_type(errordata)}(undef, 0)
    od = Vector{Plots.float_extended_type(otherdata)}(undef, 0)
    for (j, (edi, odj)) in enumerate(zip(errordata, otherdata))
        e1, e2 = Plots.error_tuple(Plots._cycle(errorbar, j))
        Plots.nanappend!(ed, [edi - e1, edi - e1])
        Plots.nanappend!(ed, [edi + e2, edi + e2])
        Plots.nanappend!(od, [odj-capsize/2, odj+capsize/2])
        Plots.nanappend!(od, [odj-capsize/2, odj+capsize/2])
    end
    return (ed, od)
end

@recipe function f(::Type{Val{:yerror}}, x, y, z)
    Plots.error_style!(plotattributes)
    yerr = Plots.error_zipit(plotattributes[:yerror])
    if z === nothing
        plotattributes[:y], plotattributes[:x] = Plots.error_coords(yerr, y, x)
        errcapy, errcapx = errorcap_coords(yerr, y, x; capsize=get(plotattributes, :capsize, 0.1))
        Plots.nanappend!(plotattributes[:y], errcapy)
        Plots.nanappend!(plotattributes[:x], errcapx)
    else
        plotattributes[:y], plotattributes[:x], plotattributes[:z] =
        Plots.error_coords(yerr, y, x, z)
    end
    ()
end

using StatsBase

struct DataHist end
@recipe function f(dh::DataHist, data::AbstractVector, bins, _pdf::Union{ContinuousUnivariateDistribution, Nothing}=nothing)

    hist = fit(Histogram, data, bins)
    ys = hist.weights

    @series begin
        seriestype := :scatter
        markercolor := :black
        markersize := 3
        yerror := ys .|> poissonerrs |> unzip2tuples
        capsize := 0
        label --> "Data"
        centers(bins), ys
    end

    _pdf === nothing || @series begin
        seriestype := :line
        linecolor := :blue
        label --> "Fit"
        norm = sum(ys)
        centers(bins), pdf.(Ref(_pdf), centers(bins)) * norm .* diff(bins)
    end

end

