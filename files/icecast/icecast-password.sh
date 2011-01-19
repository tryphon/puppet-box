#!/bin/sh
password=`echo $* | sha256sum | cut -f1 -d' '`
echo -n $password
