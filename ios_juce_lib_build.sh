# returns immediately if any command returns error
set -e

target="juce_lib - Static Library"
libname="juce_lib"
flutter_wrapper_package="juce_mix_player_package"
flutter_app="flutter_app"

root_dir=`pwd`

# generate dart files from native header
cd "$flutter_wrapper_package"
flutter pub get
dart run ffigen

cd "$root_dir"
cd "$libname/Builds/iOS" &&

# clear previous files
rm -rf "build/${libname}.xcframework"
rm -rf "build/Release-iphoneos"
rm -rf "build/Release-iphonesimulator"

# build for iphones
xcodebuild -target "${target}" -configuration Release -sdk iphoneos only_active_arch=no build LLVM_LTO=NO &&

mkdir build/Release-iphoneos &&
cp "build/Release/lib${libname}.a" "build/Release-iphoneos/${libname}.a" &&

# build for simulaotrs
xcodebuild -target "${target}" -configuration Release -sdk iphonesimulator only_active_arch=no LLVM_LTO=NO &&

mkdir build/Release-iphonesimulator &&
cp "build/Release/lib${libname}.a" "build/Release-iphonesimulator/${libname}.a" &&

# create xcframework, with native headers
xcodebuild -create-xcframework \
    -library "build/Release-iphoneos/${libname}.a" -headers ../../../$libname/includes \
    -library "build/Release-iphonesimulator/${libname}.a" -headers ../../../$libname/includes \
    -output "build/${libname}.xcframework" &&

echo "✅ Build Success ✅"

cd "$root_dir"

# copy framework to flutter_app project

if [ -d "$flutter_app/ios/Runner/" ]; then
    rm -rf "$flutter_app/ios/Runner/$libname.xcframework"

    cp -r \
    "$libname/Builds/iOS/build/$libname.xcframework" \
    "$flutter_app/ios/Runner/$libname.xcframework" &&

    echo "✅ Copy to project Success ✅"
fi