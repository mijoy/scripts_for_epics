#!/bin/bash
# Shell  : epics_default_installation.sh
# Author : Jeong Han Lee
# email  : jhlee@ibs.re.kr
# Date   : Monday, August 25 21:01:19 KST 2014
# version : 0.1.2
#
#   * I intend to develop this script in order to reduce the painful
#     copy and paste from EPICS and its extensions installation logs
#     from everywhere. So only for Linux 64bit Debian for PC and 
#     Rasberian for Raspberry Pi, this script works well.
#     Anyway, it will reduce significantly my time for just installing
#     EPICS and its extenstions.
# 
#
#   * Must install the following packages via root or sudo
#     before running this script
#
#     For Debian Wheezy,
# 
#     aptitude install libreadline-dev  g++ libxt-dev lesstif2-dev x11proto-print-dev libxmu-headers libxp-dev libxmu-dev libxmu6  libxpm-dev libxmuu-dev libxmuu1 libxmu6 
#
#   * EPICS Base and extensionTop
#   * Extensions List
#     - StripTool2_5_16_0 
#     - alh1_2_34 
#     - medm3_1_9 
#     - probe1_1_8_0 
#     - msi1-6 
#     - cau_20130110 
#     - dbVerbose_20130124 
#     - gnuregex0_13 
#     - nameserver2_0_0_12
#     - gateway2_0_4_0
#
#
#
#  - 0.0.1  Tue, December 31 16:20:15 KST 2013, jhlee
#           * created
#
#  - 0.0.2  Wed, January   1 02:45    KST 2013, jhlee
#           * make thisepicsall.sh file to provide 
#             users to set EPICS environments easily
#
#  - 0.0.3 Wednesday, January  1 19:26:03 KST 2014, jhlee
#          * refine, .... 
#
#  - 0.1.0 Monday, August 25 21:01:45 KST 2014, jhlee
#          * Re-design in order to follow RAON EPICS directory
#            structure as follows:
#            ${HOME}/epics/R3.14.12.4/{base,extensions,siteLibs,siteApps}
#
#  - 0.1.1 Tuesday, August 26 01:37:35 KST 2014, jhlee
#          * make the output script (setEpicsEnv) works...
#          * change current_epics_base and current_epics_extensions as global 
#            variable
#  
#  - 0.1.2 Tuesday, August 26 13:24:00 KST 2014, jhlee
#          * add the VisualDCT in EPICS_EXTENSIONS
#          * add the gateway into EPICS_EXTENSIONS
#          * introduce make_command in order to minimize any compiling errors
#            on R.Pi and increase the compiling speed on typical Linux hosts
#
# cq   : quiet 
# c    : verbose
wget_options="wget -c"
# xzf  : quiet
# xzfv : verbose
tar_command="tar xzf"
#nproc_command="nproc -all"

this_script_version="0.1.2"
this_script_name=`basename $0`
LOGDATE=`date +%Y.%m.%d.%H:%M`
host_name=${HOSTNAME}
user_name=${USERNAME}

epics_download_site="http://www.aps.anl.gov/epics/download/"
output_filename="setEpicsEnv"
current_epics_base=""
current_epics_extensions=""
default_version="3.14.12.4"
make_command_base=""
make_command_extn=""
vdct_status=""

print_env()
{
    echo -e "#!/bin/bash" 
    echo -e "# Shell  : ${output_filename}.sh"  
    echo -e "# Author : Jeong Han Lee"    
    echo -e "# email  : jhlee@ibs.re.kr"  
    echo -e "# Generated at  $LOGDATE"    
    echo -e "#           on  $host_name"  
    echo -e "#           by  $user_name" 
    echo -e "# version : ${this_script_version}"  
    echo -e "" 
    echo -e "#   * This script is genenated by $this_script_name automatically." 
    echo -e "#     In order to setup EPICS base and its extentions correctly," 
    echo -e "#     please run the following command:"
    echo -e "#     . ${EPICS}/setEpicsEnv.sh "
    echo -e "" 
    echo -e "" 
    echo -e "export EPICS_HOST_ARCH=${EPICS_HOST_ARCH}" 
    echo -e "export EPICS_BASE=${current_epics_base}" 
    echo -e "export EPICS_EXTENSIONS=${current_epics_extensions}" 
    echo -e "export PATH=${PATH}" 
    echo -e "export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" 
    echo -e "" 
}


