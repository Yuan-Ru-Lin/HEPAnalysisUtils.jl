aux-files := *.aux *.log svg-inkscape
texs := papers/paper/main.tex data/tables/tab.tex
figs := plots/sig.svg plots/bkg.svg plots/all.svg

.PHONY: all
all: papers/paper/main.pdf
	rm -rf $(aux-files)

papers/paper/main.pdf: $(texs) $(figs)
	echo "Building $@"
	pdflatex --shell-escape papers/paper/main.tex

$(figs): scripts/fitter_construction.jl
	JULIA_DEBUG=Main julia --project=. scripts/fitter_construction.jl

data/tables/tab.tex: scripts/writeout_uncertainty_table.jl data/db/data.jld2
	julia --project=. scripts/writeout_uncertainty_table.jl

data/db/data.jld2: scripts/output_correction_factor_1.jl scripts/output_correction_factor_2.jl
	julia --project=. scripts/output_correction_factor_1.jl
	julia --project=. scripts/output_correction_factor_2.jl

.PHONY: clean
clean:
	rm -rf main.pdf $(figs) data/tables/tab.tex data/db/data.jld2
