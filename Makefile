OUTPUT_DIR := dist

.PHONY: dev dev-r build build-all upload

all: build-all

dev:
	python setup.py develop

dev-r:
	python setup.py develop --uninstall

upload:
	@echo "Uploading packages"
	python scripts/upload.py $(OUTPUT_DIR)

build-all: build
	@echo "Converting packages"
	python scripts/conda_convert.py $(OUTPUT_DIR)

build:
	@echo "When building recipe, make sure your conda environment has conda-build and conda-verify installed"

	rm -rf $(OUTPUT_DIR)
	mkdir -p $(OUTPUT_DIR)

# dash in front of command to continue execution even on error. There's a bug that causes conda build to raise an
# error even though the command works fine. Bug likely due to vc runtime for windows
	-conda build --output-folder $(OUTPUT_DIR) conda.recipe

	@echo "------------------ Build complete. Purging build environment ------------------"
	conda build purge
# remove python build directory and egg fodler
	rm -rf build/ allopy.egg-info/

test:
	pytest -rsx