import yaml
from collections import OrderedDict

COMMANDS = ['depth', 'distrib', 'freq', 'map', 'process', 'signif', 'subset']
DATA_TYPES = ['samples', 'popmap', 'genome']
SINGLE_RUN_NAME = '_single_run'


def get_run(wildcards):
    '''
    '''
    try:
        return wildcards.run
    except AttributeError:
        return SINGLE_RUN_NAME


def populate_command_config(command, run):
    '''
    '''
    with open(config['default_settings_file']) as settings_file:
        defaults = yaml.safe_load(settings_file)
    if command not in config['runs'][run]:
        config['runs'][run]['commands'][command] = {}
    if defaults[command]:
        for setting, value in defaults[command].items():
            if setting in config['runs'][run]['run_settings']:  # First: check values obtained from the multi-runs file
                value = config['runs'][run]['run_settings'][setting]
            elif command in config['params'] and setting in config['params'][command]:  # Second: check the command-specific section of the config file
                value = config['params'][command][setting]
            elif setting in config['params']['general']:  # Last: check the general section of the config file
                value = config['params']['general'][setting]
            config['runs'][run]['commands'][command][setting] = value


def populate_analyses(run):
    '''
    '''
    value = []
    if 'analyses' in config['runs'][run]['run_settings']:
        value = config['runs'][run]['run_settings']['analyses'].split(',')
    elif 'analyses' in config:
        value = config['analyses']
    config['runs'][run]['analyses'] = value


def populate_data(run):
    '''
    '''
    for data in DATA_TYPES:
        value = None
        if data in config['runs'][run]['run_settings']:
            value = config['runs'][run]['run_settings'][data]
        elif data in config['data']:
            value = config['data'][data]
        config['runs'][run]['data'][data] = value


def update_config():
    '''
    '''
    for run in config['runs']:
        populate_data(run)
        populate_analyses(run)
        for command in COMMANDS:
            populate_command_config(command, run)


def load_runs():
    '''
    '''
    config['runs'] = {}
    if config['multi_runs_file']:
        with open(config['multi_runs_file']) as file:
            header = file.readline()[:-1].split('\t')
            for line in file:
                run_info = line[:-1].split('\t')
                config['runs'][run_info[0]] = {'run_settings': {setting: value for setting, value in zip(header, run_info) if value != ''},
                                               'commands': {}, 'data': {}, 'analyses': {}}
    else:
        config['runs'][SINGLE_RUN_NAME] = {'run_settings': {'id': None}, 'commands': {}, 'data': {}, 'analyses': {}}


def get_options(command, wildcards):
    '''
    '''
    run = get_run(wildcards)
    options = []
    for option, value in config['runs'][run]['commands'][command].items():
        if isinstance(value, bool):
            if value:
                options.append(f'--{option}')
        elif isinstance(value, list):
            value = ",".join(value)
            options.append(f'--{option} {value}')
        elif isinstance(value, dict):
            value = ",".join(value.values())
            options.append(f'--{option} {value}')
    return ' '.join(options)


def get_popmap(wildcards):
    '''
    '''
    run = get_run(wildcards)
    return config['runs'][run]['data']['popmap']


def get_genome(wildcards):
    '''
    '''
    run = get_run(wildcards)
    return config['runs'][run]['data']['genome']


def setup_config():
    '''
    '''
    load_runs()
    update_config()

    BENCHMARKS_DIR = config['benchmarks_dir']
    LOGS_DIR = config['logs_dir']
    RESULTS_DIR = config['results_dir']

    if not (SINGLE_RUN_NAME in config['runs'] and len(config['runs']) == 1):
        BENCHMARKS_DIR = os.path.join(BENCHMARKS_DIR, '{run}')
        LOGS_DIR = os.path.join(LOGS_DIR, '{run}')
        RESULTS_DIR = os.path.join(RESULTS_DIR, '{run}')

    return BENCHMARKS_DIR, LOGS_DIR, RESULTS_DIR


rule print_config:
    '''
    '''
    output:
        os.path.join(config['results_dir'], 'parameters.yaml')
    benchmark:
        os.path.join(config['benchmarks_dir'], 'print_config.tsv')
    log:
        os.path.join(config['logs_dir'], 'print_config.txt')
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
