#Helper functions for Logistic Regressions
#Ref: Cousera AI Deep Learning Course 2020

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import time
import sys


sns.set()
###############################################################################
# Split Data
    
def splitdata(X, Y, rand_seed, tnx):
    '''
    Function used to split data into training, test and validation datastes
    This takes the predictor variables X and response variables Y, and 
    
    Input
    =====
        X         = An m by nx (nx = number of features) data matrix
        Y         = An m by 1 array of class labels
        rand_seed = Integer to ensure reproducibility for random generation 
        tnx       = Float between 0 and 1 used to specify the size of test/validation
    
    Output
    ======
        xtr, ytr = Training data, label
        xva, yva = Validation data, label
        xte, yte = Test data, label
    '''
    np.random.seed(rand_seed)
    m    = X.shape[0]
    index = np.random.permutation(m)
    
    if (tnx > 1) or (tnx < 0) :
        print("This should be greater than 0 and less than 1")

    len1= int(np.round(len(index)* tnx, 0))
    len2= int(np.round(len(index)* (1-tnx)/2, 0))

    xtr  = X[index[0:len1],:]
    xva  = X[index[len1:(len1 + len2)],:]
    xte  = X[index[(len1 + len2):],:]
    
    ytr  = Y[index[0:len1]]
    yva  = Y[index[len1:(len1 + len2)]]
    yte  = Y[index[(len1 + len2):]]
    
    print('{} training examples and {} features'.format(xtr.shape[0],xtr.shape[1]))
    print('{} validation examples and {} features'.format(xva.shape[0],xva.shape[1]))
    print('{} testing examples and {} features'.format(xte.shape[0],xte.shape[1]))
    
    return xtr, xva, xte, ytr.reshape(len(ytr),1), yva.reshape(len(yva),1), yte.reshape(len(yte),1)
####################################################
def splitdataX(X, Y, rand_seed, tnx):
    
    np.random.seed(rand_seed)
    m = X.shape[0]
    index = np.random.permutation(m)
    
    if (tnx > 1) or (tnx < 0) :
        print("This should be greater than 0 and less than 1")

    len1= int(np.round(len(index)* tnx, 0))
    len2= int(np.round(len(index)* (1-tnx)/2, 0))

    xtr  = X[index[0:len1]]
    xva  = X[index[len1:(len1 + len2)]]
    xte  = X[index[(len1 + len2):]]
    
    ytr  = Y[index[0:len1]]
    yva  = Y[index[len1:(len1 + len2)]]
    yte  = Y[index[(len1 + len2):]]
    
    return xtr, xva, xte, ytr.reshape(len(ytr),1), yva.reshape(len(yva),1), yte.reshape(len(yte),1)



####################################################
#plt.style.use('fivethirtyeight')
plt.style.use('ggplot')
import warnings
warnings.filterwarnings('ignore')

####################################################
#Initialise Parameters
def initalise_parameters(X):
    
    w = np.zeros(X.shape[0]).reshape(X.shape[0],1)
    b = np.zeros(1).reshape(1,1)

    return w,b

###################################################
#Compute Sigmoid Function
def sigmoid(x):
        
    z = 1/(1+ np.exp(-x))
    
    return z    

###################################################
#Compute Activation
def computeActivation(X, w, b):
    
    z  = np.dot(w.T,X) + b
    A  = sigmoid(z)
    
    return A

###################################################
#Propagate through X and compute gradient and Cost
def propagate(w, b, X, Y):
    
    m    = X.shape[1]
    A    = computeActivation(X, w, b)
    cost = - 1/m * np.sum((Y* np.log(A)) + ((1-Y) * np.log(1-A))) 
    dw   =   1/m * np.dot(X,(A - Y).T)
    db   =   1/m * np.sum(A-Y)
    
    grads = {"dw": dw,
             "db": db}
    
    return grads, cost

###################################################
# Optimise parameters
def optimize(w, b, X, Y, num_iterations, learning_rate, print_cost = True):
    
    costs = []
    for i in range(num_iterations):
        
        grads, cost = propagate(w, b, X, Y)
        dw = grads["dw"]
        db = grads["db"]
        w  = w - learning_rate * dw
        b  = b - learning_rate * db
        
        if i % 1000 == 0:
            costs.append(cost)
            
        if print_cost and i % 10000 == 0:
            print("Cost after iteration %i: %f" %(i, cost))
              
    params = {"w": w,
              "b": b}
    
    grads = {"dw": dw,
             "db": db}
    
    return params, grads, costs

