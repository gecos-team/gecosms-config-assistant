#!/usr/bin/python
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

__author__ = "Abraham Macias Paredes <amacias@gruposolutia.com>"
__copyright__ = "Copyright (C) 2019, Junta de Andalucía <devmaster@guadalinex.org>"
__license__ = "GPL-2"

# Import all necessary modules
# py2exe should include them into library.zip

import glob
import hashlib
import os
import platform
import sys
import urllib2
import logging
import certifi
import requests
import OpenSSL
import pyasn1_modules.rfc2459
import json
import base64
import binascii


# Import GECOS Config Assistant code
import gecosws_config_assistant
import gecosws_config_assistant.dao
import gecosws_config_assistant.dao.GecosAccessDataDAO
import gecosws_config_assistant.dao.WorkstationDataDAO
import gecosws_config_assistant.dto.GecosAccessData
import gecosws_config_assistant.dto.WorkstationData
import gecosws_config_assistant.firstboot_lib.firstbootconfig
import gecosws_config_assistant.util
import gecosws_config_assistant.util.CommandUtil
import gecosws_config_assistant.util.GecosCC
import gecosws_config_assistant.util.GemUtil
import gecosws_config_assistant.util.JSONUtil
import gecosws_config_assistant.util.PackageManager
import gecosws_config_assistant.util.PasswordMaskingFilter
import gecosws_config_assistant.util.SSLUtil
import gecosws_config_assistant.util.Template
import gecosws_config_assistant.util.Validation




