#!/bin/sh

BACKUP_PRESERVE_DAYS=7
TARGET=$1
if [ "$TARGET" = "" ] ; then
    echo "set target directory"
    exit;
fi
DIRNAME=$(dirname $TARGET)
BASENAME=$(basename $TARGET)
ARCHIVE_DIR=$DIRNAME/archive
PREVIOUS_BACKUP=${BASENAME}.$(perl -e 'use POSIX;@d = localtime; $d[3]-=1;print POSIX::strftime(q{%Y%m%d%H%M},@d)')
TODAY_BACKUP=$DIRNAME/archive/${BASENAME}.$(date +%Y%m%d)

TIMESTAMP_FILE=____TIMESTAMP____

if ! [ -d $ARCHIVE_DIR ] ; then
	mkdir $ARCHIVE_DIR
fi

if [ -d $ARCHIVE_DIR/$PREVIOUS_BACKUP ] ; then
	rsync -a --delete --link-dest=../$PREVIOUS_BACKUP $TARGET $TODAY_BACKUP
else
	rsync -a --delete $TARGET $TODAY_BACKUP
fi
touch $TODAY_BACKUP/$TIMESTAMP_FILE
for RM_TARGET in $(find $ARCHIVE_DIR/$BASENAME.???????????? -maxdepth 1 -type f -name $TIMESTAMP_FILE -ctime +$BACKUP_PRESERVE_DAYS)
do
	RM_DIR=$(dirname $RM_TARGET)
	mkdir $ARCHIVE_DIR/trash
	mv $RM_DIR $ARCHIVE_DIR/trash
	rm -rf $ARCHIVE_DIR/trash
done
