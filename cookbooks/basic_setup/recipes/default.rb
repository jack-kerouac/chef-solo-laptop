#
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


# MISC
package "aptitude"
package "tree"
