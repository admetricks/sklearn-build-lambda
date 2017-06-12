#!/bin/bash
set -ex

pip install --upgrade pip wheel
pip install --use-wheel --no-binary numpy numpy==1.11.1
pip install --use-wheel --no-binary scipy scipy==0.18.1
pip install --use-wheel scikit-learn==0.18
pip install --use-wheel pandas==0.18.1
pip install --use-wheel joblib==0.11