make_ext()
{
    extn_name=$1
    extn_filename=${extn_name}.tar.gz 
    cd ${EPICS}/downloads
    $wget_options ${epics_download_site}/extensions/${extn_filename} 
    $tar_command ${extn_filename} -C ${current_epics_extensions}/src
    cd ${current_epics_extensions}/src/${extn_name}
    make clean
    ${make_command_extn}

}   


# make_vdct doens't have any real make, so
# it must be done after an installation of an extensions
# Tuesday, August 26 11:04:27 KST 2014, jhlee
#
make_vdct()
{
    vdct_target=${current_epics_extensions}/src/VisualDCT
    mkdir -p ${vdct_target}

    vdct_version="2.6.1274"
    vdct_filename=VisualDCT-dist-${vdct_version}.zip
    cd ${EPICS}/downloads
    $wget_options http://visualdct.cosylab.com/builds/VisualDCT/${vdct_version}/${vdct_filename}

    #
    # Force (-o option) to overwrite when the target files are in the target directory,
    # so it will prevent the duplicated entries in the below sed procedure.
    #
    unzip -oq -d ${vdct_target} ${vdct_filename}

    vdct_home=${vdct_target}/${vdct_version}
    run_script=${vdct_home}/runScript
    vdct_bin=${current_epics_extensions}/bin/${EPICS_HOST_ARCH}/vdct

    vdct_jar_name=VisualDCT.jar
    #
    # fix the path for VisualDCT.jar location in runScript
    # in order to run it globally.
    #
    sed -i "s|${vdct_jar_name}|${vdct_home}/${vdct_jar_name}|g" ${run_script}
    #
    # add the execute permission for runScript
    #
    chmod +x ${run_script}
    #
    # force to make a symbolic link for vdct in EPICS_EXTENSIONS/bin
    #
    ln -sf ${run_script} ${vdct_bin}
}

make_setEpicsEnv()
{
    output=$1
    
    print_env >> $output

#
# Somehow, I want to put "printer" for EPICS enviroment
# in the output script. So far there is no solution where
# "variable" and "variable name" exist in a script
#
# Tuesday, August 26 01:24:15 KST 2014, jhlee
#  
#
#     cat > $output <<End-of-message
# echo EPICS_HOST_ARCH  : "${EPICS_HOST_ARCH}"
# echo EPICS_BASE       : "${EPICS_BASE}"
# echo EPICS_EXTENSIONS : "${EPICS_EXTENSIONS}"
# echo PATH             : "${PATH}"
# echo LD_LIBRARY_PATH  : "${LD_LIBRARY_PATH}"
# End-of-message

    chmod +x $output

    echo ""
    echo "The following command shall setup the EPICS enviroments on your $HOSTNAME."
    echo ". $output"
    echo ""

}

#
#  The drop_from_path was copied from thisepics.all script, to set up the ROOT build
#  , located in ${ROOTSYS}/bin/
#  Monday, August 25 20:49:41 KST 2014, jhlee


drop_from_path()
{
   # Assert that we got enough arguments
   if test $# -ne 2 ; then
      echo "drop_from_path: needs 2 arguments"
      return 1
   fi

   p=$1
   drop=$2

   newpath=`echo $p | sed -e "s;:${drop}:;:;g" \
                          -e "s;:${drop};;g"   \
                          -e "s;${drop}:;;g"   \
                          -e "s;${drop};;g"`
}


print_export()
{
    if test $# -ne 1 ; then
	echo "print_export: needs 1 arguments"
	return 1
    fi

    explain=$1


    echo ""
    echo " >> ${explain} "
    echo " >> EPICS_BASE       : " $EPICS_BASE
    echo " >> EPICS_EXTENSIONS : " $EPICS_EXTENSIONS
    echo " >> PATH             : " $PATH
    echo " >> LD_LIBRARY_PATH  : " $LD_LIBRARY_PATH
    echo ""
}



#
# For example,
# bash scripts_for_epics/epics_default_installation.sh  R3.14.12.2
#

base_version=$1

if [ -z "${base_version}" ]; then
    base_version=${default_version}
fi

base_filename="baseR${base_version}.tar.gz"

# echo $base_version
# echo $base_filename

target_dir=${HOME}

EPICS=${target_dir}/epics/R${base_version}

# Move the target directory ${HOME}
cd ${target_dir}

mkdir -p ${EPICS}/downloads

cd ${EPICS}/downloads

