import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import hddm
from scipy.stats import pearsonr

def combine_data(fits,data,task1,task2):
    subs = fits['subj']
    behavior = {'subject':[],
                '%s_RT'%(task1):[],'%s_RT'%(task2):[],
                '%s_ACC'%(task1):[],'%s_ACC'%(task2):[],
                '%s_a'%(task1):[],'%s_a'%(task2):[],
                '%s_v'%(task1):[],'%s_v'%(task2):[],
                '%s_t'%(task1):[],'%s_t'%(task2):[]}
    for sub in subs:
        task1_rt = data[(data['subj_idx'] == sub) & (data['task'] == task1)]['rt'].mean()
        task2_rt = data[(data['subj_idx'] == sub) & (data['task'] == task2)]['rt'].mean()
        behavior['%s_RT'%(task1)].append(task1_rt)
        behavior['%s_RT'%(task2)].append(task2_rt)

        task1_acc = data[(data['subj_idx'] == sub) & (data['task'] == task1)]['response'].mean()
        task2_acc = data[(data['subj_idx'] == sub) & (data['task'] == task2)]['response'].mean()
        behavior['%s_ACC'%(task1)].append(task1_acc)
        behavior['%s_ACC'%(task2)].append(task2_acc)

        behavior['%s_a'%(task1)].append(float(fits[fits['subj'] == sub]['%s_a'%(task1)]))
        behavior['%s_a'%(task2)].append(float(fits[fits['subj'] == sub]['%s_a'%(task2)]))
        behavior['%s_v'%(task1)].append(float(fits[fits['subj'] == sub]['%s_v'%(task1)]))
        behavior['%s_v'%(task2)].append(float(fits[fits['subj'] == sub]['%s_v'%(task2)]))
        behavior['%s_t'%(task1)].append(float(fits[fits['subj'] == sub]['%s_t'%(task1)]))
        behavior['%s_t'%(task2)].append(float(fits[fits['subj'] == sub]['%s_t'%(task2)]))

        behavior['subject'].append(sub)
    df = pd.DataFrame.from_dict(behavior)
    return df

