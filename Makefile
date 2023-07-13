LIBDIR := lib
include $(LIBDIR)/main.mk

$(LIBDIR)/main.mk:
ifneq (,$(shell grep "path *= *$(LIBDIR)" .gitmodules 2>/dev/null))
	git submodule sync
	git submodule update $(CLONE_ARGS) --init
else
	git clone -q --depth 10 $(CLONE_ARGS) \
	    -b main https://github.com/martinthomson/i-d-template $(LIBDIR)
endif

lint:: http-lint

rfc-http-validate ?= rfc-http-validate
.SECONDARY: $(drafts_xml)
.PHONY: http-lint
http-lint: $(addsuffix .http-lint.txt,$(addprefix .,$(drafts)))
.PHONY: .%.http-lint.txt
.%.http-lint.txt: %.xml $(DEPS_FILES)
	$(trace) $< -s http-lint $(rfc-http-validate) -q -m sf.json $<
	@touch $@
