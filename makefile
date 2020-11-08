all:
	python setup.py build_ext --inplace
	cp pyaacrl*.so ./build
	cp main.py ./build
	python build/main.py

clean:
	rm pyaacrl/*.egg-info -rf
	rm *.egg-info -rf
	rm _skbuild -rf
	rm *.sqlite