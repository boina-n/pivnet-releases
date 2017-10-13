#!/bin/bash
source ./params.env
pivnet login --api-token $api_token
om --target $om_target --skip-ssl-validation --username $username --password $password staged-products | grep -e "^| [a-Z]" | awk '{ print $2 }' | while read p; do pivnet releases -p $p --format=json |  jq --arg p $p --tab '{ ($p): .[0] }' > releases/$p.release; done 
