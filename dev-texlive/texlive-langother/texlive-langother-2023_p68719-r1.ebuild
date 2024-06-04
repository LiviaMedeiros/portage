# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

TEXLIVE_MODULE_CONTENTS="
	collection-langother.r68719
	aalok.r61719
	akshar.r56277
	aramaic-serto.r30042
	babel-azerbaijani.r44197
	babel-esperanto.r30265
	babel-georgian.r45864
	babel-hebrew.r68016
	babel-indonesian.r43235
	babel-interlingua.r30276
	babel-malay.r43234
	babel-sorbian.r60975
	babel-thai.r30564
	babel-vietnamese.r39246
	bangla.r65786
	bangtex.r55475
	bengali.r55475
	burmese.r25185
	chhaya.r61719
	cjhebrew.r43444
	ctib.r15878
	culmus.r68495
	ebong.r67933
	ethiop.r15878
	ethiop-t1.r15878
	fc.r32796
	fonts-tlwg.r60817
	hebrew-fonts.r68038
	hyphen-afrikaans.r58609
	hyphen-armenian.r58652
	hyphen-coptic.r58652
	hyphen-esperanto.r58652
	hyphen-ethiopic.r58652
	hyphen-georgian.r58652
	hyphen-indic.r58652
	hyphen-indonesian.r58609
	hyphen-interlingua.r58609
	hyphen-sanskrit.r58652
	hyphen-thai.r58652
	hyphen-turkmen.r58652
	latexbangla.r55475
	latino-sine-flexione.r69568
	marathi.r61719
	padauk.r42617
	quran-bn.r68345
	quran-id.r68747
	quran-ur.r68314
	sanskrit.r64502
	sanskrit-t1.r55475
	thaienum.r44140
	thaispec.r58019
	unicode-alphabets.r66225
	vntex.r62837
	wnri.r22459
	wnri-latex.r22338
	xetex-devanagari.r34296
"
TEXLIVE_MODULE_DOC_CONTENTS="
	aalok.doc.r61719
	akshar.doc.r56277
	amsldoc-vn.doc.r21855
	aramaic-serto.doc.r30042
	babel-azerbaijani.doc.r44197
	babel-esperanto.doc.r30265
	babel-georgian.doc.r45864
	babel-hebrew.doc.r68016
	babel-indonesian.doc.r43235
	babel-interlingua.doc.r30276
	babel-malay.doc.r43234
	babel-sorbian.doc.r60975
	babel-thai.doc.r30564
	babel-vietnamese.doc.r39246
	bangla.doc.r65786
	bangtex.doc.r55475
	bengali.doc.r55475
	burmese.doc.r25185
	chhaya.doc.r61719
	cjhebrew.doc.r43444
	ctib.doc.r15878
	culmus.doc.r68495
	ebong.doc.r67933
	ethiop.doc.r15878
	ethiop-t1.doc.r15878
	fc.doc.r32796
	fonts-tlwg.doc.r60817
	hebrew-fonts.doc.r68038
	hindawi-latex-template.doc.r57757
	hyphen-sanskrit.doc.r58652
	latex-mr.doc.r55475
	latexbangla.doc.r55475
	latino-sine-flexione.doc.r69568
	lshort-thai.doc.r55643
	lshort-vietnamese.doc.r55643
	marathi.doc.r61719
	ntheorem-vn.doc.r15878
	padauk.doc.r42617
	quran-bn.doc.r68345
	quran-id.doc.r68747
	quran-ur.doc.r68314
	sanskrit.doc.r64502
	sanskrit-t1.doc.r55475
	thaienum.doc.r44140
	thaispec.doc.r58019
	unicode-alphabets.doc.r66225
	vntex.doc.r62837
	wnri.doc.r22459
	wnri-latex.doc.r22338
	xetex-devanagari.doc.r34296
"
TEXLIVE_MODULE_SRC_CONTENTS="
	aalok.source.r61719
	akshar.source.r56277
	babel-azerbaijani.source.r44197
	babel-esperanto.source.r30265
	babel-hebrew.source.r68016
	babel-indonesian.source.r43235
	babel-interlingua.source.r30276
	babel-malay.source.r43234
	babel-sorbian.source.r60975
	babel-thai.source.r30564
	babel-vietnamese.source.r39246
	bengali.source.r55475
	burmese.source.r25185
	chhaya.source.r61719
	ctib.source.r15878
	culmus.source.r68495
	ethiop.source.r15878
	fonts-tlwg.source.r60817
	hebrew-fonts.source.r68038
	hyphen-armenian.source.r58652
	hyphen-ethiopic.source.r58652
	hyphen-turkmen.source.r58652
	marathi.source.r61719
	sanskrit.source.r64502
	thaispec.source.r58019
	vntex.source.r62837
	wnri-latex.source.r22338
"

inherit texlive-module

DESCRIPTION="TeXLive Other languages"

LICENSE="CC-BY-SA-4.0 FDL-1.1+ GPL-1+ GPL-2 GPL-2+ GPL-3+ LPPL-1.3 LPPL-1.3c OFL-1.1 TeX-other-free public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
COMMON_DEPEND="
	>=dev-texlive/texlive-basic-2023
"
RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
"

TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/ebong/ebong.py
"
