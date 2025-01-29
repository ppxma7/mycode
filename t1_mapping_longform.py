import os
import subprocess
import numpy as np
from numpy import exp
import time
import sys
import nibabel as nib
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit
import glob

# Directory
DATA_DIR = "/Users/spmic/data/AFIRM/inputs"  # Change to your actual data path
OUTPUT_DIR = "/Users/spmic/data/AFIRM/t1mapping_out"
MNI_TEMPLATE = "/Users/spmic/data/MNI152_T1_2mm_brain.nii.gz"  # Adjust if needed
# Ensure output directory exists
os.makedirs(OUTPUT_DIR, exist_ok=True)

# List of subjects
subjects = ["16469-002A", "16500-002B", "16501-002b", "16521-001b3", "16523_002b"]

# Input MR parameters
nTIs=8; #8
MBfactor=2; #2 4
TR=4500 #4500
sliceOffsets=[0,12,24,36,48,60,72,84]
minTI=32 #32 10

phase_fit=True

def size(A):
    sizei = 1
    for dim in np.shape(A): sizei = sizei*dim
    return sizei

## T1 fit functions
# TR is a global variable here...
def myT1fit(t,T1,M0):
    fit =  M0 * (1 - 2*exp(-t/T1) + exp(- TR/T1))
    # e = (data(:) - fit(:))**2;
    return fit

def fitT1(sortTIi,modSlice,maskSlice2):
    datasize=int(modSlice.shape[0])
    t1=np.zeros((datasize,1))
    m0=np.zeros((datasize,1))
    r2=np.zeros((datasize,1))
    e2=np.zeros((datasize,1))
    #modSlice already flattened as input...
    for i in range(0,datasize):#range(int(datasize/2-1000),int(datasize/2+1000)):#
        if maskSlice2[i]:
            modSlicei=modSlice[i,:]
            # params,pcov=curve_fit(myT1fit,sortTIi,modSlicei,p0=[1000,modSlicei[-1]],
            #                       bounds=[[0,0],[10000,1e7]],maxfev=500,ftol=0.01,xtol=0.01)
            params,pcov=curve_fit(myT1fit,sortTIi,modSlicei,p0=[1000,modSlicei[-1]],
                                  bounds=[[0,0],[10000,1e7]],maxfev=500,ftol=0.01,xtol=0.01)
            t1[i]=params[0]
            m0[i]=params[1]
            
            sigfit=myT1fit(sortTIi,params[0],params[1])
            
            #corr_matrix = np.corrcoef(modSlicei,sigfit)
            #corr = corr_matrix[0,1]
            #r2[i] = corr**2
            
            y = modSlicei
            yhat = sigfit                        
            ybar = np.sum(y)/len(y)         
            ssres = np.sum((y - yhat)**2)   
            sstot = np.sum((y - ybar)**2)   
            r2[i] = 1 - ssres / sstot
            
            #r2[i]=sum((myT1fit(sortTIi,params[0],params[1])-modSlicei)**2)
            e2[i]=np.sqrt(np.diag(pcov))[0]
        else:
            t1[i]=0
            m0[i]=0
            r2[i]=0
            e2[i]=0
    return t1,m0,r2,e2

def fitT1_try(sortTIi, modSlice, maskSlice2):
    datasize = int(modSlice.shape[0])
    t1 = np.zeros((datasize, 1))
    m0 = np.zeros((datasize, 1))
    r2 = np.zeros((datasize, 1))
    e2 = np.zeros((datasize, 1))

    for i in range(datasize):
        if maskSlice2[i]:
            modSlicei = modSlice[i, :]
            initial_guess = [1000, np.clip(modSlicei[-1], 0, 1e7)]
            
            try:
                params, pcov = curve_fit(myT1fit, sortTIi, modSlicei, p0=initial_guess,
                                         bounds=[[0, 0], [10000, 1e7]], maxfev=500, 
                                         ftol=0.01, xtol=0.01)
                t1[i] = params[0]
                m0[i] = params[1]
                
                sigfit = myT1fit(sortTIi, params[0], params[1])
                y = modSlicei
                yhat = sigfit                        
                ybar = np.sum(y) / len(y)         
                ssres = np.sum((y - yhat)**2)   
                sstot = np.sum((y - ybar)**2)   
                r2[i] = 1 - ssres / sstot
                
                e2[i] = np.sqrt(np.diag(pcov))[0]
            except ValueError as e:
                print(f"Error at index {i}: {e}")
                t1[i], m0[i], r2[i], e2[i] = 0, 0, 0, 0
        else:
            t1[i], m0[i], r2[i], e2[i] = 0, 0, 0, 0

    return t1, m0, r2, e2



