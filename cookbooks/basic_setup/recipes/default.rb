
# Cookbook Name:: basic_setup
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

home = ENV['HOME']

template "#{home}/hello-world.txt" do
  source 'hello_world.txt.erb'
  mode '0644'
end


# DROPBOX
apt_repository "dropbox" do
  uri "http://linux.dropbox.com/ubuntu"
  distribution "precise"
  #quantal not available yet
  #distribution node['lsb']['codename']
  components ["main"]
  keyserver "pgp.mit.edu"
  key "5044912E"
end

package "dropbox"

execute "dropbox autostart y"
execute "dropbox start -i" do
	environment "https_proxy" => node["https_proxy"], "http_proxy" => node["http_proxy"]
	creates "#{home}/.dropbox-dist"
	user "frampp"
end

# BASH

link "#{home}/.bash_aliases" do
	to "#{home}/Dropbox/sysconf/bash_aliases"
end 

link "#{home}/.bashrc" do
	to "#{home}/Dropbox/sysconf/bashrc"
end 

# GIT

package "git"

link "#{home}/.gitconfig" do
	to "#{home}/Dropbox/sysconf/gitconfig_jambit"
end 

link "#{home}/.gitignore_global" do
	to "#{home}/Dropbox/sysconf/gitignore_global"
end 


# Subversion

package "subversion"


# JAVA

package "openjdk-7-jdk"


# VIM
package "vim"
package "vim-gtk"

link "#{home}/.vimrc" do
	to "#{home}/Dropbox/sysconf/vimrc"
end 

link "#{home}/.vim" do
	to "#{home}/Dropbox/sysconf/vim"
end 



# PRINTER DRIVER
directory "/usr/share/cups/model/Dell"
cookbook_file "/usr/share/cups/model/Dell/Dell_5130cdn.ppd.gz" do
	mode '0644'
end


# SPOTIFY

apt_repository "spotify" do
  uri "http://repository.spotify.com"
  distribution "stable"
  components ["non-free"]
  keyserver "keyserver.ubuntu.com"
  key "94558F59"
end

package "spotify-client"


# MAVEN

package "maven"


# FONTS

remote_file "/usr/local/share/fonts/SourceCodePro.zip" do
	source "http://downloads.sourceforge.net/project/sourcecodepro.adobe/SourceCodePro_FontsOnly-1.010.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fsourcecodepro.adobe%2F&ts=1353573824&use_mirror=netcologne"
	notifies :run, "script[unzip_font]"
end

script "unzip_font" do
	action :nothing
	interpreter "bash"
	cwd "/usr/local/share/fonts/"
	code <<-EOH
	unzip SourceCodePro.zip
	rm "SourceCodePro.zip"
	EOH
end



# MISC
package "aptitude"
package "gconf-editor"
package "tree"
package "curl"
package "colordiff"
package "chromium-browser"
package "wireshark"



# for Chef development
gem_package "bundler"
# the following two packages are required to install Nokogiri, which is required by foodcritic, see here: http://nokogiri.org/tutorials/installing_nokogiri.html
package "libxml2-dev"
package "libxslt1-dev"
gem_package "foodcritic"

