#!/bin/bash

TEMPLATE=$1

BLOCKNAME=$2

sudo mkdir /var/www/$BLOCKNAME;

sudo chown -R $USER:$USER /var/www/$BLOCKNAME;

cp ./nginx-block-stubs/$TEMPLATE.stub ./$BLOCKNAME

sed -i "s/{{BLOCKNAME}}/$BLOCKNAME/g" ./$BLOCKNAME

case $TEMPLATE in
  laravel)
    PHP_VERSION=$3

    sed -i "s/{{PHP_VERSION}}/$PHP_VERSION/g" ./$BLOCKNAME
    ;;

  static)
    BUILD_DIR=$3

    sed -i "s/{{BUILD_DIR}}/$BUILD_DIR/g" ./$BLOCKNAME
    ;;

  reverse)
    TARGET=$3
    PORT=$4

    sed -i "s/{{TARGET}}/$TARGET/g" ./$BLOCKNAME
    sed -i "s/{{PORT}}/$PORT/g" ./$BLOCKNAME
    ;;
esac

sudo mv ./$BLOCKNAME /etc/nginx/sites-available/;

sudo ln -s /etc/nginx/sites-available/$BLOCKNAME /etc/nginx/sites-enabled/;
