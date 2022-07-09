import tlib, strutils, strformat

const
    red* = tlib.rgb(255,33,81)
    green* = tlib.rgb(37,255,100)
    yellow* = tlib.rgb(246,255,69)
    blue* = tlib.rgb(105,74,255)
    dft* = def()

var
    help_menu* = &"""
{red}SWIRLINSTALL{dft} version {blue}0.0.1{dft}
{red}SWIRLINSTALL{dft} is an installer for the {blue}Swirl{dft} programming language (made for dumb people).

{red}USAGE{dft}:
    SWIRLINSTALL [OPTIONS] [ARG]

{red}OPTIONS{dft}:"""

proc error*(str: string) =
    stdout.writeLine &"[{red}ERROR{dft}]      {str}"
    quit(1)

proc info*(str: string) =
    stdout.writeLine &"[{blue}INFO{dft}]       {str}"

proc warn*(str: string) =
    stdout.writeLine &"[{yellow}WARN{dft}]       {str}"

proc success*(str: string) =
    stdout.writeLine &"[{green}SUCCESS{dft}]    {str}" 

proc register_help*(calls: array[0..1,string], desc:string) =
    let options = calls.join(", ")
    let thing = &"\n    {blue}{options}{dft}"
    let space = " " * (50-len(thing))
    help_menu &= thing & space & desc

when defined(windows):
    const compilerOpt* = ["-B", "build", "-DCMAKE_BUILD_TYPE=Debug", "-S", "Swirl", "-G", "\"MinGW Makefiles\""]

else:
    const compilerOpt* = ["-B", "build", "-DCMAKE_BUILD_TYPE=Debug", "-S", "Swirl"]
