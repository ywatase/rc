#!/bin/sh

# config
BACKUP_PRESERVE_DAYS=7


check_args () {
	TARGET=$1
	if [ "$TARGET" = "" ] ; then
		echo "set target directory"
		exit;
	fi
}

initialize () {
	DIRNAME=$(dirname $TARGET)
	BASENAME=$(basename $TARGET)
	ARCHIVE_DIR=$DIRNAME/archive
	PREVIOUS_BACKUP_FILE=${ARCHIVE_DIR}/previous
	if [ -f $PREVIOUS_BACKUP_FILE ] ; then
		PREVIOUS_BACKUP_NAME=$(cat $PREVIOUS_BACKUP_FILE)
		PREVIOUS_BACKUP_DIR=${ARCHIVE_DIR}/${PREVIOUS_BACKUP_NAME}
	fi
	NEW_BACKUP_NAME=${BASENAME}.$(date +%Y%m%d%H%M)
	NEW_BACKUP_DIR=${ARCHIVE_DIR}/${NEW_BACKUP_NAME}
	TIMESTAMP_FILE=____TIMESTAMP____
}


check_args "$@"
initialize

if ! [ -d $ARCHIVE_DIR ] ; then
	mkdir $ARCHIVE_DIR
fi

if [ "$PREVIOUS_BACKUP_DIR" != "" ] && [ -d "$PREVIOUS_BACKUP_DIR" ] ; then
	rsync -a --delete --link-dest=../$PREVIOUS_BACKUP_NAME $TARGET $NEW_BACKUP_DIR
else
	rsync -a --delete $TARGET $NEW_BACKUP_DIR
fi
echo -n $NEW_BACKUP_NAME > $PREVIOUS_BACKUP_FILE
touch $NEW_BACKUP_DIR/$TIMESTAMP_FILE
for RM_TARGET in $(find $ARCHIVE_DIR/$BASENAME.???????????? -maxdepth 1 -type f -name $TIMESTAMP_FILE -ctime +$BACKUP_PRESERVE_DAYS)
do
	RM_DIR=$(dirname $RM_TARGET)
	mkdir $ARCHIVE_DIR/trash
	mv $RM_DIR $ARCHIVE_DIR/trash
	rm -rf $ARCHIVE_DIR/trash
done
