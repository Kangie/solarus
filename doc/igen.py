from time import perf_counter
import datetime
import json
import re

api_root_dir = "docs/lua-api" # The local directory where the lua API reference is stored.
api_root_url = "https://docs.solarus-games.org/lua-api" # The URL where the lua API reference is hosted.
start_time = "" # Will be initialized later with the current timestamp.
logger = None # Will be initialized later with the Logger class.

class Logger:
    """
    Provides methods to print colored messages with the current date and time.
    """

    def info(self, message, end="\r\n"):
        """Print an info message in blue with the current date and time.

        Args:
            message (str): The message to print.
            end (str): End character of the print.
        """

        date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print(f"[\033[34mINFO\033[0m] \u001b[90m{date}\033[0m - {message}", end=end)

    def warn(self, message):
        """Print a warning message in orange with the current date and time.

        Args:
            message (str): The message to print.
        """

        date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print(f"[\033[33mWARN\033[0m] \u001b[90m{date}\033[0m - {message}")
    
    def error(self, message):
        """Print an error message in red with the current date and time.

        Args:
            message (str): The message to print.
        """

        date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print(f"[\033[31mERROR\033[0m] \u001b[90m{date}\033[0m - {message}")

def generate_properties(section):
    """Generate a list of table properties.

    Args:
        section (str): Argument or Return value section.

    Returns:
        list: Array of properties.
    """

    properties_section = re.findall(r'\n\n    (`\w+`.*?)(?=\n\n[^\s]|$)', section, re.DOTALL)
    properties = []

    if len(properties_section) > 0:
        properties_section = properties_section[0].replace("    `", "`").replace("\n    ", "\n")
        properties = generate_args(properties_section)
    
    return properties

def generate_values(section):
    """Generate a list of possible values for a type.

    Args:
        section (str): Argument or Return value section.

    Returns:
        list: Array of possible values.
    """

    values_section = re.findall(r'\n\n    (\- `.*?)(?=\n\n|$)', section, re.DOTALL)
    values = []

    if len(values_section) > 0:
        values_section = values_section[0].split("\n    ")

        for value_section in values_section:
            value_name = re.findall(r'\- `(.*?)`', value_section)[0].replace('"', "")
            value_desc = re.findall(r': (.*?)\n', value_section)

            default_value = re.findall(r'` \(default\): ', value_section)
            default_value = len(default_value) > 0

            if len(value_desc) > 0:
                value_desc = value_desc[0]
            else:
                value_desc = ""

            values.append({"name": value_name, "desc": value_desc, "default": default_value})

    return values

def generate_returns(section):
    """Generate a list of member return values.

    Args:
        section (str): Member section.

    Returns:
        list: Array of member return values.
    """

    returns = []
    returns_section = re.findall(r'\n\n(Return value .*?)(?=\n\nR|\n\n#|$)', section, re.DOTALL)
    
    for return_section in returns_section:
        return_details = re.findall(rf'Return value .*?\((.*?)\)\n', return_section)[0]
        return_types = re.sub(r'\]\(.*?\)', "", return_details.replace("[", "")).split(" or ")
        return_desc = re.findall(r'\n\: (.*?)(?=\n\n|$)', return_section, re.DOTALL)[0]

        if return_desc.endswith(":"):
            return_desc = re.sub(r'\. .*?:$', ".", return_desc)

        for return_type in return_types:
            return_types[return_types.index(return_type)] = return_type.replace("`", "").replace(" ", "_")

        returns.append({"types": return_types, "desc": return_desc, "values": generate_values(return_section), "properties": generate_properties(return_section)})

    return returns

def generate_args(section):
    """Generate a list of member arguments.

    Args:
        section (str): Member section.

    Returns:
        list: Array of member arguments.
    """

    args = []
    args_section = re.findall(r'\n\n(`\w+`.*?)(?=\n\n[^\s]|!!! |$)', section, re.DOTALL)
    
    for arg_section in args_section:
        arg_name = re.findall(r'`(\w+)`', arg_section)[0]
        arg_desc = re.findall(r'\n\: (.*?)(?=\n\n|$)', arg_section, re.DOTALL)[0]
        arg_details = re.findall(rf'`{arg_name}` \((.*?)\)\n', arg_section)[0].split(", ")
        arg_default_value = ""
        arg_requirements = []
        arg_types = []

        optionnal_arg = False
        deprecated_arg = ""

        if arg_desc.endswith(":"):
            arg_desc = re.sub(r'\. .*?:$', ".", arg_desc)

        for detail in arg_details:
            if detail == "optional":
                optionnal_arg = True
            elif detail.startswith("deprecated: "):
                deprecated_arg = detail.replace("deprecated: ", "").replace("`", "")
            elif detail.startswith("default: "):
                arg_default_value = detail.replace("default: ", "").replace("`", "").replace('"', "")
            elif detail.startswith("requires: "):
                arg_requirements = detail.replace("requires: ", "").replace("`", "").split(" and ")
            else:
                arg_types = re.sub(r'\]\(.*?\)', "", detail.replace("[", "")).replace("`", "").split(" or ")

        args.append({"name": arg_name, "desc": arg_desc, "optionnal": optionnal_arg, "deprecated": deprecated_arg, "requires": arg_requirements, "types": arg_types, "default": arg_default_value, "values": generate_values(arg_section), "properties": generate_properties(arg_section)})

    return args

