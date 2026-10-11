"""Generates figures/damped-oscillator.pdf, used in sections/03-figures-and-tables.tex.

Run from the repository root:  python figures/damped-oscillator.py
Keeping the script next to the figure means anyone can regenerate or modify it.
"""
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np

# Parameters (same as the table in the document)
m, k, b, x0 = 1.0, 4.0, 0.4, 1.0
gamma = b / (2 * m)
omega0 = np.sqrt(k / m)
omega_d = np.sqrt(omega0**2 - gamma**2)
phi = np.arctan(-gamma / omega_d)
A = x0 / np.cos(phi)

t = np.linspace(0, 20, 2000)
x = A * np.exp(-gamma * t) * np.cos(omega_d * t + phi)
envelope = x0 * np.exp(-gamma * t)

plt.rcParams.update({"font.size": 10, "font.family": "serif"})
fig, ax = plt.subplots(figsize=(5.5, 2.8))
ax.plot(t, x, lw=1.4, label="$x(t)$")
ax.plot(t, envelope, "k--", lw=0.8, label=r"$\pm x_0 e^{-\gamma t}$")
ax.plot(t, -envelope, "k--", lw=0.8)
ax.set_xlabel("$t$ (s)")
ax.set_ylabel("$x$ (m)")
ax.set_xlim(t[0], t[-1])
ax.legend(frameon=False)
fig.tight_layout()

out = Path(__file__).with_suffix(".pdf")
fig.savefig(out)
print(f"Saved {out}")
