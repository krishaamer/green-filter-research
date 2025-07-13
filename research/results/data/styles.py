import seaborn as sns
from matplotlib import pyplot as plt
import textwrap

# ─────────────────────────────────────────────────────────────
#  Global styling helpers for every plot / figure in the project
# ─────────────────────────────────────────────────────────────

# 1 . Cluster metadata  ─────────────────────────────────────────
# (keep names + colours in one place so all notebooks / scripts
#  can import the same truth)
CLUSTER_NAMES = {
    0: "Eco-Friendly",   # 💚
    1: "Moderate",        # 💙
    2: "Frugal",          # 🧡
}

# pastel palette pulled once so the colours match your reference chart
_PALETTE = sns.color_palette("pastel", 3)
CLUSTER_COLORS = {
    0: "#8DE5A1",   # Eco-Friendly  → pastel green
    1: "#A1C9F4",   # Moderate      → pastel blue
    2: "#FFB482",   # Frugal        → pastel orange
}

def get_cluster_palette() -> dict:
    """Return a *copy* of the cluster→colour mapping.

    Using a copy protects the global dict from accidental mutation
    down‑stream (e.g., someone doing `palette[0] = 'red'`).
    """
    return CLUSTER_COLORS.copy()

_DEF_SNS_CONTEXT = {
    "font_scale": 1.1,
    "rc": {
        "axes.titlesize": 14,
        "axes.labelsize": 12,
    },
}

_DEF_MPL_RC = {
    "figure.figsize": (8, 6),
    "axes.grid": True,
    "grid.alpha": 0.25,
    "font.family": "sans-serif",
}

def activate_plot_style():
    """Apply the house style (seaborn + matplotlib) globally."""
    # seaborn context (scales fonts appropriately for notebooks)
    sns.set_context("notebook", **_DEF_SNS_CONTEXT)

    # colour cycle → use cluster colours so misc lines match palette
    plt.rcParams["axes.prop_cycle"] = plt.cycler(color=_PALETTE)

    # extra mpl tweaks
    plt.rcParams.update(_DEF_MPL_RC)

def wrap(text, width=60):
    """Return the string with a newline every <width> characters."""
    return "\n".join(textwrap.wrap(text, width))