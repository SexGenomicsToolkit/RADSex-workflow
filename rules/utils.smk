import yaml

COMMANDS = ['distrib', 'freq', 'map', 'process', 'signif', 'subset']


def populate_command_config(command):
    '''
    '''
    with open(config['default_settings_file']) as settings_file:
        defaults = yaml.safe_load(settings_file)
    if command not in config:
        config[command] = {}
    for setting, value in defaults[command].items():
        config[command][setting] = value


def update_config():
    '''
    '''
    for command in COMMANDS:
        populate_command_config(command)
        if 'general' in config['params']:
            for setting, value in config['params']['general'].items():
                if setting in config[command]:
                    config[command][setting] = value
        if command in config['params']:
            for setting, value in config['params'][command].items():
                config[command][setting] = value


def get_options(command):
    '''
    '''
    options = []
    for option, value in config[command].items():
        if isinstance(value, bool):
            if value:
                options.append(f'--{option}')
        elif value:
            try:
                value = ",".join(value)
            except TypeError:
                value = value
            options.append(f'--{option} {value}')
    return ' '.join(options)


# Run update_config function to create config for each analysis
update_config()
