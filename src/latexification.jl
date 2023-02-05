import Latexify: latexify
using Measurements
using LaTeXStrings

latexify(m::Measurement) = LaTeXString("\$$(m.val) \\pm $(m.err)\$")
