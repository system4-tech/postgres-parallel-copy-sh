all: clean deps shellcheck test build
deps:
	@wget https://raw.githubusercontent.com/system4-tech/utils-sh/refs/heads/main/lib/utils.sh -qP lib/
build:
	@awk -f inline.awk src/main.sh > dist/postgres-parallel-copy.sh
	@chmod +x dist/postgres-parallel-copy.sh
clean:
	@rm -f lib/*.sh dist/*.sh
test:
	@bats tests/*.bats
shellcheck:
	@shellcheck src/*.sh
