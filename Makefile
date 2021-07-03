PROJECT = lxml
ROOT_DIR = $(shell pwd)
REPO = $(shell git config --get remote.origin.url)
LFE = _build/default/lib/lfe/bin/lfe
DOCS_DIR = $(ROOT_DIR)/docs
GUIDE_DIR = $(DOCS_DIR)/user-guide
GUIDE_BUILD_DIR = $(GUIDE_DIR)/build
DOCS_PROD_DIR = $(DOCS_DIR)/gh-pages
GUIDE_PROD_DIR = $(DOCS_PROD_DIR)/current/user-guide
LOCAL_DOCS_HOST = localhost
LOCAL_DOCS_PORT = 5099
DOCKER_IMG = lfex/slate:2.10.0-ruby2.6

compile:
	rebar3 compile

check:
	@rebar3 as test lfe ltest -tall

repl: compile
	rebar3 lfe repl

shell:
	@rebar3 shell

clean:
	@rebar3 clean
	@rm -rf ebin/* _build/default/lib/$(PROJECT)

clean-all: clean
	@rebar3 lfe clean

build-slate-image:
	@echo "\nBuilding Slate ..."
	@git clone git@github.com:lfe-support/slate.git
	@cd slate && make image

$(DOCS_PROD_DIR):
	git submodule add -b gh-pages `git remote get-url --push origin` $(DOCS_PROD_DIR)

gh-pages: $(DOCS_PROD_DIR)

docs-setup:
	@echo "\nInstalling and setting up dependencies ..."
	@docker pull $(DOCKER_IMG)

docs-clean:
	@echo "\nCleaning build directories ..."
	@rm -rf $(GUIDE_BUILD_DIR) $(GUIDE_PROD_DIR)

docs-slate:
	@echo
	@cd $(GUIDE_DIR) && docker run \
	    -i \
	    -p 4567:4567 \
	    -v `pwd`/build:/srv/slate/build \
	    -v `pwd`/source:/srv/slate/source \
	    -t $(DOCKER_IMG)
	@mkdir $(GUIDE_PROD_DIR)
	@cp -r $(GUIDE_BUILD_DIR)/* $(GUIDE_PROD_DIR)/

docs: clean docs-clean compile
	@echo "\nBuilding docs ..."
	@make docs-slate

devdocs: docs
	@echo
	@echo "Running docs server on http://$(LOCAL_DOCS_HOST):$(LOCAL_DOCS_PORT) ... (To quit, hit ^c twice)"
	@echo
	@erl -s inets -noshell -eval 'inets:start(httpd,[{server_name,"devdocs"},{document_root, "$(DOCS_PROD_DIR)"},{server_root, "$(DOCS_PROD_DIR)"},{port, $(LOCAL_DOCS_PORT)},{mime_types,[{"html","text/html"},{"htm","text/html"},{"js","text/javascript"},{"css","text/css"},{"gif","image/gif"},{"jpg","image/jpeg"},{"jpeg","image/jpeg"},{"png","image/png"}]}]).'

setup-temp-repo:
	@echo "\nSetting up temporary git repos for gh-pages ...\n"
	@rm -rf $(DOCS_PROD_DIR)/.git $(DOCS_PROD_DIR)/*/.git
	@cd $(DOCS_PROD_DIR) && git init
	@cd $(DOCS_PROD_DIR) && git add * > /dev/null
	@cd $(DOCS_PROD_DIR) && git commit -a -m "Generated content." > /dev/null

teardown-temp-repo:
	@echo "\nTearing down temporary gh-pages repos ..."
	@rm $(DOCS_DIR)/.git $(GUIDE_DIR)/Gemfile.lock
	@rm -rf $(DOCS_PROD_DIR)/.git $(DOCS_PROD_DIR)/*/.git

publish-docs: docs setup-temp-repo
	@echo "\nPublishing docs ...\n"
	@cd $(DOCS_PROD_DIR) && git push -f $(REPO) master:gh-pages
	@make teardown-temp-repo

.PHONY: docs
