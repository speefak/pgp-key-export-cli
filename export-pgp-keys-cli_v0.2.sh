#!/bin/bash
# name          : pgp-key-export-cli
# desciption    : export installed pgp keys ( public and secret key )
# autor         : speefak ( itoss@gmx.de )
# licence       : (CC) BY-NC-SA
# version 	: 0.2
# notice 	: tested on debian 12
# infosource	: 
#		  

#------------------------------------------------------------------------------------------------------------
############################################################################################################
#######################################   define global variables   ########################################
############################################################################################################
#------------------------------------------------------------------------------------------------------------

 PGPKeyNameID=$1
 ExportDir=$HOME
 InstalledPGPKeys=$(gpg --list-keys --keyid-format SHORT | grep "<\|>" | awk '{print $NF}' | tr -d "<" | tr -d ">")

#------------------------------------------------------------------------------------------------------------
############################################################################################################
###########################################   define functions   ###########################################
############################################################################################################
#------------------------------------------------------------------------------------------------------------
pgp_key_selection () {
	# create pgp selection menu
	MenuList=$(echo -en "$(gpg --list-keys --keyid-format SHORT | grep "<\|>")" "\ncancel" | nl)
 	MenuListCount=$(grep -c . <<<$MenuList)

	# show installed PGP keys / pgp key selection
	printf " exportable PGP keys: \n\n" 
	printf "$MenuList\n\n"
	read -e -p " select number: "	-i "$MenuListCount" PGPKeySelection
	printf "\n"

	# check input selection
	if [[ $PGPKeySelection == $MenuListCount ]]; then
		printf " exit ... \n"
		exit 0
	fi 2>/dev/null

	# get selected string 
	SelectedPGPKey=$(echo "$MenuList" | sed 's/^[[:space:]]*//' | grep "^$PGPKeySelection" | sed 's/[[:digit:]].[[:space:]]*//')

	# get pgp key name
	PGPKeyNameID=$(echo "$SelectedPGPKey" | awk '{print $NF}' | tr -d "<" | tr -d ">")
	
	# check for valid PGP key name
	if   [[ -z $PGPKeyNameID ]]; then
		pgp_key_selection
	fi
}
#------------------------------------------------------------------------------------------------------------
############################################################################################################
#############################################   start script   #############################################
############################################################################################################
#------------------------------------------------------------------------------------------------------------

	if [[ -z $PGPKeyNameID ]]; then
		pgp_key_selection 
	fi

#------------------------------------------------------------------------------------------------------------

	# check for installed/valid pgp key 
	if [[ -z $(echo $InstalledPGPKeys | grep $PGPKeyNameID ) ]]; then
		printf "\n"
		printf " PGP key not found: $PGPKeyNameID \n\n"
		pgp_key_selection 
	fi

#------------------------------------------------------------------------------------------------------------

	## create name/ID folder
	SaveDir=$(pwd)
	cd $ExportDir
	mkdir -p $PGPKeyNameID
	cd $PGPKeyNameID

#------------------------------------------------------------------------------------------------------------

	# export public key
	gpg -a --export $PGPKeyNameID | tee  ${PGPKeyNameID}_-_gpg-public.key.gpg &>/dev/null

#------------------------------------------------------------------------------------------------------------

	# export secret key
	gpg -a --output gpg-secret-key.asc --export-secret-keys $PGPKeyNameID
	mv gpg-secret-key.asc ${PGPKeyNameID}_-_gpg-secret-key.gpg

#------------------------------------------------------------------------------------------------------------

	# show created files
	printf "\n"
	printf "PGP keys stored in : $(pwd)\n"
	printf "PGP public key     : $(pwd)/$(ls | grep public)\n"
	printf "PGP secret key     : $(pwd)/$(ls | grep secret)\n"
	printf "\n"

#------------------------------------------------------------------------------------------------------------

	cd $SaveDir &> /dev/null

#------------------------------------------------------------------------------------------------------------

	exit 0

























#!/bin/bash
# name          : pgp-key-export-cli
# desciption    : export installed pgp keys ( public and secret key )
# autor         : speefak ( itoss@gmx.de )
# licence       : (CC) BY-NC-SA
# version 	: 0.2
# notice 	: written for debian 12
# infosource	: 
#		  

#------------------------------------------------------------------------------------------------------------
############################################################################################################
#######################################   define global variables   ########################################
############################################################################################################
#------------------------------------------------------------------------------------------------------------

 PGPKeyNameID=$1
 InstalledPGPKeys=$(gpg --list-keys --keyid-format SHORT | grep "<\|>" | awk '{print $NF}' | tr -d "<" | tr -d ">")

#------------------------------------------------------------------------------------------------------------
############################################################################################################
###########################################   define functions   ###########################################
############################################################################################################
#------------------------------------------------------------------------------------------------------------
pgp_key_selection () {
	# show installed PGP keys

	# create pgp selection menu
	MenuList=$(echo -en "$(gpg --list-keys --keyid-format SHORT | grep "<\|>")" "\ncancel" | nl)
 	MenuListCount=$(grep -c . <<<$MenuList)

	# pgp key selection
	printf " exportable PGP keys: \n\n" 
	printf "$MenuList\n\n"
	read -e -p " select number: "	-i "$MenuListCount" 		PGPKeySelection
	printf "\n"

	# check input selection
	if   [[ $PGPKeySelection -gt $MenuListCount ]] || [[ $PGPKeySelection == 0 ]]; then
		pgp_key_selection		
	elif [[ $PGPKeySelection == $MenuListCount ]]; then
		printf " exit ... \n"
		exit 0
	fi 2>/dev/null

	# get selected string 
	SelectedPGPKey=$(echo "$MenuList" | sed 's/^[[:space:]]*//' | grep "^$PGPKeySelection" &> /dev/null | sed 's/[[:digit:]].[[:space:]]*//')

	# get pgp key name
	PGPKeyNameID=$(echo "$SelectedPGPKey" | awk '{print $NF}' | tr -d "<" | tr -d ">")

	# check for valid PGP key name
	if   [[ -z $PGPKeyNameID ]]; then
		pgp_key_selection
	fi

