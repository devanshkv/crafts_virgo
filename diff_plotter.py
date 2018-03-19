#!/usr/bin/env python

import numpy as np
import pylab as plt
import sys

cand1=np.loadtxt(sys.argv[1],skiprows=1)
cand2=np.loadtxt(sys.argv[2],skiprows=1)

min_range=0#np.min(0,np.append(cand1[:,2],cand2[:,2]))
max_range=100#np.max(np.append(cand1[:,2],cand2[:,2])) + 10
alpha=0.35
plt.figure(1)
for ii,event in enumerate(cand1[:,2]):
    if np.min(np.abs(cand2[:,2] - event)) < 10*1.2e-3:
        k=plt.scatter(cand1[ii,5], cand1[ii,2],marker='.',s=cand1[ii,0]*25,color='k', label="common", alpha=0.25, facecolor="None") # common ones
    else:
        r=plt.scatter(cand1[ii,5], cand1[ii,2],marker='.',s=cand1[ii,0]*25,color='r', label="new in "+ str(sys.argv[1]),alpha=alpha) # in 1 missed by 2 
        #print cand1[ii,5], cand1[ii,2], cand1[ii,0]



for jj,event in enumerate(cand2[:,2]):
    if np.min(np.abs(cand1[:,2] - event)) > 10*1.2e-3:
        plt.figure(1)
        b=plt.scatter(cand2[jj,5], cand2[jj,2],marker='.',s=cand2[jj,0]*25,color='b', label="new in "+ str(sys.argv[2]),alpha=alpha) # in 2 missed by 1
    else:
        if 55 < cand2[jj,5] < 60:
            ind=np.max(cand1[:,0][np.where((np.abs(cand1[:,2] - event).astype('int'))==0)])
            plt.figure(4)
            plt.plot(ind,cand2[jj,0],'b.')
        #b=None

plt.xlabel("DM")
plt.ylabel("Secs from file start")
plt.xlim(min_range,max_range)
plt.legend([k,b,r],["common", "new in "+ str(sys.argv[2]), "new in "+ str(sys.argv[1])])
plt.savefig("cands_old_vs_new.pdf")

#plt.figure(2)
#plt.plot(cand1[:,5],cand1[:,2],'k.', label=sys.argv[1])
#plt.legend()
#plt.xlabel("DM")
#plt.ylabel("Secs from file start")
#plt.xlim(min_range,max_range)
#
#
#plt.figure(3)
#plt.plot(cand2[:,5],cand2[:,2],'r.', label=sys.argv[2])
#plt.legend()
#plt.xlabel("DM")
#plt.ylabel("Secs from file start")
#plt.xlim(min_range,max_range)
x=[7,60]
plt.figure(4)
plt.plot(x,x,'k--',label=r"$y=x$")
plt.legend()
plt.xlabel("S/N "+str(sys.argv[1]))
plt.ylabel("S/N "+str(sys.argv[2]))
plt.savefig("SNR_old_vs_new.pdf")
plt.show()
