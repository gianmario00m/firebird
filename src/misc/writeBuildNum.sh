#!/bin/sh

# This file is used both to rebuild the header file and to set the 
# environment variables on the config call

BuildVersion="$Id: writeBuildNum.sh,v 1.5361 2003-10-27 22:27:29 skidder Exp $"

BuildType=T
MajorVer=2
MinorVer=0
RevNo=0
BuildNum=5361
BuildSuffix="Firebird 2.0 UNSTABLE"
FIREBIRD_PACKAGE_VERSION=0.Unstable

FIREBIRD_VERSION="$MajorVer.$MinorVer.$RevNo"
PRODUCT_VER_STRING="$MajorVer.$MinorVer.$RevNo.$BuildNum"
FILE_VER_STRING="WI-$BuildType$MajorVer.$MinorVer.$RevNo.$BuildNum"
FILE_VER_NUMBER="$MajorVer, $MinorVer, $RevNo, $BuildNum"

if [ $# -eq 3  ] 
then
 headerFile=$2
 tempfile=$3;
else
 tempfile=gen/test.header.txt
 headerFile=src/jrd/build_no.h;
fi

#______________________________________________________________________________
# Routine to build a new jrd/build_no.h file. If required.

rebuildHeaderFile() {

cat > $tempfile <<eof
/*
  FILE GENERATED BY src/misc/writeBuildNum.sh 
               *** DO NOT EDIT ***
  TO CHANGE ANY INFORMATION IN HERE PLEASE
  EDIT src/misc/writeBuildNum.sh
  FORMAL BUILD NUMBER:$BuildNum 
*/

#define PRODUCT_VER_STRING "$PRODUCT_VER_STRING"
#define FILE_VER_STRING "$FILE_VER_STRING"
#define LICENSE_VER_STRING "$FILE_VER_STRING"
#define FILE_VER_NUMBER $FILE_VER_NUMBER
#define FB_MAJOR_VER "$MajorVer"
#define FB_MINOR_VER "$MinorVer"
#define FB_REV_NO "$RevNo"
#define FB_BUILD_NO "$BuildNum"
#define FB_BUILD_TYPE "$BuildType"
#define FB_BUILD_SUFFIX "$BuildSuffix"
eof

    cmp -s $headerFile $tempfile
    Result=$?
    if [ $Result -lt 0 ]
       then
         echo "error compareing $tempfile and $headerFile"
    elif [ $Result -gt 0 ]
      then
      echo "updating header file $headerFile"
      cp $tempfile $headerFile
    else
      echo "files are identical"
    fi
}

#______________________________________________________________________________
# Routine to build a new gen/make.version file.

createMakeVersion() {

cat >$1 <<eof
#  FILE GENERATED BY src/misc/writeBuildNum.sh 
#               *** DO NOT EDIT ***
#  TO CHANGE ANY INFORMATION IN HERE PLEASE
#  EDIT src/misc/writeBuildNum.sh
#  FORMAL BUILD NUMBER:$BuildNum 

MajorVer = $MajorVer
MinorVer = $MinorVer
RevNo = $RevNo
BuildNum=5361
BuildType = $BuildType
BuildSuffix = $BuildSuffix

PackageVersion=$FIREBIRD_PACKAGE_VERSION
FirebirdVersion=$FIREBIRD_VERSION
eof

}

if [ "$1" = "rebuildHeader" ]
  then
    rebuildHeaderFile
elif [ "$1" = "createMakeVersion" ]
  then
   if [ -z "$2" ]
     then createMakeVersion gen/Make.Version
     else createMakeVersion "$2"
   fi
elif [ "$1" = "--version" ]
  then
    echo ""
    echo "Build Version : " $BuildType$PRODUCT_VER_STRING $BuildSuffix
    echo ""
    #echo "($BuildVersion)"
    echo "(`echo $BuildVersion | cut -c3-60` )"
fi
