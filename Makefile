# VARIABLE
SCSS_DIR := "assets/scss/vendor"

# LIST OF THE COMMANDS
help:
	@echo "Commands available:"
	@echo "- 'rebuild': rebuild the public directory in the 'exampleSite'"

# COMMANDS
build:
	@rm -rf docs
	@rm -rf exampleSite/public
	@cd exampleSite && hugo --destination ../docs && cd .. 
	@echo "SITE REBUILT"

publish:build
	@git add -A
	@git commit -m "Publishing site"
	@git push origin HEAD

post:
	@cd exampleSite && hugo new --logLevel info content/posts/$(NAME).md
	@cd .. 

serve:
	@cd exampleSite && hugo server --buildDrafts --disableFastRender

serve-nodrafts:
	@cd exampleSite && hugo server --disableFastRender

chroma:
	hugo gen chromastyles --style=monokai > assets/scss/syntax/syntax-dark.scss
