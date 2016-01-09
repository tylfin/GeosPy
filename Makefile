build:
	python setup.py build

install:
	python setup.py install

test:
	python -m unittest

build_inplace:
	python setup.py build_ext --inplace

test_inplace:
	export PYTHONPATH=.:${PYTHONPATH}; python -m unittest

clean:
	rm -rf build;
	rm -rf ./tests/*.pyc
	rm -rf ./GeosPy/__pycache__
	rm -rf ./tests/__pychache__
	rm -rf ./GeosPy/**/__pycache__
	rm -f ./**/*.c ./**/*.so ./**/*.pyc
	rm -f ./GeosPy/**/*.c ./GeosPy/**/*.so ./GeosPy/**/*.pyc
