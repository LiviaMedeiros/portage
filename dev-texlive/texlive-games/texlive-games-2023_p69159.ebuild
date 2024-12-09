# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TEXLIVE_MODULE_CONTENTS="
	collection-games.r69159
	bartel-chess-fonts.r20619
	chess.r20582
	chess-problem-diagrams.r63708
	chessboard.r56833
	chessfss.r19440
	chinesechess.r63276
	crossword.r64375
	crosswrd.r16896
	customdice.r64089
	egameps.r15878
	gamebook.r24714
	gamebooklib.r67772
	go.r28628
	hanoi.r25019
	havannah.r36348
	hexboard.r62102
	hexgame.r15878
	hmtrump.r54512
	horoscop.r56021
	jeuxcartes.r68266
	jigsaw.r66009
	labyrinth.r33454
	logicpuzzle.r34491
	mahjong.r58896
	maze.r65508
	musikui.r47472
	nimsticks.r64118
	onedown.r69067
	othello.r15878
	othelloboard.r23714
	pas-crosswords.r32313
	playcards.r67342
	psgo.r15878
	quizztex.r68823
	realtranspose.r56623
	reverxii.r63753
	rouequestions.r67670
	rubik.r46791
	schwalbe-chess.r63708
	scrabble.r69599
	sgame.r30959
	skak.r61719
	skaknew.r20031
	soup.r50815
	sudoku.r67189
	sudokubundle.r15878
	tangramtikz.r66183
	thematicpuzzle.r69356
	trivialpursuit.r68971
	wargame.r69692
	wordle.r68170
	xq.r35211
	xskak.r51432
"
TEXLIVE_MODULE_DOC_CONTENTS="
	bartel-chess-fonts.doc.r20619
	chess.doc.r20582
	chess-problem-diagrams.doc.r63708
	chessboard.doc.r56833
	chessfss.doc.r19440
	chinesechess.doc.r63276
	crossword.doc.r64375
	crosswrd.doc.r16896
	customdice.doc.r64089
	egameps.doc.r15878
	gamebook.doc.r24714
	gamebooklib.doc.r67772
	go.doc.r28628
	havannah.doc.r36348
	hexboard.doc.r62102
	hexgame.doc.r15878
	hmtrump.doc.r54512
	horoscop.doc.r56021
	jeuxcartes.doc.r68266
	jigsaw.doc.r66009
	labyrinth.doc.r33454
	logicpuzzle.doc.r34491
	mahjong.doc.r58896
	maze.doc.r65508
	musikui.doc.r47472
	nimsticks.doc.r64118
	onedown.doc.r69067
	othello.doc.r15878
	othelloboard.doc.r23714
	pas-crosswords.doc.r32313
	playcards.doc.r67342
	psgo.doc.r15878
	quizztex.doc.r68823
	realtranspose.doc.r56623
	reverxii.doc.r63753
	rouequestions.doc.r67670
	rubik.doc.r46791
	schwalbe-chess.doc.r63708
	scrabble.doc.r69599
	sgame.doc.r30959
	skak.doc.r61719
	skaknew.doc.r20031
	soup.doc.r50815
	sudoku.doc.r67189
	sudokubundle.doc.r15878
	tangramtikz.doc.r66183
	thematicpuzzle.doc.r69356
	trivialpursuit.doc.r68971
	wargame.doc.r69692
	wordle.doc.r68170
	xq.doc.r35211
	xskak.doc.r51432
"
TEXLIVE_MODULE_SRC_CONTENTS="
	chess-problem-diagrams.source.r63708
	chessboard.source.r56833
	chessfss.source.r19440
	crossword.source.r64375
	crosswrd.source.r16896
	customdice.source.r64089
	gamebook.source.r24714
	gamebooklib.source.r67772
	go.source.r28628
	havannah.source.r36348
	hexboard.source.r62102
	horoscop.source.r56021
	mahjong.source.r58896
	nimsticks.source.r64118
	onedown.source.r69067
	realtranspose.source.r56623
	reverxii.source.r63753
	rubik.source.r46791
	schwalbe-chess.source.r63708
	soup.source.r50815
	sudoku.source.r67189
	sudokubundle.source.r15878
	wargame.source.r69692
	xskak.source.r51432
"

inherit texlive-module

DESCRIPTION="TeXLive Games typesetting"

LICENSE="CC-BY-1.0 CC-BY-SA-4.0 GPL-1+ LGPL-2.1 LGPL-3 LPPL-1.2 LPPL-1.3 LPPL-1.3c MIT TeX-other-free public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
COMMON_DEPEND="
	>=dev-texlive/texlive-latex-2023
"
RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
"

TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/rubik/rubikrotation.pl
"
