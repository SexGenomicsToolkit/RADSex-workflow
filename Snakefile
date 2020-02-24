configfile: 'config.yaml'

rule process:
    input:
        directory(config['data']['samples'])
    output:
        'results/markers_table.tsv'
    benchmark:
        'benchmarks/process.tsv'
    log:
        'logs/process.txt'
    threads:
        config['resources']['process']['threads']
    params:
        min_depth = params['process_min_depth']
    shell:
        'radsex process -T {threads} -i {input} -o {output} -d {params.process_min_depth} 2> {log}'