# MAIN Loop here
for subject in subjects:

       # Save rearranged images
    sub_dir = os.path.join(OUTPUT_DIR, subject)
    os.makedirs(sub_dir, exist_ok=True)


    subject_path = os.path.join(DATA_DIR, subject, "T1mapping")
    print(f"Processing subject: {subject}")

    # Locate required files
    t1_files = glob.glob(os.path.join(subject_path, "*T1mapping*.nii"))
    ph_files = glob.glob(os.path.join(subject_path, "*T1mapping*_ph.nii"))

    if not t1_files or not ph_files:
        print(f"  Missing required files for {subject}, skipping...")
        continue

    t1_file = t1_files[0]  # Use the first match
    ph_file = ph_files[0]

    # Define temporary output filenames
    t1_trimmed = os.path.join(sub_dir, "WIP_T1mapping_901_trimmed.nii.gz")
    ph_trimmed = os.path.join(sub_dir, "WIP_T1mapping_901_ph_trimmed.nii.gz")

    # Remove last dynamic (9 -> keep first 8)
    subprocess.run(["fslroi", t1_file, t1_trimmed, "0", "8"], check=True)
    subprocess.run(["fslroi", ph_file, ph_trimmed, "0", "8"], check=True)

    # Load trimmed data
    imgm = nib.load(t1_trimmed)
    imgm_img = imgm.get_fdata()
    imgp = nib.load(ph_trimmed)
    imgp_img = imgp.get_fdata()


    imgm_header=imgm.header
    dimensions=imgm_header['dim']
    nX=dimensions[1]
    nY=dimensions[2]
    nS=dimensions[3]
    nTIs=dimensions[4]
    nS_MB1=int(nS/MBfactor); #number of slices per band
    Tseg=TR/nS_MB1; 

    #TIs=(0:1:(nS_MB1-1))*Tseg+ones(1,nS_MB1)*44.5; 
    TIs = minTI + Tseg*np.arange(0,nS_MB1,1,dtype=float)

    #TIs=repmat(TIs,[1 MBfactor]);
    TIs=np.tile(TIs,(1,MBfactor))

    # Default ascend order goes from 1 to nS
    default=np.arange(1,nS_MB1+1,1)

    ascend=np.zeros((len(sliceOffsets),nS))
    ascendMB1=np.zeros((len(sliceOffsets),nS_MB1))


    for sJump in range(0,len(sliceOffsets)):
        ascendMB1[0:nS_MB1-1][sJump]=np.roll(default,-sliceOffsets[sJump])
        #ascendMB1[sJump, 0:nS_MB1-1] = np.roll(default, -sliceOffsets[sJump])


    if MBfactor>1:
        for sJump in range(0,len(sliceOffsets)):
            ascend[sJump]=np.tile(ascendMB1[sJump], (1,MBfactor))
            for iBand in range(2,MBfactor+1,1):
                firstslice=nS_MB1*(iBand-1)
                subslices=np.arange(firstslice,nS_MB1*iBand)
                ascend[sJump][subslices]=ascend[sJump][subslices]+nS_MB1*(iBand-1); # this needs to be fixed-how to acces pat of the array
    else: 
        ascend=ascendMB1



    sortTI=np.zeros((len(sliceOffsets),nS))
    sortTIindex=np.zeros((len(sliceOffsets),nS),dtype=int)
    sortTI2=np.zeros((len(sliceOffsets),nS))

    modData=np.zeros((nX,nY,nS,nTIs))
    phData=np.zeros((nX,nY,nS,nTIs))

    TI_slice=np.zeros((len(sliceOffsets),nS))
    for iSlice in range(0,nS): 
        for sJump in range (0,len(sliceOffsets)):
            #put into TI_slice the actual TI based on TIs array
            a=[int(y-1) for y in ascend[sJump]] 
            if iSlice in a:
                TI_slice[sJump][iSlice]=TIs[0][a.index(iSlice)]

    sortTI=np.sort(TI_slice,axis=0)
    sortTIindex=np.argsort(TI_slice,axis=0)


    for iSlice in range(0,nS): 
        # use this slice as a test
         #range(0,nS): 
        #Need to sort data so that TIs etc are in increasing order
        index=sortTIindex[:,iSlice]
        modData[:,:,iSlice,:]=imgm_img[:,:,iSlice,index]; 
        phData[:,:,iSlice,:]=imgp_img[:,:,iSlice,index]; 


    


    rearranged_img = nib.Nifti1Image(modData, None, header=imgm.header)
    rearranged_img.to_filename(os.path.join(sub_dir, "modulus_rearranged.nii.gz"))
    rearranged_phs = nib.Nifti1Image(phData, None, header=imgp.header)
    rearranged_phs.to_filename(os.path.join(sub_dir, "phase_rearranged.nii.gz"))

     # Load mask

     # create a mask here
    subprocess.run(["bet", t1_file, os.path.join(sub_dir, "T1_brain"), "-m", "-Z", "-f", "0.2"], check=True)

    #subprocess.run(["bet", t1_file, t1_trimmed, "0", "8"], check=True) 
    #bet $2_t1mean $2_mask -m -Z -f 0.2

    maskData = nib.load(os.path.join(sub_dir, "T1_brain_mask.nii.gz")).get_fdata()
    maskDatai = maskData.astype(int)


    # It is possible to load a mask generated by bet instead:
    # command1: fslmaths T1_16_1_modulus -Tmean T1_16_1_avg
    # command2: bet T1_16_1_avg.nii.gz T1_16_1_mask -m -Z -f 0.2

    # T1 fit routine:
    T1fit=np.zeros((nX,nY,nS))
    M0fit=np.zeros((nX,nY,nS))
    alphafit=np.zeros((nX,nY,nS))
    r2fit=np.zeros((nX,nY,nS))
    e2fit=np.zeros((nX,nY,nS))
    modSlice=np.zeros((nX,nY,nS))

    #print(type(nX))
    sisl=int(nX)*int(nY)*int(nTIs)
    nXY=int(nX)*int(nY)
    phSlice=np.zeros((nX,nY,nTIs))#float64 by default
    phDiff0=np.zeros((sisl,1))
    phDiff=np.zeros((nX,nY,nTIs))
    phDiff2=np.zeros((nXY,nTIs))
    indices=np.zeros((nXY,nTIs),dtype=bool)
    modSlice=np.zeros((nX,nY,nS))
    modSlice2=np.zeros((int(nX)*int(nY),nS))

    #for iSlice in range(82,83):#(0,nS) (82,83)
    for iSlice in range(115,116):#(0,nS) (82,83)
        start_time = time.time()
    #     if maskDatab[:,:,iSlice]:  
        print('Computing slice '+str(iSlice))
        modSlice= modData[:,:,iSlice,:]
        phSlice = phData[:,:,iSlice,:]
        maskSlice = maskDatai[:,:,iSlice]
        
        #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        #Perform correction of modulus polarity based on phase 
        #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ## get phase reference
    
            ## get phase reference
        phRef = phSlice[:,:,-1]
    
        phDiff = np.repeat(phRef,nTIs,axis=1).reshape(nX,nY,nTIs) - phSlice;
        ## add 2*pi to locations where PH < 0
        phDiff0=phDiff.ravel()
        aa=phDiff0<0
        phDiff0[aa]=phDiff0[aa]+2*np.pi
    
        phDiff2 = phDiff0.reshape(nXY,nTIs)

            
        modSlice2 = np.reshape(modSlice,(nXY,nTIs))
        maskSlice2 = np.reshape(maskSlice,(nXY,1))
        
        #print(modSlice2.shape)
        

        print("doing phase correction")
        for ipix in range(0,nXY):
            i_jump=nTIs-1
            while i_jump >= 0: #range(nTIs-1,0,-1):
                indices[ipix,i_jump] = np.equal(np.greater(phDiff2[ipix,i_jump],np.pi/2), \
                                            np.less(phDiff2[ipix,i_jump],3*np.pi/2))
                if indices[ipix,i_jump]:
                    for i_jumpi in range(0,i_jump+1):
                        modSlice2[ipix,i_jumpi] = -modSlice2[ipix,i_jumpi]
                        indices[ipix,i_jumpi]=True
                    break
                else:
                    i_jump=i_jump-1
        

            
        
        #Perform fit and save result for this slice
        t1,m0,r2,e2=fitT1_try(sortTI[:,iSlice],modSlice2,maskSlice2)

        
        #save results in 3D array
        T1fit[:,:,iSlice]=np.reshape(t1,(nX,nY))
        M0fit[:,:,iSlice]=np.reshape(m0,(nX,nY))
        #alphafit[:,:,iSlice]=np.reshape(alpha,(nX,nY))
        r2fit[:,:,iSlice]=np.reshape(r2,(nX,nY))
        e2fit[:,:,iSlice]=np.reshape(e2,(nX,nY))
        print("--- %s seconds ---" % (time.time() - start_time))
  
    # save out data
    t1img=nib.nifti1.Nifti1Image(T1fit, imgm.affine)

    
    #t1img.to_filename(sub_dir+'_T1.nii.gz')  
    t1img.to_filename(os.path.join(sub_dir, "_T1.nii.gz"))
    m0img=nib.nifti1.Nifti1Image(M0fit, imgm.affine)
    #m0img.to_filename(sub_dir+'_M0.nii.gz') 
    m0img.to_filename(os.path.join(sub_dir, "_MO.nii.gz"))
    #alphaimg=nib.nifti1.Nifti1Image(alphafit, imgm.affine)
    #alphaimg.to_filename(sub_dir+'_alpha.nii.gz')  
    r2img=nib.nifti1.Nifti1Image(r2fit, imgm.affine)
    #r2img.to_filename(sub_dir+'_R2.nii.gz')
    r2img.to_filename(os.path.join(sub_dir, "_R2.nii.gz"))
    e2img=nib.nifti1.Nifti1Image(e2fit, imgm.affine)
    #e2img.to_filename(sub_dir+'_E2.nii.gz') 
    e2img.to_filename(os.path.join(sub_dir, "_E2.nii.gz"))



