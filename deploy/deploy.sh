#!/bin/bash

echo '<<<<<<ここです！<<<<<<<<'
`echo ${POSTGRES_HOST} | sed 's/&/\\\&/g'`
echo '<<<<<<ここです！<<<<<<<<'