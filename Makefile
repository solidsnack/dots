# i hate make
#
.PHONY: install
install:
	git submodule init && git submodule update
	( cd source && for p in *; do ln -nsf "$$PWD/$$p" ~/."$$p"; done )

