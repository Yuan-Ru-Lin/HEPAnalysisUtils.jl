using Distributions
struct Extended{D<:Distribution}
    d::D
    ν::Float64
end

import Distributions: loglikelihood
loglikelihood(ed::Extended{D}, xs::AbstractArray) where {D<:Distribution} = loglikelihood(Poisson(ed.ν), length(xs)) + loglikelihood(ed.d, xs)

using Plots
using StatsPlots
@recipe function f(::Type{Extended{D}}, ed::Extended{D}) where {D<:Distribution}
    components --> false
    _step = step(plotattributes[:bins])
    func := (dist, x) -> pdf(dist, x) * ed.ν * _step
    ed.d
end
