####### CONFIGURATION SECTION #######
export urlCvs=cvs://server_address/repository	# cvs repository url
export cvsUsername=username						# cvs username
export cvsFolder=~/cvs_folder					# cvs folder name, used for checkout
export svnFolder=~/svn_folder.svn				# svn folder name, used to create then convereted repository
export authorsFile=~/authors.txt				# file containing a list of author, can be created from script


####### --------------------- #######


clear
echo "Remember to install svn, cvs and svn-cvs"
echo "  sudo apt-get install subversion cvs svn-cvs"
read -p "Press [Enter] to continue or CTRL+C to stop the script and install them..."
echo 
echo "0. Checkout cvs repository"
svn co --username $svnUsername $urlSvn/$nomeRepositorySvn $svnFolder
cd $svnFolder

echo # move to a new line
echo "Would you retrieve a list of all Cvs committers"
read -p "and overwrite $authorsFile? [y/N]" -n 1 -r
echo # move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo "1. Retrieve a list of all Cvs committers"
	cvs log -q | awk -F '|' '/^r/ {sub("^ ", "", $2); sub(" $", "", $2); print $2" = "$2" <"$2">"}' | sort -u > $authorsFile
	echo "convert 'mayankrs = mayankrs <mayankrs>' into this 'mayankrs = mayankrs <mayankrs@examplefdx.com>'"
	read -p "Press [Enter] to continue..."
	nano $authorsFile
fi



echo "2. Clone the Cvs repository using svn-cvs"
svn cvs clone $urlCvs --no-metadata -A $authorsFile --stdlayout ~/temp


echo "3. Convert cvs:ignore properties to .svnignore"
cd ~/temp
cvs svn show-ignore --id=origin/trunk > .svnignore
svn add .svnignore
svn commit -m 'Convert cvs:ignore properties to .svnignore.'


echo "4. Push repository to a bare cvs+ repository"
svn init --bare $svnFolder
cd $svnFolder
#svn symbolic-ref HEAD refs/heads/trunk
svn symbolic-ref HEAD refs/heads/origin/master
cd ~/temp
svn remote add bare $svnFolder
svn config remote.bare.push 'refs/remotes/*:refs/heads/*'
svn push bare


echo "5. Rename 'trunk' branch to 'master'"
cd $svnFolder
svn branch -m origin/trunk origin/master


echo "6. Clean up branches and tags"
cd $svnFolder
svn for-each-ref --format='%(refname)' refs/heads/tags |
cut -d / -f 4 |
while read ref
do
  svn tag "$ref" "refs/heads/tags/$ref";
  svn branch -D "tags/$ref";
done

echo "Finish!"



























