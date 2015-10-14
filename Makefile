build:
	python setup.py build

install:
	python setup.py install

test:
	python -m unittest discover ./tests/ "test_*.py"

build_inplace:
	python setup.py build_ext --inplace

test_inplace:
	export PYTHONPATH=.:${PYTHONPATH}; python -m unittest discover ./tests/ "*.py"

clean:
	rm -rf build;
	rm -f ./GeosPy/*.c ./GeosPy/*.so ./GeosPy/*.pyc
	rm -rf ./GeosPy/__pycache__
	rm -f ./GeosPy/**/*.c ./GeosPy/**/*.so ./GeosPy/**/*.pyc
	rm -rf ./GeosPy/__pycache__
	rm -rf ./tests/__pychache__
	rm -rf ./tests/*.pyc
