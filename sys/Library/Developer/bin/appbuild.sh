#!/bin/bash

export builderversion="12.0.0"

if [[ -z "$1" ]]; then
	echo "Error: Missing argument (1)"
	exit
elif [[ ! -d "$USERDATA/$1" ]]; then
	echo "Error: Missing project file"
	exit
elif [[ ! -f "$USERDATA/$1/code/main" ]]; then
	echo "Error: File \"code/main\" not found."
	exit
elif [[ ! -f "$USERDATA/$1/INFO" ]]; then
	echo "Error: File \"INFO\" not found."
	exit
fi

source "$USERDATA/$1/INFO"

if [[ -z "$APPNAME" ]]; then
	echo "Build Failed: Missing information - INFO:APPNAME is empty." # Name
	exit
elif [[ -z "$APPVERSION" ]]; then
	echo "Build Failed: Missing information - INFO:APPVERSION is empty." # Version
	exit
elif [[ -z "$APPBUILD" ]]; then
	echo "Build Failed: Missing information - INFO:APPBUILD is empty." # Build Number
	exit
elif [[ -z "$FRAMEWORKS" ]]; then
	echo "Build Failed: Missing information - INFO:FRAMEWORKS is empty." # Required Frameworks
	exit
elif [[ -z "$ALLOCTHREAD" ]]; then
	echo "Build Failed: Missing information - INFO:ALLOCTHREAD is empty." # Background application / User application
	exit
fi

echo "Building: $APPNAME"

if [[ -d "$USERDATA/$1/build" ]]; then
	rm -rf "$USERDATA/$1/build"
fi

while read requiredFramework; do
	if [[ ! -e "$LIBRARY/Developer/Frameworks/$requiredFramework.hfw" ]]; then
		echo "Build Failed: $requiredFramework - No such framework found."
		exit
	fi
done <<< "$(echo "$FRAMEWORKS")"

mkdir -p "$USERDATA/$1/build"
mkdir -p "$USERDATA/$1/build/frameworks"
echo "$FRAMEWORKS" | while read requiredFramework; do
	if [[ -f "$LIBRARY/Developer/Frameworks/$requiredFramework.hfw" ]]; then
		echo "Adding $requiredFramework to package..."
		cp "$LIBRARY/Developer/Frameworks/$requiredFramework.hfw" "$USERDATA/$1/build/frameworks/"
	fi
done

echo "Copying other codes..."
cp -r "$USERDATA/$1/code" "$USERDATA/$1/build/"
echo "Copying info data..."
cp "$USERDATA/$1/INFO" "$USERDATA/$1/build/"
echo "Making runner file..."

export RUNNERDATA="source \$(dirname \"\$0\")/INFO
while read framework
do
	source \"\$(dirname \"\$0\")/frameworks/\$framework.hfw\"
done <<< \"\$(echo \"$FRAMEWORKS\")\"
\"\$(dirname \"\$0\")/code/main\" \"\$1\" \"\$2\" \"\$3\" \"\$4\" \"\$5\" \"\$6\" \"\$7\" \"\$8\" \"\$9\"
"
echo "$RUNNERDATA" >> "$USERDATA/$1/build/runner"
echo "Writing additional data..."
if [[ "$2" == "--nosdkv" ]]; then
	echo "export BUILTFOR=\"$SDK_COMPATIBILITY\"" >> "$USERDATA/$1/build/INFO"
else
	echo "export BUILTFOR=\"all\"" >> "$USERDATA/$1/build/INFO"
fi
echo "export BUILDER=\"$builderversion\"" >> "$USERDATA/$1/build/INFO"
echo "Setting files runnable..."
chmod +x "$USERDATA/$1/build/runner"
find "$USERDATA/$1/build/code" -exec chmod +x {} \;
echo "Packaging..."
cd "$USERDATA/$1/build"
zip -rq "build.zip" . -x ".*" -x "__MACOSX"
mv "build.zip" "../$APPNAME.hxa"
rm -rf "build"
echo "Build successful."