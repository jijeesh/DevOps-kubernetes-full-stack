if [ ! -d downloads ]; then
	echo "Creating downloads folder"
    mkdir downloads
    
fi

if [ ! -f downloads/jdk-8u162-linux-x64.tar.gz ]; then
	
    curl -o downloads/jdk-8u162-linux-x64.tar.gz https://build.funtoo.org/distfiles/oracle-java/jdk-8u162-linux-x64.tar.gz
fi
    
if [ ! -f downloads/jdk-7u80-linux-x64.tar.gz ]; then
	curl -o downloads/jdk-7u80-linux-x64.tar.gz https://build.funtoo.org/distfiles/oracle-java/jdk-7u80-linux-x64.tar.gz
fi
    
if [ ! -f downloads/apache-maven-3.5.4-bin.tar.gz ]; then
	curl -o downloads/apache-maven-3.5.4-bin.tar.gz http://apache.mirror.anlx.net/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz
fi
    
