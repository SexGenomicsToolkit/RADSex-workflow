rule print_config:
    '''
    '''
    output:
        os.path.join(RESULTS_DIR, 'parameters.yaml')
    benchmark:
        os.path.join(BENCHMARKS_DIR, 'print_config.tsv')
    log:
        os.path.join(LOGS_DIR, 'print_config.txt')
    params:
        run = lambda wildcards: get_run(wildcards)
    run:
        represent_dict_order = lambda self, data: self.represent_mapping('tag:yaml.org,2002:map', data.items())
        yaml
        cfg = OrderedDict()
        for k in ['data', 'analyses', 'commands']:
            cfg[k] = config['runs'][params.run][k]
        dumper = yaml.dumper.SafeDumper
        dumper.ignore_aliases = lambda *args : True
        dumper.add_representer(OrderedDict, represent_dict_order)
        with open(output[0], 'w') as output_file:
            yaml.dump(cfg, output_file, indent=4,
                      default_flow_style=False, Dumper=dumper)
