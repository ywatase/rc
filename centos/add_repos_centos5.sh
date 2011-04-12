#!/bin/sh
# Last Modified: 2009/08/27.

wget http://download.fedora.redhat.com/pub/epel/5/i386/epel-release-5-3.noarch.rpm
wget http://rpms.famillecollet.com/el5.i386/remi-release-5-7.el5.remi.noarch.rpm
wget http://dag.wieers.com/rpm/packages/rpmforge-release/rpmforge-release-0.3.6-1.el5.rf.i386.rpm
rpm -Uvh epel-release-5* remi-release-5*
rpm -Uvh rpmforge-release-0.3.6-1.el5.rf.i386.rpm