###################################################
#Make Prediction
def predict(w, b, X):
    m = X.shape[1]
    Y_prediction = np.zeros((1,m))
    probestimates= np.zeros((1,m))
    w = w.reshape(X.shape[0], 1)
    A = sigmoid(np.dot(w.T,X)  + b) 
    
    for i in range(A.shape[1]):
        if A[:,i] <= 0.5:
            Y_prediction[:,i] = 0
            probestimates[:,i] = A[:,i]
        elif A[:,i] > 0.5:
            Y_prediction[:,i] = 1
            probestimates[:,i] = A[:,i]
        pass
    
    assert(Y_prediction.shape == (1, m))
    
    return Y_prediction, probestimates


####################################################
# Plot distribution of the datasets
def plot_dataset_distrib(xtr, xva, xte, ytr, yva, yte):
    
    num_of_train_pos = ytr[ytr==1].sum()
    num_of_val_pos   = yva[yva==1].sum()
    num_of_test_pos  = yte[yte==1].sum()
    num_of_train_neg = len(ytr) -  ytr[ytr==1].sum()
    num_of_val_neg   = len(yva) -  yva[yva==1].sum()
    num_of_test_neg  = len(yte) -  yte[yte==1].sum()
    
    print("Training set has {} positive and {} negative labels".format(num_of_train_pos ,num_of_train_neg))
    print("Validation set has {} positive and {} negative labels".format(num_of_val_pos,num_of_val_neg))
    print("Test set has {} positive and {} negative labels".format(num_of_test_pos,num_of_test_neg))
    print('\n')
   
    fig = plt.figure(figsize=(18,6))
    ax1 = fig.add_subplot(131)
    ax2 = fig.add_subplot(132)
    ax3 = fig.add_subplot(133)

    Train = [num_of_train_pos, num_of_train_neg]
    Val   = [num_of_val_pos,   num_of_val_neg] 
    Test  = [num_of_test_pos,  num_of_test_neg]

    Labels = ['pos', 'Neg']
    Explode = [0,0.1]

    ax1.pie(Train, explode=Explode, labels=Labels,shadow=True,startangle=45,autopct='%1.2f%%');
    ax1.set_title('Train set label distribution',fontsize=20);

    ax2.pie(Val, explode=Explode, labels=Labels ,shadow=True,startangle=45,autopct='%1.2f%%');
    ax2.set_title('Validation set label distribution',fontsize=20);

    ax3.pie(Test, explode=Explode, labels=Labels, shadow=True,startangle=45,autopct='%1.2f%%');
    ax3.set_title('Test set label distribution',fontsize=20);
    
    plt.show()
    print('\n')
    print('\n')
    #############
     #############
    '''
    fig2 = plt.figure(figsize=(10,5))
    split_data = ['Training', 'Validation','Test']
    pos_label  = [num_of_train_pos, num_of_val_pos, num_of_test_pos]
    neg_label  = [num_of_train_neg, num_of_val_neg,num_of_test_neg]

    index = np.arange(3)
    width = 0.30

    plt.bar(index,pos_label, width, color='maroon', label='Positive Label')
    plt.bar(index+width,neg_label, width, color='grey', label='Negative Label')
    plt.title("Labels",fontsize=20)

    #plt.xlabel("Data",fontsize=20)
    plt.ylabel("Number of values",fontsize=20)

    plt.xticks(index+width/2, split_data)

    plt.legend(loc='best')

    plt.show()
   '''
 #########################################################
#Transpose all data
def transposeAll(xtr, xva, xte, ytr, yva, yte):
    ytr=ytr.T
    yva=yva.T
    yte=yte.T
    xtr=xtr.T
    xva=xva.T
    xte=xte.T
        
    return xtr, xva, xte, ytr, yva, yte
    
