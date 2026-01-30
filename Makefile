# Variables
SRC_NAME := presentation
SRC_MD   := $(SRC_NAME).md
OUT_HTML := $(SRC_NAME).html
OUT_PDF  := $(SRC_NAME).pdf
THEME    := gaia

# Check if Node/NPM is installed
NPM := $(shell command -v npm 2> /dev/null)

.PHONY: all html pdf watch clean check-env install-deps

# Default target: Build both HTML and PDF
all: check-env html pdf

# --- Build Targets ---

# Build HTML version (Best for presenting via browser)
html: $(SRC_MD)
	@echo "Building HTML..."
	@npx @marp-team/marp-cli@latest $(SRC_MD) -o $(OUT_HTML)
	@echo "✔ HTML generated: $(OUT_HTML)"

# Build PDF version (Best for sharing/printing)
# Note: --allow-local-files allows Marp to access local images if you save your SQL screenshots locally
pdf: $(SRC_MD)
	@echo "Building PDF..."
	@npx @marp-team/marp-cli@latest $(SRC_MD) --pdf --allow-local-files -o $(OUT_PDF)
	@echo "✔ PDF generated: $(OUT_PDF)"

# --- Development Targets ---

# Watch mode: Automatically rebuilds HTML on save and refreshes browser
watch: check-env
	@echo "Starting Watch Mode... (Press Ctrl+C to stop)"
	@npx @marp-team/marp-cli@latest -w $(SRC_MD)

# Clean up generated files
clean:
	@echo "Cleaning up..."
	@rm -f $(OUT_HTML) $(OUT_PDF)
	@echo "✔ Clean complete."

# --- Helper Targets ---

# Check for Node.js environment
check-env:
ifndef NPM
	$(error "Node.js/npm is not installed. Please install Node.js to use Marp.")
endif

