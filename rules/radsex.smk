rule process:
    '''
    '''
    input:
        config['data']['samples']
    output:
        os.path.join(config['results_dir'], 'markers_table.tsv')
    benchmark:
        os.path.join(config['benchmarks_dir'], 'process.tsv')
    log:
        os.path.join(config['logs_dir'], 'process.txt')
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
        popmap = get_popmap
    output:
        os.path.join(RESULTS_DIR, 'depth.tsv')
    benchmark:
        os.path.join(BENCHMARKS_DIR, 'depth.tsv')
    log:
        os.path.join(LOGS_DIR, 'depth.txt')
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
        popmap = get_popmap
    output:
        os.path.join(RESULTS_DIR, 'distrib.tsv')
    benchmark:
        os.path.join(BENCHMARKS_DIR, 'distrib.tsv')
    log:
        os.path.join(LOGS_DIR, 'distrib.txt')
    params:
        options = lambda wildcards: get_options('distrib', wildcards)
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
        os.path.join(RESULTS_DIR, 'freq.tsv')
    benchmark:
        os.path.join(BENCHMARKS_DIR, 'freq.tsv')
    log:
        os.path.join(LOGS_DIR, 'freq.txt')
    params:
        options = lambda wildcards: get_options('freq', wildcards)
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
        popmap = get_popmap,
        genome = get_genome
    output:
        os.path.join(RESULTS_DIR, 'map.tsv')
    benchmark:
        os.path.join(BENCHMARKS_DIR, 'map.tsv')
    log:
        os.path.join(LOGS_DIR, 'map.txt')
    params:
        options = lambda wildcards: get_options('map', wildcards)
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
        popmap = get_popmap
    output:
        os.path.join(RESULTS_DIR, 'signif.tsv')
    benchmark:
        os.path.join(BENCHMARKS_DIR, 'signif.tsv')
    log:
        os.path.join(LOGS_DIR, 'signif.txt')
    params:
        options = lambda wildcards: get_options('signif', wildcards)
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
        popmap = get_popmap
    output:
        os.path.join(RESULTS_DIR, 'subset.tsv')
    benchmark:
        os.path.join(BENCHMARKS_DIR, 'subset.tsv')
    log:
        os.path.join(LOGS_DIR, 'subset.txt')
    params:
        options = lambda wildcards: get_options('subset', wildcards)
    shell:
        'radsex subset '
        '--markers-table {input.markers_table} '
        '--popmap {input.popmap} '
        '--output-file {output} '
        '{params.options} '
        '2> {log}'
