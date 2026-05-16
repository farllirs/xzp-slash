import os
import json
import sys

def load_commands():
    config_path = os.environ.get('COMMANDS_JSON')
    if not config_path:
        # Fallback for local dev if not sourced via slash-env.sh
        config_path = os.path.expanduser('~/xzp-slash/config/commands.json')
    
    if not os.path.exists(config_path):
        # Last resort fallback to standard global path
        config_path = '/etc/slash/commands.json'
        if not os.path.exists(config_path):
            # Termux global path
            config_path = '/data/data/com.termux/files/usr/etc/slash/commands.json'

    with open(config_path, 'r') as f:
        return json.load(f)

def get_context():
    context = ['termux']
    # Detección por Binarios
    tools = {
        'git': 'git',
        'node': 'npm',
        'python': 'python3',
        'rust': 'cargo',
        'cpp': 'g++',
        'docker': 'docker',
        'gh': 'gh'
    }
    for ctx, binary in tools.items():
        if os.system('command -v {} >/dev/null 2>&1'.format(binary)) == 0:
            context.append(ctx)
    
    # Marcadores de directorio (opcional/adicional)
    if os.path.exists('.git') and 'git' not in context:
        context.append('git')
        
    return list(set(context))

def main():
    data = load_commands()
    context = get_context()
    
    available = data['global'][:]
    for ctx in context:
        if ctx in data['contextual']:
            available.extend(data['contextual'][ctx])

    print("\033[1;36mxzp-slash \033[1;30m| \033[1;37mContexto detectado: {}\033[0m".format(", ".join(context) if context else "General"))
    print("\033[1;30m" + "-"*50 + "\033[0m")
    
    for i, item in enumerate(available):
        print("\033[1;32m{:2d}. \033[1;37m{:20} \033[1;30m# {}\033[0m".format(i+1, item['cmd'], item['desc']))
    
    print("\033[1;30m" + "-"*50 + "\033[0m")
    try:
        choice = input("\033[1;34mSelecciona un comando (número) o escribe '/' para buscar: \033[0m")
        if choice.isdigit():
            idx = int(choice) - 1
            if 0 <= idx < len(available):
                os.system(available[idx]['cmd'])
    except KeyboardInterrupt:
        print("\nAborted.")

if __name__ == "__main__":
    main()
