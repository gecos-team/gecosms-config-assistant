# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-

# This file is part of Guadalinex
#
# This software is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This software is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this package; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA

__author__ = "Abraham Macias Paredes <amacias@solutia-it.es>"
__copyright__ = "Copyright (C) 2015, Junta de Andalucía" + \
    "<devmaster@guadalinex.org>"
__license__ = "GPL-2"

import logging
import traceback
import re

# Dummy package manager for Windows

class PackageManager(object):
    '''
    Utility class to manipulate packages.
    '''

    def __init__(self):
        '''
        Constructor
        '''
        self.logger = logging.getLogger('PackageManager')

    def is_package_installed(self, package_name):
        ''' Is package installed? '''
        return False

    def exists_package(self, package_name):
        ''' Does package exist? '''
        return False

    def upgrade_package(self, package_name):
        ''' Upgrading package '''
        return False

    def install_package(self, package_name):
        ''' Installing package '''
        return False

    def update_cache(self):
        ''' Updating cache '''
        return False
        
    def parse_version_number(self, package_version):
        ''' Parsing version number '''

        self.logger.debug ("parse_version_number starting ...")
        major = 0
        minor = 0
        release = 0

        # Version must be similar to: '1.13.4-1ubuntu1'
        p = re.compile('([0-9]+)\\.([0-9]+)(\\.([0-9]+))?')
        m = p.match(package_version)
        if m is not None:
            if m.groups()[0] is not None:
                major = int(m.groups()[0].strip())
            if m.groups()[1] is not None:
                minor = int(m.groups()[1].strip())
            if m.groups()[3] is not None:
                release = int(m.groups()[3].strip())

        return (major, minor, release)

    def get_package_version(self, package_name):
        ''' Getting package version '''
        return None

    def remove_package(self, package_name):
        ''' Removing package '''
        return False