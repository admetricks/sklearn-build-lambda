#!/bin/bash
set -ex

pip install --upgrade pip wheel
pip install --use-wheel --no-binary numpy numpy==1.11.1
pip install --use-wheel --no-binary scipy scipy==0.18.1
pip install --use-wheel joblib==0.11

pip install --use-wheel pillow==4.2.1
pip install --use-wheel scikit-image==0.12.3
pip install --use-wheel image-match==1.1.2
pip install --use-wheel imagehash==3.1
pip install --use-wheel psycopg2==2.7.3.1
