# i hate make
#
.PHONY: install
install:
	( cd source && for p in *; do ln -nsf "$$PWD/$$p" ~/."$$p"; done )

