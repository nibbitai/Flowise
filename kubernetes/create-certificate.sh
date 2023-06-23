#! /usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

readonly HERE=$(cd "$(dirname "$0")" && pwd)
readonly REPO=$(cd "${HERE}"/.. && pwd)
readonly PROGNAME=$(basename "$0")




readonly ENVIRONMENT="$1"
echo "ENVIRONMENT: $ENVIRONMENT"




# Target defines the file which the rendered file will be outputted.
TARGET="${REPO}/kubernetes/deploy-certificate.yml"
echo "TARGET: $TARGET"

readonly FILES="kubernetes/templates/certificate.yml"

exec > >(git stripspace >"$TARGET")

for f in $FILES; do
   (ls "$f") | awk '{printf "#       %s\n", $0}'
done

echo

for y in $FILES ; do
    echo # Ensure we have at least one newline between joined fragments.
    cat $y |
        sed "s/\$(ENVIRONMENT)n/$ENVIRONMENT.n/g" |
        sed "s/\$(ENVIRONMENT)-/$ENVIRONMENT-/g" 
done
