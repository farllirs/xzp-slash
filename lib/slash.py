import os
import json
import subprocess

def get_env():
    is_termux = os.path.exists("/data/data/com.termux") or "TERMUX_VERSION" in os.environ
    prefix = os.environ.get("PREFIX", "/data/data/com.termux/files/usr" if is_termux else "/usr")
    return is_termux, prefix

def load_config():
    is_termux, prefix = get_env()
    user_config = os.path.expanduser("~/.config/slash/settings.json")
    global_config = os.path.join(prefix, "etc/slash/settings.json") if is_termux else "/etc/slash/settings.json"
    
    config_path = user_config if os.path.exists(user_config) else global_config
    if os.path.exists(config_path):
        with open(config_path, 'r') as f:
            return json.load(f)
    return {}

def get_context():
    is_termux, _ = get_env()
    contexts = ["termux"] if is_termux else ["linux"]
    
    # Check for common tools
    tools = {
        "git": "git",
        "npm": "node",
        "python3": "python",
        "cargo": "rust",
        "gh": "github"
    }
    
    for bin_name, ctx in tools.items():
        if subprocess.call(["command", "-v", bin_name], shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL) == 0:
            contexts.append(ctx)
            
    if os.path.exists(".git"):
        contexts.append("git")
        
    return contexts

if __name__ == "__main__":
    print(f"Contexts: {get_context()}")
