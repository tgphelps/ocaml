
OPTS=-use-ocamlfind -classic-display

all: filter hdump

filter:
	ocamlbuild $(OPTS) $@.native

hdump:
	ocamlbuild $(OPTS) $@.native

clean:
	ocamlbuild -clean

depend:
	ocamldep *.mli *.ml >.depend

include .depend

# byte:
	# ocamlbuild $(OPTS) $(PROG).byte

# mylib:
# 	ocamlbuild $(OPTS) mylib.cma

