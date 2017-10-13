#!/bin/bash
source ./params.env
pivnet login --api-token $api_token
om --target $om_target --skip-ssl-validation --username $username --password $password staged-products | tee releases/staged-products.current

om --target $om_target --skip-ssl-validation --username $username --password $password staged-products | grep -e "^| [a-Z]" | awk '{ print $2 }' | while read p; do pivnet releases -p $p --format=json |  jq --arg p $p --tab '{ ($p): .[0] }' | tee  releases/$p.release; done 

p=stemcells
bosh -e pcf stemcells --json |jq --arg p $p --tab  '{ ($p) :.Tables[0].Rows[0]}' | tee releases/$p.current
pivnet releases -p $p --format=json |  jq --arg p $p --tab '{ ($p): .[0] }' | tee releases/$p.release
