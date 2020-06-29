# ╔══════════════════════════════════════════════════════════════════════════════════════════════╗ #
# ║                             oooooooooo.                                                      ║ #
# ║                             `888'   `Y8b                                                     ║ #
# ║                              888     888  .ooooo.  oooo    ooo                               ║ #
# ║                              888oooo888' d88' `88b  `88b..8P'                                ║ #
# ║                              888    `88b 888   888    Y888'                                  ║ #
# ║                              888    .88P 888   888  .o8"'88b                                 ║ #
# ║                             o888bood8P'  `Y8bod8P' o88'   888o                               ║ #
# ║   .oooooo.                                                           .                       ║ #
# ║  d8P'  `Y8b                                                        .o8                       ║ #
# ║ 888            .ooooo.  ooo. .oo.    .ooooo.  oooo d8b  .oooo.   .o888oo  .ooooo.  oooo d8b  ║ #
# ║ 888           d88' `88b `888P"Y88b  d88' `88b `888""8P `P  )88b    888   d88' `88b `888""8P  ║ #
# ║ 888     ooooo 888ooo888  888   888  888ooo888  888      .oP"888    888   888   888  888      ║ #
# ║ `88.    .88'  888    .o  888   888  888    .o  888     d8(  888    888 . 888   888  888      ║ #
# ║  `Y8bood8P'   `Y8bod8P' o888o o888o `Y8bod8P' d888b    `Y888""8o   "888" `Y8bod8P' d888b     ║ #
# ║                                                                                              ║ #
# ║                                      Created by datwaft                                      ║ #
# ╚══════════════════════════════════════════════════════════════════════════════════════════════╝ #

import json
import sys
import argparse

data = json.load(open(".box-generator-data.json"))
chrabbr = data["charset-abbreviations"]
dirabbr = data["charset-direction-abbreviations"]

def line_generator(string, number, width, charset_selector, language):
    """
    Generates a line.
    Parameters:
        string: is the string that will be contained in the line.
        number: is the type of line that will be generated.
                e.g. "1th", "nth" and "lst"
        width: is the width of the result.
        charset_selector: is the charset used for the result.
        language: is the delimiter chooser.
    """
    delimiters = data["delimiters"][language]["delimiters"]
    charset = data['charset'][chrabbr[charset_selector]]
    delimiter_type = data["delimiters"][language]["type"]
    delimiter_length = len(max(delimiters.values(), key = len))
    string_length = width - delimiter_length*2 - 4
    if delimiter_type == "simple":
        left = f"{delimiters['left'].ljust(delimiter_length)} "
        right = f" {delimiters['right'].ljust(delimiter_length)}"
    elif delimiter_type == "complex":
        left = f"{delimiters[number + '-left'].ljust(delimiter_length)} "
        right = f" {delimiters[number + '-right'].ljust(delimiter_length)}"
    if number == "1st":
        left += f"{charset[dirabbr['ul']]}"
        right = f"{charset[dirabbr['ur']]}" + right
        center = charset[dirabbr['h']] * string_length
    elif number == "nth":
        left += f"{charset[dirabbr['v']]}"
        right = f"{charset[dirabbr['v']]}" + right
        center = string.center(string_length)
    elif number == "lst":
        left += f"{charset[dirabbr['ll']]}"
        right = f"{charset[dirabbr['lr']]}" + right
        center = charset[dirabbr['h']] * string_length
    return f"{left}{center}{right}"

def title_generator(string, width, charset_selector, language):
    result = ""
    for line in string.split('\n'):
        result += line_generator(None, "1st", width, charset_selector, language) + "\n"
        result += line_generator(line, "nth", width, charset_selector, language) + "\n"
        result += line_generator(None, "lst", width, charset_selector, language) + "\n"
    return result

def banner_generator(string, width, charset_selector, language, font):
    result = ""
    try:
        from pyfiglet import Figlet
        delimiters = data["delimiters"][language]["delimiters"]
        delimiter_length = len(max(delimiters.values(), key = len))
        figlet = Figlet(font=font, width=width-delimiter_length*2-4)
        figlet_processed_string = figlet.renderText(string)
    except:
        raise SystemError('Please install pyfiglet. e.g. "pip3 install pyfiglet"')
    result += line_generator(None, "1st", width, charset_selector, language) + "\n"
    result += line_generator("", "nth", width, charset_selector, language) + "\n"
    for line in figlet_processed_string.split('\n')[:-1]:
        result += line_generator(line, "nth", width, charset_selector, language) + "\n"
    result += line_generator(None, "lst", width, charset_selector, language) + "\n"
    return result

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Generates a centered title')
    parser.add_argument('string', metavar='string', type=str, nargs='?',
        help='the string used to generate the title')
    parser.add_argument('-w', dest='width', type=int, default=80,
        help='the width of the title, defaults to \'80\'')
    parser.add_argument('-l', dest='language', type=str, default='vim', choices=data["delimiters"],
        help='the language for the delimiters, defaults to \'vim\'')
    parser.add_argument('-t', dest='type', type=str, default='t', choices=chrabbr,
        help='the type of the box, defaults to \'t\'')
    parser.add_argument('-b', action='store_true',
        help='the flag means it is going to use figlet for the banner')
    parser.add_argument('-f', dest='font', type=str, default='roman',
        help='font for figlet, defaults to \'roman\'')
    args = parser.parse_args()
    string = args.string
    if not string:
        string = ""
        for line in sys.stdin:
            string += line
    string = string.strip()
    width = args.width
    font = args.font
    language = args.language
    charset_selector = args.type
    if args.b:
        print(banner_generator(string, width, charset_selector, language, font))
    else:
        print(title_generator(string, width, charset_selector, language))
