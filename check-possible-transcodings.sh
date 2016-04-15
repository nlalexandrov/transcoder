# udpsrc and udpdst (mandatory)
echo -e "\nRTP check :"
if (gst-inspect | grep -q " udpsrc:")
then 
	echo "	udpsrc found"
else
	echo "	udpsrc not found, exiting - please check gstreamer installation"
	exit
fi

if (gst-inspect | grep -q " udpsink:")
then
        echo "	udpsink found"
else
        echo "	udpsink not found, exiting - please check gstreamer installation"
        exit
fi

echo -e "\nCodecs check :"


while read codec
do
	result="supported"
	error=""

	if [ ! -e "codecs-conf/$codec.cfg" ]
	then
		result="not supported"
		error="missing codecs-conf/$codec.cfg file"
		echo "  $codec	$result $error"
		continue
	else
	        # remove empty lines
	        cat codecs-conf/$codec.cfg | tr -s "\n" > tmpfile
		mv tmpfile codecs-conf/$codec.cfg
 
		check=`cat codecs-conf/$codec.cfg | wc -l`
		if [ $check -ne "4" ]
		then
			result="not supported"
			error="wrong or incorrectly formated codecs-conf/$codec.cfg file"
			echo "  $codec	$result $error"
	                continue
		fi
	fi

	while read cap
	do
		if ( ! gst-inspect | grep -q " $cap:")
		then
			result="not supported"
			error=$cap
		fi
		
	done < codecs-conf/$codec.cfg
	echo "  $codec	$result $error"

done < codecs-conf/codec.lst


