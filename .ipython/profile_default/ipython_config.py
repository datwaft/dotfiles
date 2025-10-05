from importlib import metadata

c.TerminalInteractiveShell.true_color = True
try:
    metadata.version("ipython-icat")
    c.InteractiveShellApp.extensions = ["autoreload", "icat"]
    c.InteractiveShellApp.exec_lines = ["%autoreload 2", "%plt_icat"]
except metadata.PackageNotFoundError:
    pass
