test: failing-tests successful-tests

failing-tests:
	cd examples/failing-tests && \
	if nix flake check --no-write-lock-file 2>/dev/null ; then echo "expected the tests to fail!" ; exit 1; fi

successful-tests:
	cd examples/successful-tests && \
	nix flake check --no-write-lock-file -L

.PHONY: test failing-tests successful-tests
