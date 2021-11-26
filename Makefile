# Pátý rod, Makefile
# Copyright (c) 2021 Singularis <singularis@volny.cz>
#
# Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
# podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
# vydané neziskovou organizací Creative Commons. Text licence je přiložený
# k tomuto projektu nebo ho můžete najít na webové adrese:
#
# https://creativecommons.org/licenses/by-sa/4.0/
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

SHELL := /bin/bash
AWK := gawk
SED := sed -E

# Další nastavení
# ----------------------------------------------------------------------------
export SOUBORY_PREKLADU := soubory_překladu
export VYSTUP_PREKLADU := výstup_překladu

CASTI=00-úvod.tex 01-podstatná-jména.tex 02-přídavná-jména.tex 03-zájmena.tex 04-číslovky.tex 05-slovesa.tex 06-slovotvorba.tex 07-závěr.tex

.PHONY: all clean pdf
.DELETE_ON_ERROR: # Přítomnost tohoto cíle nastaví „make“, aby v případě kteréhokoliv pravidla byl odstraněn jeho cíl.
.SUFFIXES: # Vypíná implicitní obecná pravidla pro přípony

all: pdf

clean:
	$(RM) -Rv $(SOUBORY_PREKLADU) $(VYSTUP_PREKLADU)

pdf: $(VYSTUP_PREKLADU)/rod-pátý-gm.pdf $(VYSTUP_PREKLADU)/rod-pátý-bgm.pdf $(VYSTUP_PREKLADU)/rod-pátý-cmp.pdf

$(VYSTUP_PREKLADU)/rod-pátý-gm.pdf: $(addprefix mluvnice/, $(CASTI))
	@mkdir -pv $(SOUBORY_PREKLADU) $(VYSTUP_PREKLADU)
	cat $^ > $(SOUBORY_PREKLADU)/rod.tex
	env -C $(SOUBORY_PREKLADU) xelatex -halt-on-error -file-line-error -interaction=errorstopmode -no-shell-escape rod.tex
	cp -fvT $(SOUBORY_PREKLADU)/rod.pdf $@

$(VYSTUP_PREKLADU)/rod-pátý-bgm.pdf: $(addprefix mluvnice/, $(CASTI))
	@mkdir -pv $(SOUBORY_PREKLADU) $(VYSTUP_PREKLADU)
	sed -E 's/^\\newboolean\{gm\}\\setboolean\{gm\}\{true\}%$$/\\newboolean{gm}\\setboolean{gm}{false}%/' -- $^ > $(SOUBORY_PREKLADU)/rodbgm.tex
	env -C $(SOUBORY_PREKLADU) xelatex -halt-on-error -file-line-error -interaction=errorstopmode -no-shell-escape rodbgm.tex
	cp -fvT $(SOUBORY_PREKLADU)/rodbgm.pdf $@

$(VYSTUP_PREKLADU)/rod-pátý-cmp.pdf: $(addprefix mluvnice/, $(CASTI))
	@mkdir -pv $(SOUBORY_PREKLADU) $(VYSTUP_PREKLADU)
	#sed -E 's/^\\newcommand\{\\ifgmelse\}[2]\{.*\}$$/\\newcommand{\\ifgmelse}[2]{[[#1\/\/#2]]}}/' -- $^ > $(SOUBORY_PREKLADU)/rodcmp.tex
	sed -E 's/^\\newcommand\{\\ifgmelse\}\[2\]\{.*\}$$/\\newcommand{\\ifgmelse}[2]{[[\\colorbox{pink}{~}{\\itshape #1}\/\/\\colorbox{green}{~}{\\itshape{#2}}]]}/' -- $^ > $(SOUBORY_PREKLADU)/rodcmp.tex
	env -C $(SOUBORY_PREKLADU) xelatex -halt-on-error -file-line-error -interaction=errorstopmode -no-shell-escape rodcmp.tex
	cp -fvT $(SOUBORY_PREKLADU)/rodcmp.pdf $@
