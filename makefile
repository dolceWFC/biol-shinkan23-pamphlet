PACKAGES := satysfi-fss satysfi-enumitem satysfi-figbox satysfi-easytable satysfi-latexcmds

#pamphletのpdf生成のための変数を指定
BOOKLET := biol-shinkan23-pamphlet
BOOKLET_SOURCE_SATYSFI := $(shell find . -name '*.saty' | sort)
BOOKLET_SOURCE_PDF := $(shell find . -name '*.saty' | sed s/.saty/.pdf/ | sort)
BOOKLET_SOURCE_SATYSFI_AUX := $(shell find . -name '*.saty' | sed s/.saty/.satysfi-aux/ | sort)

.PHONY: build
build: $(BOOKLET).pdf

$(BOOKLET).pdf: $(BOOKLET_SOURCE_PDF)
	pdfunite cover/hyoushi-1.pdf cover/hyoushi2.pdf $^ gakubunkin.pdf cover/hyoushi3.pdf cover/hyoushi-2.pdf biol-shinkan23-pamphlet.pdf

%.pdf: %.saty
	satysfi $^

.PHONY: ci
ci:
	satysfi --type-check-only $(BOOKLET_SOURCE_SATYSFI)

.PHONY: setup
setup:
	opam update
	opam install $(PACKAGES)
	eval $(opam env)
	satyrographos install
	satyrographos install --system-font-prefix 'system:'

.PHONY: clean
clean:
	rm -f $(BOOKLET).pdf
	rm -f $(BOOKLET_SOURCE_PDF) $(BOOKLET_SOURCE_SATYSFI_AUX)