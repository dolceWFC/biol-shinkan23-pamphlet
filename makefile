PACKAGES := satysfi-fss satysfi-enumitem satysfi-figbox satysfi-easytable satysfi-latexcmds

#pamphletのpdf生成のための変数を指定
BOOKLET := biol-shinkan23-pamphlet
BOOKLET_SOURCE_SATYSFI := $(shell find . -name '*.saty' | sort)
BOOKLET_SOURCE_PDF := $(shell find . -name '*.saty' | sed s/.saty/.pdf/ | sort)
BOOKLET_SOURCE_SATYSFI_AUX := $(shell find . -name '*.saty' | sed s/.saty/.satysfi-aux/ | sort)

.PHONY: build
build: $(BOOKLET).pdf

#booklet全体をソースpdfから作るよ
$(BOOKLET).pdf: $(BOOKLET_SOURCE_PDF)
#全体生成
	pdfunite  $^ gakubunkin.pdf biol-shinkan23-pamphlet.pdf

#各satyからpdfを生成します(略記？)
%.pdf: %.saty
	satysfi $^

#ダミーコマンド設定
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