echo "${epics_download_site}/base/${base_filename}"

$wget_options ${epics_download_site}/base/${base_filename} 

$tar_command ${base_filename}  --transform 's/base-'${base_version}'/base/' -C ${EPICS}


# copy the following code from vlinac shell scripts
# 
#  2013.12.31 jhlee
# 
# touch i386 lib_arch, and uname option
# Monday, August 25 20:12:38 KST 2014, jhlee
#

case `uname -sm` in
    "Linux i386" | "Linux i486" | "Linux i586" | "Linux i686")
        EPICS_HOST_ARCH=linux-x86
	EXTN_LIB_ARCH=i386-linux-gnu
	make_command_base="make -j"
	make_command_extn="make"
	vdct_status=1
        ;;
    "Linux x86_64")
        EPICS_HOST_ARCH=linux-x86_64
	EXTN_LIB_ARCH=x86_64-linux-gnu
	make_command_base="make -j"
	make_command_extn="make"
	vdct_status=1
        ;;
    "Linux armv6l")
	EPICS_HOST_ARCH=linux-arm
	EXTN_LIB_ARCH=arm-linux-gnueabihf
	# 
	# There are missing header files when make -j is used on 
	# Raspberry Pi 
	# Tuesday, August 26 14:44:43 KST 2014, jhlee
	# 
	make_command_base="make"
	make_command_extn="make"
	vdct_status=0
	;;
    *)
        echo "This script  doesn't support this architecture : `uname -sm`"
        exit 1
        ;;
esac

# #
# # export EPICS enviromental settings for compiling...
# #
export EPICS_HOST_ARCH

current_epics_base=${EPICS}/base

cd ${current_epics_base}
make clean uninstall
${make_command_base}


if [ -n "${EPICS_BASE}" ] ; then
    old_epics_base=${EPICS_BASE}
fi


if [ -n "${old_epics_base}" ] ; then
    if [ -n "${PATH}" ]; then
	drop_from_path $PATH ${old_epics_base}/bin/${EPICS_HOST_ARCH}
	PATH=$newpath
    fi
    if [ -n "${LD_LIBRARY_PATH}" ]; then
	drop_from_path $LD_LIBRARY_PATH ${old_epics_base}/lib/${EPICS_HOST_ARCH}
	LD_LIBRARY_PATH=$newpath
    fi
 fi


if [ -z "${PATH}" ]; then
    PATH=${current_epics_base}/bin/${EPICS_HOST_ARCH}; 
else
    PATH=${current_epics_base}/bin/${EPICS_HOST_ARCH}:$PATH; 
fi


if [ -z "${LD_LIBRARY_PATH}" ]; then
    LD_LIBRARY_PATH=${current_epics_base}/lib/${EPICS_HOST_ARCH}; 
else
    LD_LIBRARY_PATH=${current_epics_base}/lib/${EPICS_HOST_ARCH}:$LD_LIBRARY_PATH;
fi



extn_version="20120904"
extn_filename="extensionsTop_${extn_version}.tar.gz"

cd ${EPICS}/downloads
$wget_options ${epics_download_site}/extensions/${extn_filename}
$tar_command ${extn_filename} -C ${EPICS}

current_epics_extensions=${EPICS}/extensions
export current_epics_extension


##CONFIG_SITE.linux-x86_64.linux-x86_64 file in extensions/configure/os 
## modify 

##
## create  "${EPICS_EXTENSIONS}/configure/RELEASE"
## if the file exists, remove it to name_old, then create one for
## EPICS_BASE and EPICS_EXTENSIONS
## 

extn_release="${current_epics_extensions}/configure/RELEASE"

if [ -f $extn_release ]; then
    mv ${extn_release} ${extn_release}_original
#     sed -e 's/..\/base/..\/'${base_raw_dirname}'/g'  ${extn_release}_old > ${extn_release}
fi

touch ${extn_release}
echo -e 'EPICS_BASE=$(TOP)/../base' >> $extn_release
echo -e 'EPICS_EXTENSIONS=$(TOP)' >> $extn_release



##
## create  configure/os/CONFIG_SITE.${EPICS_HOST_ARCH}.${EPICS_HOST_ARCH}
## if the file exists, remove it to name_old, then create one according to its EXTN_LIB_ARCH
## 

extn_conf_os="${current_epics_extensions}/configure/os/CONFIG_SITE.${EPICS_HOST_ARCH}.${EPICS_HOST_ARCH}"

