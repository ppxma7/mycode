# -*- coding: utf-8 -*-
"""
Created on Wed Feb  9 15:47:38 2022

@author: ppysc6
"""

import numpy as np
from psychopy import visual, core, event, parallel
import scipy.io

run = 1

#serial port settings
port = parallel.ParallelPort(address=int('B030',16))    #open serial port to start routine
trig_len = 10/600     # s

n_stims = 15    # letters per block
t_stims = 1     # time elapsed per letter (s)
t_pause = 1     # pause between letters (s)
t_rest = 50     # total rest time per block (s)
conditions = np.array([1,2])
n_blocks = 6     # number of blocks per condition
t_instruction = 2   # instruction screen time (s)
t_block = (n_stims*(t_stims+t_pause))+t_rest+t_instruction

### set trigger names
block_start = [1,2]
rest_start = [3,4]
trig_target = 5
trig_nontarget = 6
resp = 7
filepath = r'C:\Users\7TSTIM\Documents\Seb\nback_psychopy\psychopy_nback_fMRI_final'
mat1 = scipy.io.loadmat(filepath + '\\one_back_mat.mat')
mat1 = mat1['one_back_mat']
shuffle1 = np.array([2,7,6,4,1,0,5,3])
if run==2:
    mat1 = mat1[shuffle1,:]
targets1 = np.diff(mat1,axis=1,prepend=1) == 0
mat2 = scipy.io.loadmat(filepath + '\\two_back_mat.mat')
mat2 = mat2['two_back_mat']
shuffle2 = np.array([1,4,3,0,2,5,6,7])
if run==2:
    mat2 = mat2[shuffle2,:]
targets2 = np.concatenate((np.zeros((8,2)),np.subtract(mat2[:,2:15],mat2[:,0:13])==0),axis=1)==1

mats = np.zeros((8,15,2))
mats[:,:,0] = mat1
mats[:,:,1] = mat2

targets = np.zeros((8,15,2))
targets[:,:,0] = targets1
targets[:,:,1] = targets2

cond_sequence = np.array([0,1,1,0,1,0,0,0,1,0,1,1,0,1,0,1])
shuffle_cond = np.array([4,13,1,0,8,6,9,7,14,11,3,10,2,15,5,12])
if run==2:
    cond_sequence = cond_sequence[shuffle_cond]
        
mats_stacked = np.vstack([mat1,mat2])
targets_stacked = np.vstack([targets1,targets2])
mat_ordered = np.zeros(np.shape(mats_stacked))
targets_ordered = np.zeros(np.shape(mats_stacked))
for cond in np.arange(len(conditions)):
    mat_ordered[cond_sequence==cond] = mats[:,:,cond]
    targets_ordered[cond_sequence==cond] = targets[:,:,cond]

letter_sequence = np.reshape(mat_ordered,np.size(mat_ordered))
target_sequence = np.reshape(targets_ordered,np.size(mat_ordered))==1
 
#%%
def nback(n_stims,t_stims,t_pause,t_rest,t_instruction,conditions,n_blocks,letter_sequence,
          target_sequence):
    
    # Allow user to terminate the experiment early with the "q" key
    global check
    check = 0
    def quit_exp():
          global check
          check = 1
         
    def send_trigger(data):
        filehandle.write(str(data) + ' ' + str(master_clock.getTime()) + '\n')
        port.setData(data)
        core.wait(trig_len)
        port.setData(0)
          
    def btn_press():
        filehandle.write('btn ' + str(master_clock.getTime()) + '\n')
        port.setData(resp)
        core.wait(trig_len)
        port.setData(0)
          
    def block(condition):
        # instruction screen
        clock = core.Clock()
        send_trigger(block_start[condition])
        while clock.getTime() < t_instruction:  # Clock times are in seconds
            if check == 1:
                break
            iscreens[condition].draw()
            window.flip()
        # task period
        t=t_instruction
        for stim in np.arange(n_stims):
            if check == 1:
                break
            if target_sequence[(blocknum*n_stims)+stim]:
                send_trigger(trig_target) 
            else:
                send_trigger(trig_nontarget)
               
            while clock.getTime() < t+t_stims:
                if check == 1:
                    break
                letters[(blocknum*n_stims)+stim].draw()
                window.flip()
            while clock.getTime() < t+t_stims+t_pause:
                if check == 1:
                    break
                window.flip()
            t+=(t_stims+t_pause)
        # rest period        
        send_trigger(rest_start[condition])
        while clock.getTime() < t_block:
            if check == 1:
                break
            fixation.draw()
            window.flip()
        
         
    event.globalKeys.clear()     
    event.globalKeys.add(key='q', func=quit_exp)
    event.globalKeys.add(key='b', func=btn_press)
    
    #create a window
    window = visual.Window(fullscr=False,monitor="testMonitor", units="norm")
    window.color = "gray" 
    
    #create instruction screens
    iscreens = []
    for cond in np.arange(len(conditions)):
        instruction = str(conditions[cond]) + "-back"
        iscreen = visual.TextStim(win=window,text=instruction,color='red'
                              ,height=0.4,alignText='center',anchorHoriz='center',
                              anchorVert='center')
        iscreens.append(iscreen)
        
    # create intro screen
    intro_screen = visual.TextStim(win=window,text="keep still!",color='red'
                          ,height=0.3,alignText='center',anchorHoriz='center',
                          anchorVert='center')
        
    #create letter objects
    letters = []
    for stim in np.arange(len(letter_sequence)):
        letter = visual.TextStim(win=window,text=chr(int(letter_sequence[stim])),color='black'
                              ,height=0.4,alignText='center',anchorHoriz='center',
                              anchorVert='center')
        letters.append(letter)
        
    # create fixation
    fixation = visual.GratingStim(win=window, units="norm", size=[0.05,0.06], 
                              pos=[0,0], sf=0, color="red")
        
    # run task
    filehandle = open(r'C:\Users\7TSTIM\Documents\Seb\nback_psychopy\psychopy_nback_fMRI_final\TrigFile.txt', 'w')
    master_clock = core.Clock()
    window.flip()
    intro_screen.draw()
    window.flip()
    event.Mouse(visible=False)
    event.waitKeys(keyList='5')
    filehandle.write('StartData ' + str(master_clock.getTime()) + '\n')
    fixation.draw()
    window.flip()
    core.wait(90)
    blocknum=0
    for cond in cond_sequence[0:14]:
        if check == 1:
            break
        block(cond)
        blocknum += 1
    intro_screen.draw()
    window.flip()
    filehandle.write('EndData ' + str(master_clock.getTime()) + '\n')
    event.waitKeys(keyList="<space>")
    filehandle.close()
    window.close()
    core.quit()

### run n-back task
nback(n_stims,t_stims,t_pause,t_rest,t_instruction,conditions,n_blocks,letter_sequence,
      target_sequence)


