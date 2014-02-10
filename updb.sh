#!/bin/bash

DATABASE_DIR=`pwd`
AGRONET_DIR="/www/agronet"

if [ ! -f $DATABASE_DIR/history.txt ];then
  echo "There should exist an history.txt file."
  exit 1;
fi

tmpdb() {
  if [ ! -d $AGRONET_DIR ];then
    echo "$AGRONET_DIR is not a directory"
    exit 1;
  fi
  
  cd $AGRONET_DIR
  if [ ! -d ./tmp ];then
    mkdir tmp
  fi
  
  drush sql-dump --result-file=$AGRONET_DIR/tmp/agronet-db.sql 1>/dev/null
  tar -czvf $AGRONET_DIR/tmp/agronet-db.sql.tar $AGRONET_DIR/tmp/agronet-db.sql 1>/dev/null
  res=$?
  
  if [ $res -ne 0 ];then
    echo "error creating database dump"
    exit 1;
  fi
  cp $AGRONET_DIR/tmp/agronet-db.sql.tar $DATABASE_DIR
  cp $AGRONET_DIR/tmp/agronet-db.sql $DATABASE_DIR/sql
  res=$?
  
  cd $DATABASE_DIR
  
  if [ $res -eq 0 ];then
    # updating database-update history
    echo `date` >> $DATABASE_DIR/history.txt 
  else
    echo "unexpected error: permissions (?)"
    exit 1;
  fi
  echo "done."
}

echo "Saving database..."
tmpdb
exit 0;


