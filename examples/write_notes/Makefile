aux-files := *.aux *.log svg-inkscape
texs := main.tex tab.tex
figs := sig.svg bkg.svg all.svg

all: main.pdf
	rm -rf $(aux-files)

main.pdf: $(texs) $(figs)
	echo "Building $@"
	pdflatex --shell-escape main.tex

$(figs): fitter_construction.jl
	JULIA_DEBUG=Main julia fitter_construction.jl

tab.tex:
	julia writeout_uncertainty_table.jl
