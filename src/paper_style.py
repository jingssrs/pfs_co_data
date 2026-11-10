"""
Shared matplotlib style for the PFS target-selection (TS) paper.

Usage
-----
    import sys; sys.path.append("/path/to/pfs_co_data/src")
    import paper_style as ps

    ps.set_style()                       # call once, before making figures
    fig, ax = plt.subplots(figsize=ps.figsize("single"))
    ax.plot(x, y, color=ps.COLORS["blue"])
    ps.savefig(fig, "success_rate_imag")  # -> figures/paper/success_rate_imag.pdf

Change things in ONE place (this file) so every figure in the paper stays consistent.
"""
from pathlib import Path
import logging
import matplotlib as mpl
import matplotlib.pyplot as plt

# ------------------------------------------------------------------
# Figure sizes (PASJ). Make the figure at its printed size, so fonts
# appear in the paper at the size set below (no rescaling in LaTeX).
# Check in the paper with \the\columnwidth and \the\textwidth (in pt)
# and update these two numbers if they differ.
# ------------------------------------------------------------------
PT_PER_INCH = 72.27
COLUMN_WIDTH = 240.0 / PT_PER_INCH   # single column [inch]  (~8.4 cm)
TEXT_WIDTH = 494.0 / PT_PER_INCH     # full page width [inch] (~17.4 cm)

FONTSIZE = 9   # [pt] close to the PASJ body text

# Matplotlib "tab10" palette.
# Note: orange/green and blue/purple are hard to tell apart for colour-blind
# readers -- avoid putting those pairs next to each other, or add markers/linestyles.
# Assign each sample/quantity a fixed colour here and reuse it in all figures.
COLORS = {
    "blue":   "#1f77b4",
    "orange": "#ff7f0e",
    "green":  "#2ca02c",
    "red":    "#d62728",
    "purple": "#9467bd",
    "brown":  "#8c564b",
    "pink":   "#e377c2",
    "gray":   "#7f7f7f",
    "olive":  "#bcbd22",
    "cyan":   "#17becf",
}
COLOR_CYCLE = list(COLORS.values())

# Hide harmless font-subsetting warnings when embedding macOS fonts
# (e.g. "morx NOT subset; don't know how to subset; dropped").
logging.getLogger("fontTools").setLevel(logging.ERROR)

# Where savefig() writes by default
FIG_DIR = Path(__file__).resolve().parent.parent / "figures" / "paper"


def set_style(usetex=False, fontsize=FONTSIZE):
    """Apply the paper style. usetex=True needs a working LaTeX install."""
    mpl.rcdefaults()
    plt.rcParams.update({
        # fonts
        "text.usetex": usetex,
        "font.family": "serif",
        "font.serif": ["Times", "Times New Roman", "DejaVu Serif"],
        "mathtext.fontset": "stix",          # Times-like math without LaTeX
        "font.size": fontsize,
        "axes.labelsize": fontsize,
        "axes.titlesize": fontsize,
        "legend.fontsize": fontsize - 1,
        "xtick.labelsize": fontsize - 1,
        "ytick.labelsize": fontsize - 1,
        # axes and ticks
        "axes.linewidth": 0.8,
        "axes.prop_cycle": mpl.cycler(color=COLOR_CYCLE),
        "xtick.direction": "in",
        "ytick.direction": "in",
        "xtick.top": True,
        "ytick.right": True,
        "xtick.minor.visible": True,
        "ytick.minor.visible": True,
        "xtick.major.size": 4,
        "ytick.major.size": 4,
        "xtick.minor.size": 2,
        "ytick.minor.size": 2,
        "xtick.major.width": 0.8,
        "ytick.major.width": 0.8,
        "xtick.minor.width": 0.6,
        "ytick.minor.width": 0.6,
        # grid
        "axes.grid": True,
        "grid.alpha": 0.5,
        "grid.linewidth": 0.5,
        # lines, markers, errorbars
        "lines.linewidth": 1.2,
        "lines.markersize": 4,
        "errorbar.capsize": 2,
        # legend
        "legend.frameon": False,
        "legend.handlelength": 1.5,
        # output
        "figure.dpi": 150,
        "savefig.dpi": 300,
        "savefig.bbox": "tight",
        "savefig.pad_inches": 0.02,
        "pdf.fonttype": 42,                  # embed TrueType fonts (journals ask for this)
        "ps.fonttype": 42,
    })


def figsize(width="single", aspect=0.75):
    """(width, height) in inches. width: 'single', 'double', or a number in inches.
    aspect = height / width."""
    w = {"single": COLUMN_WIDTH, "double": TEXT_WIDTH}.get(width, width)
    return (w, w * aspect)


def savefig(fig, name, fig_dir=FIG_DIR, formats=("pdf",)):
    """Save fig as fig_dir/name.<fmt> for each format (e.g. formats=('pdf','png'))."""
    fig_dir = Path(fig_dir)
    fig_dir.mkdir(parents=True, exist_ok=True)
    for fmt in formats:
        fig.savefig(fig_dir / f"{name}.{fmt}")


if __name__ == "__main__":
    # Quick demo:  python paper_style.py
    import numpy as np
    set_style()
    x = np.linspace(22, 24.5, 50)
    fig, ax = plt.subplots(figsize=figsize("single"))
    for i, dz in enumerate([0.0, 0.2, 0.4]):
        ax.plot(x, 1 / (1 + np.exp(4 * (x - 23.5 - dz))), label=rf"$i - z > {dz:.1f}$")
    ax.set_xlabel(r"$i$ [mag]")
    ax.set_ylabel("Success rate")
    ax.legend()
    savefig(fig, "style_demo", formats=("pdf", "png"))
    print("saved to", FIG_DIR)
