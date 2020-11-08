all:
	python setup.py build_ext --inplace
	mv pyaacrl/pyaacrl*.so ./_skbuild
	cp main.py ./_skbuild
	python _skbuild/main.py

clean:
	rm pyaacrl/*.egg-info -rf
	rm *.egg-info -rf
	rm _skbuild -rf
	rm *.sqlite