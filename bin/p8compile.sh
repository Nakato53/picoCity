filename="$1"
start="$2"

#check extensions
if [[ "$filename" != *.p8 ]]
then
  filename="$filename.p8"
fi

if [ ! -d "./bin" ]; then
	mkdir "bin"
fi

binfilename="./bin/$filename"

#create p8 file if not exist
if [ ! -f $filename ] && [ ! -f $binfilename ]; then
	echo "pico-8 cartridge // http://www.pico-8.com" >> $binfilename
	echo "version 16" >> $binfilename
	echo "__lua__" >> $binfilename
	echo "function _init()" >> $binfilename
	echo "end" >> $binfilename
	echo "function _update()" >> $binfilename
	echo "end" >> $binfilename
	echo "function _draw()" >> $binfilename
	echo "	cls()" >> $binfilename
	string="Hello $filename"
	echo "	print('$string',40,55,12)" >> $binfilename
	echo "end" >> $binfilename
	echo "__gfx__" >> $binfilename
	echo "__sfx__" >> $binfilename
fi

if [ -f $filename ]; then
	mv $filename $binfilename
fi

# if new project
if [ ! -f "p8.project" ]; then
	# create project file with pico8 path
	echo PATH of Pico-8 bin ?
	read -e path
	echo "PICO_BIN=\"$path\"" >> p8.project
	echo Name of the game ?
	read name
	echo "NAME=\"$name\"" >> p8.project
	echo Your author name ?
	read author
	echo "AUTHOR=\"$author\"" >> p8.project

	# extract code to main.lua
	echo " " >> 'main.lua'
	step=0
	while IFS= read line
	do
		if [ "$line" == "__gfx__" ]; then
			step=2
		fi
		if [ "$line" == "__sfx__" ]; then
			step=2
		fi
		if [ $step == 1 ]; then
	    	echo $line >> 'main.lua'
		fi
		if [ "$line" == "__lua__" ]; then
			step=1
		fi
	done < "$binfilename"
fi
echo $line >> 'main.lua'

#load project file
. p8.project

#extract pico8 code other than lua
step="0"
while IFS= read line
do
	if [ "$line" == "__gfx__" ]; then
		step="2"
	fi
	if [ "$line" == "__sfx__" ]; then
		step="2"
	fi
	if [ "$step" == "0" ]; then
    	echo $line >> 'precode.txt'
	fi
	if [ "$step" == "2" ]; then
		echo $line >> 'postcode.txt'
	fi
	if [ "$line" == "__lua__" ]; then
		step="1"
	fi
done < "$binfilename"
echo $line >> 'postcode.txt'

#inject pico8 header
if [ -f precode.txt ]; then
cat precode.txt >> fullcode.txt 
rm precode.txt
fi

#inject game info
echo "-- $NAME" >> fullcode.txt
echo "-- by $AUTHOR" >> fullcode.txt

#inject game code
##fullcode=$(find . -name '*.lua' -exec cat {} >> fullcode.txt \;)
##echo "\n" >> fullcode.txt

for file in $(find . -name '*.lua'); do 
	echo "-- $file" >> fullcode.txt
	while IFS= read line
	do
		echo $line >> fullcode.txt
	done < "$file"
	echo $line >> fullcode.txt
done


#inject assets
if [ -f postcode.txt ]; then
	cat postcode.txt >> fullcode.txt
	rm postcode.txt
fi

cp fullcode.txt $binfilename
rm fullcode.txt

GREEN='\033[1;32m'
NC='\033[0m' # No Color
printf "\n\n${GREEN}P8COMPILE : DONE !${NC}\n\n"

if [ "$start" == "start" ]; then
	$PICO_BIN -run $binfilename -windowed 1 -root_path .
fi
