#!/bin/sh
# 放在与 .xcodeproj 文件同级目录下，生成结果在 build 目录下

# 需要编译的 scheme
scheme=$1
archive_path="archives/$scheme"

if [ -z "$scheme" ] || [ "$scheme" = "" ]; then
     echo "请填入 scheme 名称"
     exit 0
fi

echo "scheme: $scheme"
cd "$(dirname "$0")" || exit 0

xcodebuild archive \
    -scheme "$scheme" \
    -sdk iphoneos \
    -archivePath "$archive_path/ios_devices.xcarchive" \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    SKIP_INSTALL=NO

xcodebuild archive \
    -scheme "$scheme" \
    -sdk iphonesimulator \
    -configuration debug \
    -archivePath "$archive_path/ios_simulators.xcarchive" \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    SKIP_INSTALL=NO

# 优先从 archive 文件夹下读取
product_list=$(ls $archive_path/ios_devices.xcarchive/Products/Library/Frameworks)
for file_name in $product_list
do
    full_product_name=$file_name
    break
done

# 读取不到就从 showBuildSettings 读取
if [ -z "$full_product_name" ] || [ "$full_product_name" = "" ]; then
    name_dict=$(xcodebuild -showBuildSettings | grep FULL_PRODUCT_NAME)
    full_product_name=${name_dict#*= }
fi

echo "full product name: ${full_product_name}"

product_name=${full_product_name%.*}

xcodebuild -create-xcframework \
    -framework $archive_path/ios_devices.xcarchive/Products/Library/Frameworks/"$full_product_name" \
    -framework $archive_path/ios_simulators.xcarchive/Products/Library/Frameworks/"$full_product_name" \
    -output build/"$product_name".xcframework

# Create the ZIP file
zip -r -X build/"$product_name".xcframework.zip build/"$product_name".xcframework

# Calculate the checksum
swift package compute-checksum build/"$product_name".xcframework.zip

# Swift Package.swift
# targets: [
#     .binaryTarget(
#         name: "$product_name",
#         url: "https://github.com/YOUR_ORG/star-wars-kit/releases/download/1.0.0-alpha.1/$product_name.xcframework.zip",
#         checksum: "b24b18fb3c11ca154242742ad9a18c3c67d4a75cb75b3e05d7dbb82cbd367227"
#     ),
# ]

# $product_name.podspec
# s.source            = { :http => 'http://localhost:8080/$product_name.xcframework.zip' } 
# s.ios.deployment_target = '10.0'
# s.ios.vendored_frameworks = '$product_name.xcframework' # Your XCFramework
# s.dependency 'PromisesSwift', '1.2.8' # Third Party Dependency