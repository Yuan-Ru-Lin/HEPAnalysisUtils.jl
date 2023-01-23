using Distributions, Optim

"""
See also MIGrad in Chapter 4: Minuit Commands, https://root.cern.ch/download/minuit.pdf
"""
function miunitstop(state::Optim.OptimizationState)
    mt = state.metadata
    edm = mt["g(x)"]' * mt["~inv(H)"] * mt["g(x)"] / 2
    edm < 1e-3 * 0.1 * 1.0
end

