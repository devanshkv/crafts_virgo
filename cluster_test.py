#!/usr/bin/env python
import numpy as np
import pylab as plt
import sys


def find_event(ant1,mjd1,ant2,mjd2, tol=(4*1.2e-3/(60.0*60.0*24.0))):
    snr1=[]
    snr2=[]
    for arg, event in enumerate(mjd2 + (ant2[:,2]/(60*60*24.0))):
        tim1=mjd1 + (ant1[:,2]/(60*60*24.0))
        diff=np.min(np.abs(event-tim1))
        darg=np.argmin(np.abs(event-tim1))
        if diff <= tol:
            #print event, ant2[arg,0],diff, tim1[darg], ant1[darg,0]
            snr1.append(ant1[darg,0])
            snr2.append(ant2[arg,0])
    return(snr1,snr2)


ant_list_file="ant_cands/ant_list"
 
with open(ant_list_file, 'r') as myfile:
    ant_list=myfile.read().strip().split() 


fig, axes = plt.subplots(figsize=(1.5*len(ant_list), 1.5*len(ant_list)), sharex=False, sharey=False, ncols=len(ant_list), nrows=len(ant_list))
SMALL_SIZE = 5
MEDIUM_SIZE = 7
BIGGER_SIZE = 10

plt.rc('font', size=SMALL_SIZE)          # controls default text sizes
plt.rc('axes', titlesize=SMALL_SIZE)     # fontsize of the axes title
plt.rc('axes', labelsize=MEDIUM_SIZE)    # fontsize of the x and y labels
plt.rc('xtick', labelsize=SMALL_SIZE)    # fontsize of the tick labels
plt.rc('ytick', labelsize=SMALL_SIZE)    # fontsize of the tick labels
plt.rc('legend', fontsize=SMALL_SIZE)    # legend fontsize
plt.rc('figure', titlesize=BIGGER_SIZE)  # fontsize of the figure title

for ii, ants1 in enumerate(ant_list):
    for jj, ants2 in enumerate(ant_list):
        if  ii > jj:
            #print ants1, ants2
            with open("ant_cands/"+ants1+str(".mjd"), 'r') as myfile:
                mjd1=float(myfile.read().strip().split()[0])
            ant1_cands=np.loadtxt("ant_cands/"+str(ants1)+".cand.fof.sorted")
            with open("ant_cands/"+ants2+str(".mjd"), 'r') as myfile:
                mjd2=float(myfile.read().strip().split()[0])
            ant2_cands=np.loadtxt("ant_cands/"+str(ants2)+".cand.fof.sorted")
            snr1, snr2 = find_event(ant1_cands,mjd1, ant2_cands, mjd2)
            axes[ii, jj].plot(snr1, snr2, 'k.')
            axes[ii, jj].set_xlabel(ants1)
            axes[ii, jj].set_ylabel(ants2)
            if ants1 != "ics":
                axes[ii, jj].set_xlim(10,40)
                axes[ii, jj].set_ylim(10,40)
                axes[ii, jj].plot((10,40),(10,40),'r-')
            else:
                axes[ii, jj].set_xlim(10,70)
                axes[ii, jj].set_ylim(10/np.sqrt(6),70/np.sqrt(6))
                x=np.array([10,70])
                y=x/np.sqrt(5)
                y1=x/np.sqrt(6)
                y2=x/np.sqrt(7)
                #axes[ii, jj].plot(x,y,'r-')
                #axes[ii, jj].plot(x,y2,'r-')
                axes[ii, jj].plot(x,y1,'r-')
        else:
            axes[ii, jj].axis('off')


plt.tight_layout(pad=0.4, w_pad=0.5, h_pad=1.0)
plt.savefig("ant_snr.pdf",bbox_inches="tight")
plt.show()