def ddm_sanity_check(df,task_1,task_2):
    if (pearsonr(df['%s_v'%(task_1)],df['%s_RT'%(task_1)])[0] < 0
            and pearsonr(df['%s_v'%(task_1)],df['%s_RT'%(task_1)])[1] <= 0.05):
        print 'Sane! RT negatively correlates with Drift Rate for %s'%(task_1)
    else:
        print 'Not sane. RT should negatively correlate with %s_v. Instead: %s'%(task_1,pearsonr(df['%s_v'%(task_1)],df['%s_RT'%(task_1)]))
    if (pearsonr(df['%s_v'%(task_1)],df['%s_ACC'%(task_1)])[0] > 0
            and pearsonr(df['%s_v'%(task_1)],df['%s_ACC'%(task_1)])[1] <= 0.05):
        print 'Sane! ACC positively correlates with Drift Rate for %s'%(task_1)
    else:
        print 'Not sane. ACC should positively correlate with %s_v. Instead: %s'%(task_1,pearsonr(df['%s_v'%(task_1)],df['%s_ACC'%(task_1)]))
    if (pearsonr(df['%s_v'%(task_2)],df['%s_RT'%(task_2)])[0] < 0
            and pearsonr(df['%s_v'%(task_2)],df['%s_RT'%(task_2)])[1] <= 0.05):
        print 'Sane! RT negatively correlates with Drift Rate for %s'%(task_2)
    else:
        print 'Not sane. RT should negatively %s_v. Instead: %s'%(task_2,pearsonr(df['%s_v'%(task_2)],df['%s_RT'%(task_2)]))
    if (pearsonr(df['%s_v'%(task_2)],df['%s_ACC'%(task_2)])[0] > 0
            and pearsonr(df['%s_v'%(task_2)],df['%s_ACC'%(task_2)])[1] <= 0.05):
        print 'Sane! ACC positively correlates with Drift Rate for %s'%(task_2)
    else:
        print 'Not sane. ACC should positively correlate with %s_v. Instead: %s'%(task_2,pearsonr(df['%s_v'%(task_2)],df['%s_ACC'%(task_2)]))

    if (pearsonr(df['%s_a'%(task_1)],df['%s_RT'%(task_1)])[0] > 0
            and pearsonr(df['%s_a'%(task_1)],df['%s_RT'%(task_1)])[1] <= 0.05):
        print 'Sane! RT positively correlates with Threshold for %s'%(task_1)
    else:
        print 'Not sane. RT should positively with %s_a. Instead: %s'%(task_1,pearsonr(df['%s_a'%(task_1)],df['%s_RT'%(task_1)]))
    if (pearsonr(df['%s_a'%(task_1)],df['%s_ACC'%(task_1)])[0] > 0
            and pearsonr(df['%s_a'%(task_1)],df['%s_ACC'%(task_1)])[1] <= 0.05):
        print 'Sane! ACC positively correlates with Threshold for %s'%(task_1)
    else:
        print 'Not sane. ACC should positively correlate with %s_a. Instead: %s'%(task_1,pearsonr(df['%s_a'%(task_1)],df['%s_ACC'%(task_1)]))
    if (pearsonr(df['%s_a'%(task_2)],df['%s_RT'%(task_2)])[0] > 0
            and pearsonr(df['%s_a'%(task_2)],df['%s_RT'%(task_2)])[1] <= 0.05):
        print 'Sane! RT positively correlates with Threshold for %s'%(task_2)
    else:
        print 'Not sane. RT should positively correlate with %s_a. Instead: %s'%(task_2,pearsonr(df['%s_a'%(task_2)],df['%s_RT'%(task_2)]))
    if (pearsonr(df['%s_a'%(task_2)],df['%s_ACC'%(task_2)])[0] > 0
            and pearsonr(df['%s_a'%(task_2)],df['%s_ACC'%(task_2)])[1] <= 0.05):
        print 'Sane! ACC positively correlates with Threshold for %s'%(task_2)
    else:
        print 'Not sane. ACC should positively correlate with %s_a. Instead: %s'%(task_2,pearsonr(df['%s_a'%(task_2)],df['%s_ACC'%(task_2)]))

    if (pearsonr(df['%s_t'%(task_1)],df['%s_RT'%(task_1)])[0] > 0
            and pearsonr(df['%s_t'%(task_1)],df['%s_RT'%(task_1)])[1] <= 0.05):
        print 'Sane! RT positively correlates with NDTime for %s'%(task_1)
    else:
        print 'Not sane. RT should positively correlate with %s_t. Instead: %s'%(task_1,pearsonr(df['%s_t'%(task_1)],df['%s_RT'%(task_1)]))
    if (pearsonr(df['%s_t'%(task_1)],df['%s_ACC'%(task_1)])[1] > 0.05):
        print 'Sane! ACC does not correlate with NDTime for %s'%(task_1)
    else:
        print 'Not sane. ACC should not correlate with %s_t. Instead: %s'%(task_1,pearsonr(df['%s_t'%(task_1)],df['%s_ACC'%(task_1)]))
    if (pearsonr(df['%s_t'%(task_2)],df['%s_RT'%(task_2)])[0] > 0
            and pearsonr(df['%s_t'%(task_2)],df['%s_RT'%(task_2)])[1] <= 0.05):
        print 'Sane! RT positively correlates with NDTime for %s'%(task_2)
    else:
        print 'Not sane. RT should positively correlate with %s_t. Instead: %s'%(task_2,pearsonr(df['%s_t'%(task_2)],df['%s_RT'%(task_2)]))
    if (pearsonr(df['%s_t'%(task_2)],df['%s_ACC'%(task_2)])[1] > 0.05):
        print 'Sane! ACC does not correlate with NDTime for %s'%(task_2)
    else:
        print 'Not sane. ACC should not correlate with %s_t. Instead: %s'%(task_2,pearsonr(df['%s_t'%(task_2)],df['%s_ACC'%(task_2)]))
