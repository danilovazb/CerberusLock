#!/bin/bash
RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
banner="""
                           · ─ ─═[ UNKL4B ]═─ ─ ·
          ▄    ███▄    ████▄█▄         ▄█▄▄▄     █████        ▄█▄▄▄▄▄
        █ ██ ▄▄▄▄▄▄▄▄  ████ ███▄     ▄██████      ████      ▄███  ▀███▄
         ▄██   ▄▄████▀▄ ▀██ ████    ▄███▀███      ████      ▀███▀▀  ███▀
        ▀███ ░ ██████  ▀▄ █ ████  ▄████▀ ███ ░░   ██████████▄ ▀█ ▄▄█▀▀
         ███ ▒ ██████ ▀▄▄▄█ ████▄█████▀  ███▄   █▄ ▀███████▀ ▀ █▀▀  ▄
         ███ ░ ██████  ████ ███████████▄ ▀████▄▄███▄ ▀      ████  ░  ██▄
        ▄███ ▄███████  ████ ████  ███████▄ ▀█████████▄      ████▀▄▄▄███▀
         ▀█████▀ ▀███       ▀███      ███                    ▀██
                   ▀█         ▀█       ▀█                     ▀█
 

        ─ ─────────────────────────────────────────────────────────── ─
${RED}            · C · E · R · B · E · R · U · S ·    · L · O · C · K ·   ${NC}
        ── ───────────────────────────────────────────────────────── ──

                       · ─ ─═[ This shell script ]═─ ─ ·                     
              ─ ─═[ helps in creating containers with Luck ]═─ ─                    
   
                         ─ ─═[ github.com/unkl4b ]═─ ─  

"""
x="Unk"
menu ()
{
while true $x != "Unk"
    do
	clear
	printf """$banner

-> 1 ]	Create container
-> 2 ]	Mount container
-> 3 ]	Exit


"""
        echo -n "->$ "
        read x

	case "$x" in
            1)
                echo -e "\n${GREEN}[+]${NC} Enter the path with container name:\nEx:/home/USER/CONTAINER"
                read patch_container
                echo -e "\n${GREEN}[+]${NC} Set the size of the container in GigaBytes:\n1 = 1GB, 20 = 20GB"
                read size_container
                echo -e "\n${GREEN}[+]${NC} Enter the path with key file name:\nEx:/home/USER/CONTAINER"
                read name_keyfile
		
		#
		# ─ ─═[ Create null container  ]═─ ─
		#
		echo -e "\n\n${GREEN}[+]${NC} Create container....\n\n"
		sleep 1
		dd if=/dev/zero of=$patch_container bs=1 count=0 seek=$size_container
		
		#
		# ─ ─═[ Create key file  ]═─ ─
		#
		echo -e "\n\n${GREEN}[+]${NC} Create key file....\n\n"
		sleep 1
		dd if=/dev/urandom of=$name_keyfile bs=4096 count=1
		
		#
		# ─ ─═[ Encrypt container with Key File ]═─ ─
		#
		echo -e "\n\n${GREEN}[+]${NC} Encrypting the container $patch_container with key $name_keyfile...."
		echo -e "${YELLOW}*Obs: You'll be asked to enter "YES" in all uppercase (capslock) letters to proceed.${NC} \n\n"
		sleep 1
		sudo cryptsetup -y -c aes-xts-plain64 -s 512 -h sha512 -i 5000 --use-random luksFormat $patch_container $name_keyfile

		echo -e "${GREEN}[+]${NC} Unlocking container to format...."
		sudo cryptsetup luksOpen $patch_container SecretContainer --key-file $name_keyfile
		sleep 1

		echo -e "${GREEN}[+]${NC} Formatting the container...."
		sudo mkfs.ext4 /dev/mapper/SecretContainer
		sleep 1

		echo -e "${GREEN}[+]${NC} Mount container now?\n[Y]es [N]o"
		read m
		echo -e "${GREEN}[+]${NC} Path name to mount your container"
		read path_mount
		xpto="Unk"
		while true $xpto != "Unk"
		do
		case "$m" in
			y|Y)
				mkdir $path_mount
				sudo mount /dev/mapper/SecretContainer $path_mount
				sudo chown $USER:$USER $path_mount
				echo -e "Bye Bye..."
				sleep 1

				exit
				
			;;
			n|N)
				echo -e "Bye Bye..."
				sleep 1

				exit
			;;

		*)
			echo -e "Invalid option"
		esac
		done

                echo -e "================================================"
            ;;
            2)
		echo -e "${GREEN}[+]${NC} Path to the encrypted container"
		read path_crypt_cont
		echo -e "\n${GREEN}[+]${NC} Path to key file"
		read path_key_file
		echo -e "${GREEN}[+]${NC} Path to mount encrypted container"
		read path_mount_cont
		sudo cryptsetup luksOpen $path_crypt_cont SecretContainer --key-file $path_key_file
		sudo mount /dev/mapper/SecretContainer $path_mount_cont
                echo -e "Bye Bye"
                sleep 1
                clear;
                exit;
                echo -e "================================================"
            ;;
    	    3)
                echo -e "Bye Bye"
                sleep 1
                clear;
                exit;
	    ;;

*)
        echo -e "Opção inválida!"
esac

    done
}
menu

#
# Ref: https://null-byte.wonderhowto.com/how-to/hide-sensitive-files-encrypted-containers-your-linux-system-0186691/
#
#
#
