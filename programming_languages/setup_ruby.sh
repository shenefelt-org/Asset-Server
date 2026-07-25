# 1. Update APT and install Ruby, headers, and build tools (required for compiling native C gems)
sudo apt-get update
sudo apt-get install -y ruby-full ruby-dev build-essential

# 2. Update Gem & Install Bundler
sudo gem update --system
sudo gem install bundler

# 3. Configure Bundler globally to install gems into 'vendor/bundle' for every project
bundle config set --global path 'vendor/bundle'

printf "Ruby $(ruby -v) setup complete\nBundler Installed $(bundle -v)\n\n"
printf "Ruby ᥫ᭡."
