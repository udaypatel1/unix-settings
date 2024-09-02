
# Install dependencies in Brewfile

brew help > /dev/null 2>&1 || RESULT=$?

if [ -e $RESULT ]; then

    echo "...installing Brewfile dependencies"
    
    BREWFILE_RELATIVE_PATH="../homebrew/Brewfile"
	brew bundle install --file $BREWFILE_RELATIVE_PATH

	echo "...installation successful!"
    
else
    echo "Error: Please install Homebrew on this machine"
    exit 1
fi

# Generate .zprofile copy

ZPROFILE_NAME='.zprofile-generated'
echo "...generating [${ZPROFILE_NAME}] in Home directory"

cp ../zsh/config.zsh ~/$ZPROFILE_NAME

echo "---------------"
echo "Auto Install Complete!"
echo "---------------"
echo "NOTE: To use your new ${ZPROFILE_NAME} file, replace your existing .zprofile or .zshrc file. Be careful to keep / remove any necessary dependencies"