if [ -f $extn_conf_os ]; then
    mv ${extn_conf_os} ${extn_conf_os}_original
#     sed -e 's/\/usr\/lib64/\/usr\/lib\/'${EXTN_LIB_ARCH}'/g'  ${extn_conf_os}_old > ${extn_conf_os}
fi

touch ${extn_conf_os}
echo -e '-include $(TOP)/configure/os/CONFIG_SITE.linux-x86.linux-x86' >> $extn_conf_os
echo "X11_LIB=/usr/lib/${EXTN_LIB_ARCH}" >>$extn_conf_os
echo "X11_INC=/usr/include" >>$extn_conf_os
echo "MOTIF_LIB=/usr/lib/${EXTN_LIB_ARCH}" >>$extn_conf_os
echo "MOTIF_INC=/usr/include" >> $extn_conf_os
echo "JAVA_DIR=/usr" >>$extn_conf_os
echo "SCIPLOT=YES" >>$extn_conf_os
#
# I don't understand why the following two lines are necessary
# in order to compile medm correctly on linux-x86_64
# jhlee
#
echo "XRTGRAPH_EXTENSIONS ="  >>$extn_conf_os
echo "XRTGRAPH =" >>$extn_conf_os


#EXTN_LIST="StripTool2_5_16_0"
EXTN_LIST="StripTool2_5_16_0 alh1_2_34 medm3_1_9 probe1_1_8_0 msi1-6 cau_20130110 dbVerbose_20130124 gnuregex0_13 nameserver2_0_0_12 gateway2_0_4_0"

for d in $EXTN_LIST
do
    make_ext $d
done



#
# the following function must be after make_ext,
# because the function will use the installation directory structure
# which is made by one of any extensions packages.
# 


if [ $vdct_status ]
then
    make_vdct
fi


if [ -n "${EPICS_EXTENSIONS}" ] ; then
    old_epics_extn=${EPICS_EXTENSIONS}
fi


if [ -n "${old_epics_extn}" ] ; then
    if [ -n "${PATH}" ]; then
	drop_from_path $PATH ${old_epics_extn}/bin/${EPICS_HOST_ARCH}
	PATH=$newpath
    fi
    if [ -n "${LD_LIBRARY_PATH}" ]; then
	drop_from_path $LD_LIBRARY_PATH ${old_epics_extn}/lib/${EPICS_HOST_ARCH}
	LD_LIBRARY_PATH=$newpath
    fi
 fi


if [ -z "${PATH}" ]; then
    PATH=${current_epics_extensions}/bin/${EPICS_HOST_ARCH}; 
else
    PATH=${current_epics_extensions}/bin/${EPICS_HOST_ARCH}:$PATH; 
fi


if [ -z "${LD_LIBRARY_PATH}" ]; then
    LD_LIBRARY_PATH=${current_epics_extensions}/lib/${EPICS_HOST_ARCH}; 
else
    LD_LIBRARY_PATH=${current_epics_extensions}/lib/${EPICS_HOST_ARCH}:$LD_LIBRARY_PATH;
fi


cd ${HOME}

outputfile="${EPICS}/${output_filename}.sh"

#echo $outputfile
if [ -f $outputfile ]; then
    echo ""
    echo ""
    echo "EPICS env shell script [$outputfile] already exists"
    echo "Want to overwrite? ( Y/N ) : \c"
    read answer
    if [ "$answer" = "n" ] || [ "$answer" = "N" ]; then
	echo ""
	echo "" 
	echo ""
	echo "You might keep the old file, however, I am sure you will have some trobules."
	echo "If so, please use the following information temporarily. And it works well, "
	echo "please re-run this scipt to overwrite the old script. "
	echo " ---------------------snip snip------------------------"
	echo ""
	echo "export EPICS_HOST_ARCH=${EPICS_HOST_ARCH}"
	echo "export EPICS_BASE=${current_epics_base}"
	echo "export EPICS_EXTENSIONS=${current_epics_extensions}"
	echo "export PATH=${PATH}" 
	echo "export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}"
	echo ""
	echo " ---------------------snip snip------------------------"
	exit
    fi
    echo "The existent file is renamed with ${outputfile}_bak_${LOGDATE}"
    mv ${outputfile} ${outputfile}_bak_${LOGDATE}

    make_setEpicsEnv $outputfile

else
    make_setEpicsEnv $outputfile
fi






exit