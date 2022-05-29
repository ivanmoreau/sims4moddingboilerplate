PY = "/usr/local/opt/python@3.7/bin/python3"
SIMS_MODS = "/Users/ANONVAR/Documents/Electronic Arts/The Sims 4/Mods/"
AUTHOR = "ANONVAR"
MOD = "some_good_mod"

buildandpackage:
	@make build
	@make package

init:
	@echo "Initializing..."
	@make clean
	@mkdir target
	@$(PY) -m venv target/venv && \
	. target/venv/bin/activate && \
	pip install hy appdirs -t target/hylib && \
	deactivate
	@echo "For vim/nvim, use «au BufRead,BufNewFile *.hy set filetype=clojure»"
	@echo "Use «make main» to generate a hello world mod."
	@mkdir src
	@echo "Done."

main:
	@echo "Generating main..."
	@printf "\
(import sims4.commands)\n\
\n\
#@((.Command sims4.commands\n\
  \"hellow\"\n\
  :command-type sims4.commands.CommandType.Live)\n\
(defn sayhello [&optional [-connection None]]\n\
  (setv output (.CheatOutput sims4.commands -connection))\n\
  (output \"Hello world!\")))" > src/main.hy
	@echo "Done."

build:
	@echo "Building..."
	@rm -rf target/build
	@mkdir target/build
	@. target/venv/bin/activate && \
	export PYTHONPATH=target/hylib && \
	find src -name "*.hy" -exec \
	target/hylib/bin/hyc {} \; && \
	deactivate
	@rsync -r --remove-source-files --include '*/' --include '*.pyc' --exclude '*' src/ target/build/
	@find src -type d -name "__pycache__" -empty -delete
	@cd target/build && \
	find . -name "*.pyc" -execdir mv {} .. \; && \
	find . -type d -name "__pycache__" -empty -delete && \
	find . -name "*.pyc" | sed 'p;s/.cpython-37//' | xargs -n2 mv
	@echo "Done."

package:
	@echo "Packaging..."
	@rm -rf target/package
	@mkdir target/package
	@cd target/hylib && \
	zip -r ../package/package.zip * && \
	cd ../build && \
	zip -ur ../package/package.zip *
	@mv target/package/package.zip target/package/${AUTHOR}_${MOD}.ts4script
	@echo "Done."

install:
	@echo "Installing..."
	@rm ${SIMS_MODS}/${AUTHOR}_${MOD}.ts4script
	@cp target/package/${AUTHOR}_${MOD}.ts4script ${SIMS_MODS}
	@echo "Done."

clean:
	@echo "Cleaning up..."
	@rm -rf target
	@echo "Cleaned up."

