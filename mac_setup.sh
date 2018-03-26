set -x

#Setup Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor

# Generate SSH key
ssh-keygen -t rsa -b 4096 -C "awhipple@newrelic.com"
eval "$(ssh-agent -s)"
ssh-add -K ~/.ssh/id_rsa
echo "Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_rsa" > ~/.ssh/config
pbcopy < ~/.ssh/id_rsa.pub

echo "Upload RSA key to github."
echo ""
cat ~/.ssh/id_rsa.pub
echo ""

#Create Projects Directory
mkdir projects

# Configure bash profile
echo "if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi" > ~/.bash_profile
touch ~/.bashrc

# Configure git
git config --global user.email "awhipple@newrelic.com"
git config --global user.name "Aaron Whipple"

git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.cm commit
git config --global alias.st status
git config --global alias.short "rev-parse --short HEAD"

echo "# Git branch in prompt.
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1='\W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ '" >> ~/.bashrc

brew install git && brew install bash-completion
echo "if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi" >> ~/.bashrc

#Install Ruby tools
brew install rbenv
rbenv install 2.3.1
gem install bundler
echo "
#rbenv
export PATH=\"~/.rbenv/shims:$PATH\"" >> ~/.bashrc

#Setup symlinks
# sudo ln -s /Applications/Atom.app/Contents/Resources/app/atom.sh /usr/local/bin/atom
