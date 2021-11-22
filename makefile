all:
	python setup.py build_ext --inplace
	@echo "Commands to run test program:"
	@echo "   python main.py fingerprint lib.sqlite /path"
	@echo "   python main.py match lib.sqlite /path"

clean:
	rm pyaacrl/*.egg-info -rf
	rm *.egg-info -rf
	rm _skbuild -rf
	rm *.sqlite

sync-yaacrl:
	cd vendor/yaacrl && git checkout master && git pull
	git add vendor/yaacrl