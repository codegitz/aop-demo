#!/usr/bin/env bash

ASPECTJ_TOOLS=../jar/aspectjtools-1.8.9.jar
ASPECTJ_RT=../jar/aspectjrt-1.8.9.jar

java -jar $ASPECTJ_TOOLS -cp $ASPECTJ_RT -sourceroots ../

