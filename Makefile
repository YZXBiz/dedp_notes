clean:
	@uv run jb clean . -a
build:
	@uv run jb build . 
publish: clean
	@uv run jb build . && uv run ghp-import -n -p -f _build/html