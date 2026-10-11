# Packages in the preamble

What each package in `preamble-en.tex` and `preamble-es.tex` does, with examples
of the commands you're likely to type. Both preambles load the same packages; only
the language settings differ. The examples show the LaTeX you write and, after
the arrow, what appears in the PDF.

Packages you never call directly (they work in the background) are listed at the
end with one line each.

---

## Choosing the language

The language is chosen at the top of `main.tex`: keep exactly one of these lines
active.

```latex
\input{preamble-en}   % English
% \input{preamble-es} % Español
```

It changes the automatic words in the PDF ("Abstract" → "Resumen", "References"
→ "Referencias", "Table" → "Tabla", the date in `\today`), the hyphenation rules,
and the names `\cref` writes. Your own text and all commands stay the same.

Two things only the Spanish preamble does:

- Math operators get the Spanish accent: `\lim` → lím, `\max` → máx.
  `\sin` stays "sin".
- `\cref` writes lowercase names, as Spanish style asks: "la figura 1",
  "la ecuación (2)". Use `\Cref` at the start of a sentence: "Figura 1".

The spell checker reads its language from `.vscode/settings.json`: set
`"ltex.language"` to `"en-US"` or `"es"` to match.

---

## Mathematics

### amsmath

The standard toolbox for equations. Use it for anything longer than one line.

```latex
\begin{equation}            % one numbered equation
  E = mc^2 \label{eq:energy}
\end{equation}

\begin{align}               % several lines aligned at &, each numbered
  f(x) &= (x+1)^2 \nonumber \\        % \nonumber: no number on this line
       &= x^2 + 2x + 1
\end{align}
```

Also: `\text{...}` for words inside math, `\dfrac` for a full-size fraction in
running text, `\begin{cases} ... \end{cases}` for piecewise functions.

### mathtools

Extensions to amsmath.

```latex
\gamma \coloneqq \frac{b}{2m}     → γ := b/2m   (definition, with the colon centred)
\begin{pmatrix*}[r] -1 & 2 \\ 3 & -4 \end{pmatrix*}   → matrix with right-aligned entries
```

### amssymb and mathrsfs

Extra symbols and letter styles.

```latex
\mathbb{R}, \mathbb{C}    → ℝ, ℂ        (amssymb; \R and \N are shortcuts, see below)
\mathscr{L}, \mathscr{H}  → script L, H for Lagrangians, Hilbert spaces  (mathrsfs)
\leqslant, \therefore     → ⩽, ∴        (amssymb)
```

### physics

Shortcuts for the notation physicists use all the time. Brackets resize
automatically to fit what's inside.

```latex
\dv{f}{x}          → df/dx            \dv[2]{f}{x}       → d²f/dx²
\pdv{f}{x}         → ∂f/∂x            \pdv{f}{x}{y}      → ∂²f/∂x∂y
\dv{t}             → d/dt (operator)  \dd{x}             → dx with correct spacing, for integrals
\abs{x}            → |x|              \norm{v}           → ‖v‖
\pqty{\frac{a}{b}} → (a/b) with tall parentheses   (also \bqty [ ], \Bqty { }, \vqty | |)
\vb{F}, \va{F}     → bold vector F, F with arrow    \grad\phi, \div\vb{E}, \curl\vb{B}
\comm{A}{B}        → [A, B]           \acomm{A}{B}       → {A, B}
\ev{H}             → ⟨H⟩              \ev{H}{\psi}       → ⟨ψ|H|ψ⟩
\mel{n}{H}{m}      → ⟨n|H|m⟩          \Tr\rho, \tr\rho   → Tr ρ, tr ρ
```

**Not available here:** physics' own `\qty`. It clashes with siunitx, so in
this template `\qty` means a quantity with units (see siunitx). For auto-sized
brackets use `\quantity(...)` or `\pqty{...}`.

**`\bra`, `\ket` and `\braket` come from braket**, not from physics (next
section).

### braket

Dirac notation and set notation. Write the bars inside the braces; braket draws
them with the right size.

```latex
\ket{\psi}, \bra{\phi}             → |ψ⟩, ⟨φ|
\braket{\phi|\psi}                 → ⟨φ|ψ⟩
\braket{\psi | \hat{H} | \psi}     → ⟨ψ|Ĥ|ψ⟩
\Braket{\phi | \frac{a}{b} | \psi} → same, with brackets and bars sized to the fraction
\set{x | x > 0}                    → { x | x > 0 }
\Set{x \in \R | x^2 < \frac{1}{2}} → same, sized to the content
```

`\braket` takes **one** argument with the bars inside: `\braket{\phi|\psi}`, not
physics' two-argument `\braket{\phi}{\psi}`.

### siunitx

Numbers and units, spaced and typeset correctly in text and in math.

```latex
\qty{9.81}{m/s^2}            → 9.81 m/s²
\qty{9.81}{m.s^{-2}}         → 9.81 m s⁻²     (a dot separates units)
\qty{6.022e23}{mol^{-1}}     → 6.022 × 10²³ mol⁻¹
\unit{kg.m^2}                → kg m²          (unit alone, e.g. in a table header)
\num{12345.678}              → 12 345.678     (number alone, with digit grouping)
\qtyrange{10}{20}{\celsius}  → 10 °C to 20 °C
```

In tables, the column type `S` aligns numbers on the decimal point:

```latex
\begin{tabular}{l S[table-format=1.3]}
  Mass & 1.0 \\
  Frequency & 1.990 \\
\end{tabular}
```

