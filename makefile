all:
	python setup.py build_ext --inplace
	cp pyaacrl*.so ./build
	cp main.py ./build
	python build/main.py