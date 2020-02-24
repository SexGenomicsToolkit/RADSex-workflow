configfile: 'config.yaml'

include: 'rules/config.smk'

BENCHMARKS_DIR, LOGS_DIR, RESULTS_DIR = setup_config()

include: 'rules/utils.smk'
include: 'rules/radsex.smk'

ANALYSES = {'depth': rules.depth,
            'distrib': rules.distrib,
            'freq': rules.freq,
            'map': rules.map,
            'signif': rules.signif,
            'subset': rules.subset}


def get_targets(wildcards):
    '''
    '''
    targets = []
    for run in config['runs']:
        for analysis in config['runs'][run]['analyses']:
            if analysis in ANALYSES:
                output = ANALYSES[analysis].output[0]
                if run != SINGLE_RUN_NAME:
                    output = output.format(run=run)
                targets.append(output)
        output = rules.print_config.output[0]
        if run != SINGLE_RUN_NAME:
            output = output.format(run=run)
        targets.append(output)
    return targets


rule all:
    '''
    '''
    input:
        get_targets