---

## Figures and tables

### graphicx

Inserts images. Files are looked for in `figures/`, so give only the name.

```latex
\includegraphics[width=0.7\linewidth]{energy-spectrum}   % figures/energy-spectrum.pdf
\includegraphics[height=4cm, angle=90]{setup-photo}
```

### float

Adds the `[H]` placement: the figure goes exactly where it is in the text,
instead of floating to the top of a page.

```latex
\begin{figure}[H]     % here, no matter what
\begin{figure}[htbp]  % let LaTeX choose (usually better with many figures)
```

### caption

Caption style: bold label with a period ("**Fig. 1.** Text"). Figures are labelled
"Fig." in both languages. Inside a figure or table:

```latex
\caption{Position of the oscillator.}            → Fig. 1. Position of the oscillator.
\caption[Short title]{Long caption text ...}     % short title for a list of figures
```

### subcaption

Several images inside one figure, each with its own letter and label.

```latex
\begin{figure}[htbp]
  \begin{subfigure}{0.45\linewidth}
    \includegraphics[width=\linewidth]{before}
    \caption{Before.}   \label{fig:before}
  \end{subfigure}
  \hfill
  \begin{subfigure}{0.45\linewidth}
    \includegraphics[width=\linewidth]{after}
    \caption{After.}    \label{fig:after}
  \end{subfigure}
  \caption{Sample before and after.}  \label{fig:sample}
\end{figure}
```

`\cref{fig:before}` then gives "Fig. 1a".

### booktabs

Professional table rules. Use these instead of `\hline`, and avoid vertical lines.

```latex
\begin{tabular}{l c}
  \toprule
  Quantity & Value \\
  \midrule
  Mass & 1.0 \\
  \bottomrule
\end{tabular}
```

`\cmidrule(lr){2-3}` draws a rule under columns 2 to 3 only.

### multicol

Text in columns for part of a page.

```latex
\begin{multicols}{2}
  This text is split into two balanced columns.
\end{multicols}
```

---

## References and links

### biblatex (with csquotes)

The bibliography, built from `refs.bib`. Entries appear numbered in order of
first citation.

```latex
\cite{hawking1975particle}                  → [1]
\cite{hawking1975particle,jackson1999classical} → [1, 2]
\cite[p.~45]{jackson1999classical}          → [2, p. 45]
\printbibliography                          % already at the end of main.tex
```

csquotes is what biblatex uses to print quotation marks correctly for the
language. You can use it yourself too: `\enquote{text}` → “text” in English,
«text» in Spanish.

### hyperref

Makes references, citations and URLs clickable in the PDF (blue for references,
red for citations and links).

```latex
\href{https://tug.org/texlive/}{TeX Live home page}   → clickable text
\url{https://arxiv.org}                                → clickable address
```

### cleveref

References that write the word for you, so "Fig." or "Eq." is always right and
always part of the link.

```latex
\cref{fig:spectrum}       → Fig. 3            (Spanish: figura 3)
\cref{eq:energy}          → Eq. (2)           (Spanish: ecuación (2))
\cref{eq:a,eq:b,eq:c}     → Eqs. (1) to (3)   (Spanish: ecuaciones (1) a (3))
\Cref{sec:methods}        → Section 2, at the start of a sentence
```

Label everything with a prefix (`sec:`, `eq:`, `fig:`, `tab:`) so labels are easy
to find.

---

## Notes between co-authors

### todonotes (loaded in `main.tex`)

Colored notes inside the text, for comments to the other authors.

```latex
\todo{Check the sign of this term.}
\todo[color=SkyBlue1!40]{Ana: maybe move this paragraph to the introduction?}
```

To hide every note at once, for example before submitting, add `disable` where
it's loaded at the top of `main.tex`:

```latex
\usepackage[disable]{todonotes}
```

The notes stay in the source, so removing `disable` brings them back.

---

## Page layout and header

### geometry

Paper margins: 25 mm top, 20 mm on the other sides, on letter paper (set in the
`\documentclass` line of `main.tex`). Change them in the `\usepackage[...]{geometry}`
line of both preambles.

### fancyhdr

The header and footer: assignment name on the left and course on the right with a
thick rule below, page number at the bottom right. The first page has no header
and shows the author emails in the footer. The texts come from `\assignment`,
`\course` and `\authoremails` in `main.tex`.

### parskip

Paragraphs start without indentation and are separated by a blank space.

---

## Custom commands (defined at the end of the preambles)

```latex
\R, \N, \sub               → ℝ, ℕ, ⊂
Author One\authormark{author1}{\dag}               % in \author: superscript linked to the email
\authoremail{author1}{\dag}{author1@unal.edu.co}   % in \authoremails: the email it links to
```

To add a command of your own, put a `\newcommand` in **both** preambles, for
example `\newcommand{\C}{\mathbb{C}}`.

---

## Background packages

These have no commands to learn; they just need to be there.

| Package | What it does |
|---|---|
| `babel` | Language: automatic words, hyphenation, date format |
| `fontenc` (T1) | Correct hyphenation of accented words; PDF text can be copied and searched |
| `lmodern` | The Latin Modern font, a sharper version of LaTeX's default font |
| `microtype` | Fine spacing adjustments: fewer badly broken lines, more even paragraphs |
| `xcolor` (x11names) | Colors by name, such as `Red1`, `Orange1`, `SkyBlue1`. Use with `\textcolor{Red1}{text}` |
