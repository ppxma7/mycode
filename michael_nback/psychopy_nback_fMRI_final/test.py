# -*- coding: utf-8 -*-
"""
Created on Mon Apr 17 12:02:32 2023

@author: SensaVue
"""

import pandas
import numpy as np
from numpy import matlib
from psychopy import visual, core, event, parallel, info
from os.path import exists


#from psychopy import parallel
#port = parallel.ParallelPort(address=0x03F8)
#info.RunTimeInfo(author=None, version=None, win=None, refreshTest='grating', userProcsDetailed=False, verbose=False)
#info.RunTimeInfo(author=None, version=None, win=None, refreshTest=False, userProcsDetailed=False, verbose=True)
info.RunTimeInfo()