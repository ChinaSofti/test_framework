#!/bin/sh

#  CURDIR=`pwd`
CURDIR="$( cd "$( dirname "$0"  )" && pwd  )"
BUILD_DIR=$CURDIR/build
BUILD_OUT_DIR=$BUILD_DIR/out
PRODUCTS_DIR=$BUILD_OUT_DIR/Build/Products
PROJECT_NAME=SpeedPro.xcodeproj
SCHEME_NAME=SPService
# configuration: Release , Debug
CONFIGURATION_TYPE=Debug

echo CURDIR:$CURDIR
echo BUILD_DIR:$BUILD_DIR
cd $CURDIR

# 判断build目录是否存在，如果存在，则删除该目录，保证每次编译都是一个新的目录
if [ -d $BUILD_DIR ]; then
echo delete build directory
rm -rf $BUILD_DIR

fi

# 初始化目录，包括build文件输出目录和build过程日志文件
mkdir -p $BUILD_OUT_DIR


# exec_xcodebuild函数用于执行xcodebuild编译命令。
# param1 用于设置-sdk (iphoneos9.2, iphonesimulator9.2)
# param2 用于设置 -arch (armv7, arm64, i386, x86_64)
function exec_xcodebuild() 
{
	echo xcodebuild -project $PROJECT_NAME -scheme $SCHEME_NAME  -configuration $CONFIGURATION_TYPE -sdk $1  -arch $2 -derivedDataPath ./build clean build CODE_SIGNING_ALLOWED=NO
	# 执行build
	xcodebuild -project $PROJECT_NAME -scheme $SCHEME_NAME  -configuration $CONFIGURATION_TYPE -sdk $1  -arch $2  -derivedDataPath ./build clean build CODE_SIGNING_ALLOWED=NO &> $BUILD_DIR/build.log
	status=$?
	if [ $status -gt  0 ]; then
		echo build fail. status:$status
		exit -1;
	else
		echo build success!
	fi
}

SDK_NAME=
# 执行编译真机armv7平台文件
echo -----------------------------------------------------------------------------
exec_xcodebuild iphoneos9.2 armv7;

# 拷贝编译文件到$BUILD_OUT_DIR/out目录下
cp -R  $BUILD_DIR/Build/Products/$CONFIGURATION_TYPE-iphoneos/ $BUILD_OUT_DIR/


echo -----------------------------------------------------------------------------
# 执行编译真机armv64平台文件
exec_xcodebuild iphoneos9.2 arm64;

# 合并两个不同architecture文件
lipo -create $BUILD_DIR/Build/Products/$CONFIGURATION_TYPE-iphoneos/SPService.framework/SPService $BUILD_OUT_DIR/SPService.framework/SPService -output $BUILD_OUT_DIR/SPService
lipo -create $BUILD_DIR/Build/Products/$CONFIGURATION_TYPE-iphoneos/SPCommon.framework/SPCommon $BUILD_OUT_DIR/SPCommon.framework/SPCommon -output $BUILD_OUT_DIR/SPCommon


echo -----------------------------------------------------------------------------
# 执行编译真机i386平台文件
exec_xcodebuild iphonesimulator9.2 i386;

# 合并两个不同architecture文件
lipo -create $BUILD_DIR/Build/Products/$CONFIGURATION_TYPE-iphoneos/SPService.framework/SPService $BUILD_OUT_DIR/SPService -output $BUILD_OUT_DIR/SPService2

lipo -create $BUILD_DIR/Build/Products/$CONFIGURATION_TYPE-iphoneos/SPCommon.framework/SPCommon $BUILD_OUT_DIR/SPCommon -output $BUILD_OUT_DIR/SPCommon2

rm $BUILD_OUT_DIR/SPService
rm $BUILD_OUT_DIR/SPCommon

echo -----------------------------------------------------------------------------
# 执行编译真机i386平台文件
exec_xcodebuild iphonesimulator9.2 x86_64;

# 合并两个不同architecture文件
lipo -create $BUILD_DIR/Build/Products/$CONFIGURATION_TYPE-iphoneos/SPService.framework/SPService $BUILD_OUT_DIR/SPService2 -output $BUILD_OUT_DIR/SPService

lipo -create $BUILD_DIR/Build/Products/$CONFIGURATION_TYPE-iphoneos/SPCommon.framework/SPCommon $BUILD_OUT_DIR/SPCommon2 -output $BUILD_OUT_DIR/SPCommon

rm $BUILD_OUT_DIR/SPService2
rm $BUILD_OUT_DIR/SPCommon2

mv $BUILD_OUT_DIR/SPService $BUILD_OUT_DIR/SPService.framework/
mv $BUILD_OUT_DIR/SPCommon $BUILD_OUT_DIR/SPCommon.framework/

echo --------build finish----------