#########################################################
#Extract frequency count of features
def freqCount(readcodeList,Y):
    Z = np.zeros(len(readcodeList)) #create an array the length of X
    for k in range(len(readcodeList)): #Iterate through 
        count=0 # intialize container
        for i in Y: #iterate through the given example
            if readcodeList[k]==i: #if item in read code, increa
                count=count+1
                Z[k] = count
    return Z

###############################################################################
# Evaluation
    """
Created on Fri Jan 31 06:52:41 2020

@author: NN133
"""

def EvaluateTest(ylabel, Pred):
    
    ylabel =  np.asarray(ylabel/1.)
    Pred   =  np.asarray(Pred)
    
    Evaluation = {}
    FN,FP,TP,TN = 0,0,0,0
   
    for i in range(0,ylabel.shape[0]):
        if (ylabel[i]==Pred[i]).any():
            if (Pred[i]==1).any():
                TP+=1
            elif Pred[i]!=1:
                TN+=1
        if (ylabel[i]!=Pred[i]).any():
            if (Pred[i]==1).any():
                FP+=1
            elif Pred[i]!=1:
                FN+=1
    TOTAL = TP + TN + FP + FN
    TPN   = TP+ TN
    
    print("--> The total of {0} predicted with only {1} accurate predictions".format(TOTAL,TPN))
    print('')
    print('='*23)
    print('Ground Truth comparison')
    print('='*23)
    print('\033[90m')
    print('\033[90m' + "Actual label is True while we predicted True   -  " +'\033[92m'+ "True Positive  = ",format(TP))
    print('\033[90m' + "Actual label is False while we predicted False -  " +'\033[92m'+ "True Negatve   = ",format(TN))
    print('\033[90m' + "Actual label is False while we predicted True  -  " +'\033[91m'+ "False Positive = ",format(FP))
    print('\033[90m' + "Actual label is True while we predicted False  -  " +'\033[91m'+ "False Negative = ",format(FN))  
    print('') 
    #try:
    Pos        = TP+FP                                   # sum of TP and FP
    Neg        = TN+FN
    accu       = np.round(((TP+TN)/(TP+FN+FP+TN)*100),2)
    #sen        = TP/(TP+FN)  
    if (TP+FN) == 0:
        sen    = 0
        miss   = 0
        recall = 0
        print("No True positives or False negatives predicted")
        print("Sensitivity set to zero 0")
        print("Miss (false negative rate) set to 0")
        print("Recall value set to 0")
        print('='*45)
    else:
        sen    = np.round(TP/(TP+FN),2)      # true positive rate,sensitivity,recall
        miss   = np.round(FN/(TP+FN),2)      # false negative rate, miss
        recall = np.round(TP/(TP+FN),2)      # Recall describes the completeness of the classification
   
    if (TN + FP) == 0:
        spec = 0
        fall = 0
        print("No True positives or False negatves predicted")
        print("Specificity set to 0")
        print("Fallout (false positive rate) set to 0")
        print('='*45)
    else:
        spec   = np.round(TN/(TN+FP),2)     # true negative rate, specificity7
        fall   = np.round(FP/(TN+FP),2)     # false positive rate, fallout
    
    if (TN+FN) == 0:
        NPV = 0
        print("No Negative outcomes predicted")
        print("Negative predicted value set to 0")
        print('='*45)
    else:
        NPV        = np.round(TN/(TN+FN),2)                  # negative predictive value
     
    if (TP+FP) == 0:
        precision = 0
        print("No True positives or False positives predicted")
        print('='*45)
    else:
        precision  = np.round(TP/(TP+FP),2)                  # precision measures the actual accuracy of the classification
        
    RPP        = np.round((TP+FP)/(TP+FN+FP+TN),2)           # rate of positive predictions
    RNP        = np.round((TN+FN)/(TP+FN+FP+TN),2)           # rate of negative predictions
    
    if (precision + recall) == 0:
        Fscore = 0
        print("Fscore cannot be calculated as denominator is 0")
        print('='*45)
    else:
        Fscore = np.round(2 * ((precision * recall) / (precision + recall)),2)
    
    print('\033[94m') 
    print("--> {} positive outcomes predicted".format(Pos))
    print("--> {} negative outcomes predicted".format(Neg))
    print("--> An accuracy of {} % was achieved".format(accu))
    print("--> Sensitity of {} was achieved".format(sen))
    print("--> Specificity of {} was achieved ".format(spec))
    print("--> {} rate of positive prediction".format(RPP))
    print("--> {} rate of negative prediction".format(RNP))
    print("--> {} false negative rate was achieved".format(miss))
    print("--> {} false positve rate (fallout) was achieved".format(fall))
    print("--> Negative predictive value of {}".format(NPV))
    print("--> Recall value 0f {} achieved".format(recall))
    print("--> The precision vaue of {} achieved".format(precision))
    print("--> An Fscore of {} achieved".format(Fscore))
    
    
    confusion_mat = np.array([[TN, FP], [FN, TP]])
    
    
    plt.figure(figsize=(8,4))

    #plt.suptitle("Confusion Matrixes",fontsize=24)
    plt.title("Confusion Matrix",fontsize=24)
    plt.subplots_adjust(wspace = 0.1, hspace= 0.01)
    sns.heatmap(confusion_mat,annot=True,cmap="YlGnBu",fmt='.4g',cbar=True, annot_kws={"size":25})
    plt.xticks(fontsize=18)
    plt.yticks(fontsize=18)
    plt.show()
    
    Evaluation = {"Pos": Pos, "Neg": Neg, "Accu": accu,"Sen": sen,
                  "Spec": spec, "RPP": RPP, "RNP": RNP, "Miss": miss,
                  "Fall":fall, "NPV": NPV,"Recall":recall, "Precision":precision,
                  "Fscore":Fscore}
    
    return Evaluation
    
