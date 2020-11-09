all:
	python setup.py build_ext --inplace
	python main.py

clean:
	rm pyaacrl/*.egg-info -rf
	rm *.egg-info -rf
	rm _skbuild -rf
	rm *.sqlite