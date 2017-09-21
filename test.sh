VERSION=$1
PLAIN_VERSION=$(echo $VERSION | sed -e 's/v//g')
echo $PLAIN_VERSION
