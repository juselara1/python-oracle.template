#!/usr/bin/env bash
compile_dependencies() {
	local deps=( "" "-dev" )
	for dep in "${deps[@]}"; do
		echo "Compiling ${dep}"
		uv pip compile "requirements/requirements${dep}.in" > "requirements/requirements${dep}.txt"
	done
}

$*
exit 0
