#!/bin/bash

sed -i -e 's/hasSolidBackground:""/hasSolidBackground:!1/' MenuBuilder.doccarchive/js/documentation-topic.*.js
cp style.css MenuBuilder.doccarchive/
