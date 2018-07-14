#!/bin/bash
set -e

echo "--== deleting tmp ==--"
rm -rf tmp

echo "--== creating tmp ==--"
mkdir tmp

for NAME in a b c d helper with_externals
do
    echo "--== setting up the ${NAME} repo ==--"
    svn co http://localhost:18080/svn/${NAME} tmp/${NAME} --username=admin --password=admin
    mkdir test/svn-data/repositories/${NAME}/db/txn-protorevs || true
    mkdir test/svn-data/repositories/${NAME}/db/transactions || true
    touch tmp/${NAME}/${NAME}
    date >> tmp/${NAME}/${NAME}
    svn add tmp/${NAME}/* --force
    svn commit tmp/${NAME} -m "first commit in ${NAME}"
done

svn up tmp/with_externals
svn propset svn:externals "helper http://svn-server:18080/svn/helper" tmp/with_externals || true
svn up tmp/with_externals || true
svn commit -m 'added external helper' tmp/with_externals || true
