rule process:
    '''
    '''
    input:
        config['data']['samples']
    output:
        'results/markers_table.tsv'
    benchmark:
        'benchmarks/process.tsv'
    log:
        'logs/process.txt'
    threads:
        config['resources']['process']['threads']
    params:
        min_depth = config['params']['process']['min-depth']
    shell:
        'radsex process '
        '--threads {threads} '
        '--input-dir {input} '
        '--output-file {output} '
        '--min-depth {params.min_depth} '
        '2> {log}'


rule depth:
    '''
    '''
    input:
        markers_table = rules.process.output,
        popmap = config['data']['popmap']
    output:
        'results/depth.tsv'
    benchmark:
        'benchmarks/depth.tsv'
    log:
        'logs/depth.txt'
    shell:
        'radsex depth '
        '--markers-table {input.markers_table} '
        '--popmap {input.popmap} '
        '--output-file {output} '
        '2> {log}'


rule distrib:
    '''
    '''
    input:
        markers_table = rules.process.output,
        popmap = config['data']['popmap']
    output:
        'results/distrib.tsv'
    benchmark:
        'benchmarks/distrib.tsv'
    log:
        'logs/distrib.txt'
    params:
        options = get_options('distrib')
    shell:
        'radsex distrib '
        '--markers-table {input.markers_table} '
        '--popmap {input.popmap} '
        '--output-file {output} '
        '{params.options} '
        '2> {log}'


rule freq:
    '''
    '''
    input:
        markers_table = rules.process.output
    output:
        'results/freq.tsv'
    benchmark:
        'benchmarks/freq.tsv'
    log:
        'logs/freq.txt'
    params:
        options = get_options('freq')
    shell:
        'radsex freq '
        '--markers-table {input.markers_table} '
        '--output-file {output} '
        '{params.options} '
        '2> {log}'


rule map:
    '''
    '''
    input:
        markers_table = rules.process.output,
        popmap = config['data']['popmap'],
        genome = config['data']['genome']
    output:
        'results/map.tsv'
    benchmark:
        'benchmarks/map.tsv'
    log:
        'logs/map.txt'
    params:
        options = get_options('map')
    shell:
        'radsex map '
        '--markers-file {input.markers_table} '
        '--genome-file {input.genome} '
        '--popmap {input.popmap} '
        '--output-file {output} '
        '{params.options} '
        '2> {log}'


rule signif:
    '''
    '''
    input:
        markers_table = rules.process.output,
        popmap = config['data']['popmap']
    output:
        'results/signif.tsv'
    benchmark:
        'benchmarks/signif.tsv'
    log:
        'logs/signif.txt'
    params:
        options = get_options('signif')
    shell:
        'radsex signif '
        '--markers-table {input.markers_table} '
        '--popmap {input.popmap} '
        '--output-file {output} '
        '{params.options} '
        '2> {log}'


rule subset:
    '''
    '''
    input:
        markers_table = rules.process.output,
        popmap = config['data']['popmap']
    output:
        'results/subset.tsv'
    benchmark:
        'benchmarks/subset.tsv'
    log:
        'logs/subset.txt'
    params:
        options = get_options('subset')
    shell:
        'radsex subset '
        '--markers-table {input.markers_table} '
        '--popmap {input.popmap} '
        '--output-file {output} '
        '{params.options} '
        '2> {log}'
