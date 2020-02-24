configfile: 'config.yaml'

include: 'rules/utils.smk'
include: 'rules/radsex.smk'

ANALYSES = {'depth': rules.depth,
            'distrib': rules.distrib,
            'freq': rules.freq,
            'map': rules.map,
            'signif': rules.signif,
            'subset': rules.subset}


def get_analyses(wildcards):
    '''
    '''
    targets = {}
    for analysis in config['analyses']:
        if analysis in ANALYSES:
            targets[analysis] = ANALYSES[analysis].output
    return targets


rule all:
    '''
    '''
    input:
        unpack(get_analyses)