###############################################################################

# Compute ROC
"""
Created on Sat Feb  1 03:25:51 2020

@author: NN133
"""

def computeRoc(p_label, p_val):
    '''
    Computes Receiver Operating Characteristics (ROC) Area Under Curve (AUC)
    
    Input
    =====
    p_label =   predicted labels
    p_val   =   probability values for the predicted labels
    
    Output
    ======
    AUC value
    '''
    A =  p_val.copy()
    
    l2 = [p_val.index(x) for x in sorted(p_val,reverse=True) ]
    #c=[]
    Y=[]
    for i in l2:
        
        #c.append(A[i])
        Y.append(p_label[i])
    
    Y[Y==0]= -1
    Ya =np.asarray(Y)
    stack_x = np.cumsum(Ya == -1)/np.sum(Ya ==-1) 
    stack_y = np.cumsum(Ya == 1)/np.sum(Ya == 1) 
    L = len(Ya)
    
    auc = np.sum(np.multiply((stack_x[1:L]-stack_x[0:L-1]),(stack_y[1:L])))
    
    plt.plot(stack_x,stack_y)
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.title("ROC curve of AUC = {} ".format(round(auc, 2)))
    
    print("--> An AUC value of {} achieved".format(round(auc,2)))
    
    return auc

###############################################################################

def compute_Roc(pred_label, pred_val):
    '''
    Input
    =====
    pred_label: predicted label - values (0,1) - (ndarray)
    pred_val:   probability scores - (ndarray)
    
    Output
    ======
    auc: 
    '''
 
    
    pred_val = np.asarray(pred_val)
    index = np.argsort(np.squeeze(-pred_val))
    
    Y_pred_arranged = np.asarray(pred_label[:,index])
    L = Y_pred_arranged.shape[1]     
     
    if (np.sum(Y_pred_arranged == 0) == 0) | (np.sum(Y_pred_arranged == 1) == 0):
        auc = 0.5
    else:     
        stack_x = np.cumsum(Y_pred_arranged == 0)/np.sum(Y_pred_arranged == 0) 
        stack_y = np.cumsum(Y_pred_arranged == 1)/np.sum(Y_pred_arranged == 1) 
        
        auc = np.sum(np.multiply((stack_x[1:L] - stack_x[0:L-1]),(stack_y[1:L]))) 
    
        fig = plt.figure()
        fig.add_subplot(111)
        plt.plot(stack_x,stack_y)
        plt.plot([0, 1], [0, 1], 'k--')
        plt.xlabel('False Positive Rate')
        plt.ylabel('True Positive Rate')
        plt.title("ROC curve of AUC = {} ".format(round(auc, 2)))
        plt.show()
      
    print("--> An AUC value of {} achieved".format(round(auc, 2)))

###############################################################################