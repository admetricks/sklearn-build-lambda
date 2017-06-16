#!/bin/bash
set -ex

do_pip () {
    /outputs/requirements.sh
}

strip_virtualenv () {
    echo "venv original size $(du -sh $VIRTUAL_ENV | cut -f1)"
    find $VIRTUAL_ENV/lib64/python2.7/site-packages/ -name "*.so" | xargs strip
    echo "venv stripped size $(du -sh $VIRTUAL_ENV | cut -f1)"

    pushd $VIRTUAL_ENV/lib/python2.7/site-packages/ && zip -r -9 -q /outputs/venv.zip joblib* ; popd

    pushd $VIRTUAL_ENV/lib64/python2.7/site-packages/ && zip -r -9 -q /outputs/venv.zip * ; popd
    echo "site-packages compressed size $(du -sh /outputs/venv.zip | cut -f1)"

    pushd $VIRTUAL_ENV && zip -r -q /outputs/full-venv.zip * ; popd
    echo "venv compressed size $(du -sh /outputs/full-venv.zip | cut -f1)"
}

shared_libs () {
    libdir="$VIRTUAL_ENV/lib64/python2.7/site-packages/lib/"
    mkdir -p $VIRTUAL_ENV/lib64/python2.7/site-packages/lib || true
    cp /usr/lib64/atlas/* $libdir
    cp /usr/lib64/libquadmath.so.0 $libdir
    cp /usr/lib64/libgfortran.so.3 $libdir
}

uploadtos3 () {
    pip install awscli
    aws s3 cp /outputs/venv.zip s3://$S3_BUCKET/"$S3_PREFIX"venv.`date +%Y%m%d%H%M%S`.zip
}

main () {
    /usr/bin/virtualenv \
        --python /usr/bin/python /sklearn_build \
        --always-copy \
        --no-site-packages
    source /sklearn_build/bin/activate

    do_pip

    shared_libs

    strip_virtualenv

    uploadtos3
}
main
