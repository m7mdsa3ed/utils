#!/bin/bash

for ARGUMENT in "$@"; do
  KEY=$(echo $ARGUMENT | cut -f1 -d=)

  KEY_LENGTH=${#KEY}
  VALUE="${ARGUMENT:$KEY_LENGTH+1}"

  if [ ! -z "$VALUE" ]; then
    export "_$KEY"="$VALUE"
    echo "_$KEY=$VALUE";
  fi
done

TEMPLATE=$_template

BLOCKNAME=$_project_name

mkdir /var/www/$BLOCKNAME;

chown -R $USER:$USER /var/www/$BLOCKNAME;

cp ./nginx-block-stubs/$TEMPLATE.stub ./$BLOCKNAME

sed -i "s/{{BLOCKNAME}}/$BLOCKNAME/g" ./$BLOCKNAME

declare -A VARS

case $TEMPLATE in
  'laravel')
    VARS[PHP_VERSION]=$_php_version
    ;;

  'static')
    VARS[BUILD_DIR]=$_build_dir
    ;;

  'reverse')
    VARS[TARGET]=$_target
    VARS[PORT]=$_port
    ;;
esac

for i in "${!VARS[@]}"; do
  KEY=$i
  VALUE=${VARS[$i]}

  sed -i "s/{{$KEY}}/$VALUE/g" ./$BLOCKNAME
done

mv ./$BLOCKNAME /etc/nginx/sites-available/;

ln -s /etc/nginx/sites-available/$BLOCKNAME /etc/nginx/sites-enabled/;

systemctl restart nginx;