def generate_deprecated(section):
    """Generate the deprecated version of a member.

    Args:
        section (str): Member section.

    Returns:
        string: Deprecated version of the member or "" if not deprecated.
    """

    deprecated = {"version": "", "message": ""}
    deprecated_section = re.findall(r'\n\n!!! warning "Deprecated"\n\n(.*?)(?=\n\n#|$)', section, re.DOTALL)

    if len(deprecated_section) > 0:
        deprecated['version'] = re.findall(r'This .*? is deprecated since Solarus (.*?)(?=\. |\.\n)', deprecated_section[0])[0]
        deprecated['message'] = re.findall(r'(This .*? is deprecated since Solarus .*?$)', deprecated_section[0], re.DOTALL)[0]

    return deprecated

def generate_members(feature, member_type):
    """Generate a list of feature members.

    Args:
        feature (str): Name of the feature.
        member_type (str): Type of the feature members. Can be "functions", "deprecated_functions", "methods", "deprecated_methods", "events", or "deprecated_events".

    Returns:
        list: Array of feature members.
    """

    member_type = member_type.replace("_", " ").capitalize()
    members = []

    with open(f"{api_root_dir}{feature['path']}.md", 'r', encoding='utf-8') as file:
        content = file.read()

        members_section = re.findall(rf'(## {member_type} of .*?(?=\n## |$))', content, re.DOTALL)

        if len(members_section) <= 0: return []

        members_section = re.findall(rf'(### `(?:sol\.)?{feature["name"]}.*?`\n\n.*?(?=\n### |$))', members_section[0], re.DOTALL)
        
        for member_section in members_section:
            member_name = re.findall(rf'### `((?:sol\.)?{feature["name"]}(.*?))\(', member_section)[0][0]
            member_desc = re.findall(rf'### `.*?`\n\n(.*?)(?=\n\n`\w+`|\n\n\|.*?<dl>|\n\nReturn value|\n\n!!! |$)', member_section, re.DOTALL)[0]
            
            members.append({"name": member_name, "desc": member_desc, "deprecated": generate_deprecated(member_section), "args": generate_args(member_section), "returns": generate_returns(member_section)})

    return members

def generate_features(content):
    """Generate a list of features from a section of the MkDocs configuration file.

    Args:
        content (str): Section of the MkDocs configuration file.
    
    Returns:
        list: Array of features.
    """

    features_list = content.replace("  ", "").split("\n- ")
    features = []

    for feature in features_list:
        feature_infos = feature.split(": ")

        if len(feature_infos) != 2: 
            if not feature_infos[0].startswith("lua-api"): continue

            feature_infos = feature_infos[0].split(" # ")

            if len(feature_infos) != 2: continue
        else:
            feature_infos = feature_infos[1].split(" # ")
        
        feature_path = feature_infos[0].replace("lua-api", "").replace(".md", "")

        if len(feature_infos) != 2:
            feature_name = feature.split(": ")[0].lower().replace(" ", "_")
            feature_desc = ""
        else:
            feature_infos = feature_infos[1].split("] ")
            feature_name = feature_infos[0].replace("[", "")
            feature_desc = feature_infos[1] if len(feature_infos) == 2 else ""

        feature_inherits = ""

        with open(f"{api_root_dir}{feature_path}.md", 'r', encoding='utf-8') as file:
            feature_content = file.read()
            inherits_section = re.findall(rf'## .* Inherited from `(.*?)`', feature_content)

            if len(inherits_section) > 0:
                feature_inherits = inherits_section[0]

        features.append({"name": feature_name, "path": feature_path, "description": feature_desc, "inherits": feature_inherits, "functions": [], "methods": [], "events": []})

    return features

def generate_index_file(conf_file, output_file):
    """Generate the index file for the Lua API Reference.

    Args:
        conf_file (str): The path to the MkDocs configuration file (mkdocs.yml).
        output_file (str): The path to the output file to write the index to.
    """

    output_content = {
        "root": {
            "local": api_root_dir,
            "public": api_root_url,
            "docs_type": "markdown"
        },
        "features": []
    }

    features = []
    count = 0

    with open(conf_file, 'r') as file:
        content = file.read()
        pattern = r'\s\s- Lua API:.*?\n\s\s- '
        match = re.search(pattern, content, re.DOTALL)

        if match:
            api_section = match.group(0).replace("\n  - ", "")
            features = generate_features(api_section)

    for feature in features:
        count = count + 1

        feature['functions'] = generate_members(feature, "functions")
        feature['methods'] = generate_members(feature, "methods")
        feature['events'] = generate_members(feature, "events")

        feature['functions'] += generate_members(feature, "deprecated_functions")
        feature['methods'] += generate_members(feature, "deprecated_methods")
        feature['events'] += generate_members(feature, "deprecated_events")

        logger.info(f"Generated feature {count}/{len(features)}", "\r")

    logger.info(f"Generated feature {count}/{len(features)}")

    output_content['features'] = features
    
    with open(output_file, 'w') as file:
        json.dump(output_content, file, indent=4)

    logger.info(f"Generated index file successfully in {perf_counter() - start_time:.2f}s !")

# Initialize variables and generate the index file.
if __name__ == "__main__":
    logger = Logger()
    start_time = perf_counter()
    mkdocs_file = "mkdocs.yml"
    output_file = "public/lua-api/index.json"
    
    logger.info("Generating index file...")
    generate_index_file(mkdocs_file, output_file)