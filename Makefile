# VARIABLE
SCSS_DIR := "assets/scss/vendor"

# LIST OF THE COMMANDS
help:
	@echo "Commands available:"
	@echo "- 'rebuild': rebuild the public directory in the 'exampleSite'"

# COMMANDS
rebuild:
	@rm -rf exampleSite/public
	@cd exampleSite && hugo && cd .. 
	@echo "SITE REBUILT"

serve:
	@cd exampleSite && hugo server --buildDrafts --disableFastRender

chroma:
	hugo gen chromastyles --style=monokai > assets/scss/syntax/syntax-dark.scss
