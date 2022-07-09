import std/[streams, os, osproc, strformat], libs/[tlib, utils]

proc processArgs() =
    var discard_next = false
    for i in 1..os.paramCount():
        if discard_next: discard_next = false; continue
        let arg = os.paramStr(i)
        case arg
            of "-h", "--help":
                register_help(["-i","install [BRANCH]"], "Installs a specific Swirl branch (defaults to 'main')")
                register_help(["-u","uninstall"], "Removes Swirl from your computer")
                echo help_menu
            
            of "-i", "--install", "install":
                discard_next = true
                var branch:string

                let installPath = os.getHomeDir()
                let swirlDir = installPath & "Swirl"
                
                if os.paramCount() < i+1:
                    branch = "main"
                else:
                    branch = os.paramStr(i+1)
                
                info &"Downloading swirl@{branch} using GIT (new folder will be created)"
                if dirExists(swirlDir): os.removeDir(swirlDir)
                let git = startProcess("git", installPath, ["clone", "-b", branch, "https://github.com/SwirlLang/Swirl", "--quiet"], options={poUsePath})
                let gitOut = git.errorStream().readStr(200)
                if gitOut != "": error gitOut
                info "Preparing Swirl for compilation using CMAKE"
                let prepare = startProcess("cmake", swirlDir, ["-B", "build", "-DCMAKE_BUILD_TYPE=Debug", "-S", "Swirl"], options={poUsePath})
                let prepareOut = prepare.errorStream().readStr(200)
                if prepareOut != "": error prepareOut
                info "Compiling Swirl with CMAKE"
                let compiler = startProcess("cmake", swirlDir, ["--build", "build", "--config", "Debug"], options={poUsePath})
                let compilerOut = compiler.errorStream().readStr(200)
                if compilerOut != "": error compilerOut
                success &"Swirl has been compiled to {swirlDir}"
                warn &"The Swirl directory ({swirlDir}) isn't on PATH, you need to set it manually"
            
            of "-u", "--uninstall", "uninstall":
                let installPath = os.getHomeDir()
                let swirlDir = installPath & "Swirl"

                if dirExists(swirlDir):
                    os.removeDir(swirlDir)
                    success "Swirl was removed from your computer, you might to remove it from your PATH (if it was set)"
                else:
                    error "Swirl is not installed on your computer."

when isMainModule:
    try:
        if os.paramCount() < 1:
            error "No argument provided, please check the help using 'swirlinstall --help'"
        
        processArgs()
    except EKeyboardInterrupt:
        quit(0)