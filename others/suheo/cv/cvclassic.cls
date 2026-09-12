%% cvclassic.cls — Plain black-and-white "ATS classic" style, one column.
%% No icons, no accent color, no decoration. Times New Roman, ruled section
%% headers, entries as "Org, Location — right: Dates" then bold role line.
%% Compile with xelatex (Vietnamese diacritics need fontspec).
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cvclassic}[2026/09/04 One-column plain-text CV]

\newif\ifcv@vietnamese \cv@vietnamesefalse
\DeclareOption{vietnamese}{\cv@vietnamesetrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[11pt,a4paper]{article}

\RequirePackage[T1]{fontenc}
\RequirePackage{fontspec}
\RequirePackage{xcolor}
\RequirePackage{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{ragged2e}
\RequirePackage{etoolbox}
\RequirePackage{array}
\RequirePackage{calc}
\RequirePackage[hidelinks]{hyperref}

\geometry{a4paper,left=1.9cm,right=1.9cm,top=1.7cm,bottom=1.8cm,footskip=.6cm}

%% ---------------------------------------------------------------- palette
%% Plain black/grey only — no accent colour, prints identically on paper.
\definecolor{ink}{HTML}{000000}
\definecolor{body}{HTML}{1A1A1A}
\definecolor{muted}{HTML}{4A4A4A}
\definecolor{rule}{HTML}{000000}
\newcommand{\cvaccent}[1]{} % kept for interface parity; unused in this style

%% ---------------------------------------------------------------- fonts
\setmainfont{Times New Roman}[Ligatures=TeX]
\newfontfamily\headfont{Times New Roman}[Ligatures=TeX]
\color{body}

%% ---------------------------------------------------------------- header
\newcommand{\cvname}[2]{\def\cv@first{#1}\def\cv@last{#2}}
\newcommand{\cvtitle}[1]{\def\cv@title{#1}}
\newcommand{\cvphoto}[1]{\def\cv@photo{#1}}
\newcommand{\cvquote}[1]{\def\cv@quote{#1}}
\cvname{}{}\cvtitle{}\def\cv@photo{}\def\cv@quote{}

%% Contact lines: \cvcontact{icon}{text}{url} — icon argument ignored (no icons).
\newcommand{\cv@contacts}{}
\newcommand{\cvcontact}[3]{%
  \ifdefempty{\cv@contacts}{}{\appto\cv@contacts{\cv@sep}}%
  \ifstrempty{#3}%
    {\appto\cv@contacts{#2}}%
    {\expandafter\appto\expandafter\cv@contacts\expandafter{\expandafter{\href{#3}{#2}}}}}
\newcommand{\cv@sep}{\hskip.6em\textperiodcentered\hskip.6em}

\newcommand{\makecvheader}{%
  \begingroup\centering
  {\headfont\fontsize{20}{23}\selectfont\bfseries\color{ink}%
    \MakeUppercase{\cv@first}\ \MakeUppercase{\cv@last}\par}
  \ifdefempty{\cv@title}{}{%
    \vskip.9ex{\fontsize{13}{16}\selectfont\bfseries\color{ink}\cv@title\par}}
  \vskip1ex
  {\fontsize{10}{12.5}\selectfont\color{body}\cv@contacts\par}
  \ifdefempty{\cv@quote}{}{%
    \vskip1.4ex{\fontsize{9.8}{12.5}\selectfont\itshape\color{muted}\cv@quote\par}}
  \endgroup\vskip1.6ex}

%% ---------------------------------------------------------------- sections
%% \section[]{Title} — optional-icon argument accepted for interface parity
%% with cvchem.cls, but ignored (no icons in this style).
\renewcommand{\section}[2][]{%
  \par\cv@av{1.9ex}\penalty-200%
  \noindent{\headfont\fontsize{12}{14}\selectfont\bfseries\color{ink}%
    \MakeUppercase{#2}}\par
  \vskip.3ex\noindent{\color{rule}\rule{\linewidth}{.7pt}}\par
  \nointerlineskip\vskip.5ex\@afterindentfalse\@afterheading}
\setlength{\parindent}{0pt}

%% ---------------------------------------------------------------- density
\newcommand{\cv@d}{1.0}
\newcommand{\cvdensity}[1]{\renewcommand{\cv@d}{#1}%
  \linespread{#1}\selectfont}
\newlength{\cv@tmp}
\newcommand{\cv@vs}[1]{\setlength{\cv@tmp}{#1}%
  \setlength{\cv@tmp}{\cv@d\cv@tmp}\vskip\cv@tmp}
\newcommand{\cv@av}[1]{\setlength{\cv@tmp}{#1}%
  \setlength{\cv@tmp}{\cv@d\cv@tmp}\addvspace{\cv@tmp}}

%% ---------------------------------------------------------------- entries
%% \cventry{title}{organisation}{dates}{location} then \cvitems{...}.
%% Layout: line 1 = organisation (bold) --- location (right); line 2 = title
%% (italic) --- dates (right). No timeline dots, no icons.
\newif\ifcv@timeline \cv@timelinetrue
\newcommand{\cvtimeline}[1]{\csname cv@timeline#1\endcsname}

\newcommand{\cventry}[4]{%
  \par\cv@av{1ex}\penalty-100%
  \noindent\begin{minipage}{\linewidth}%
  {\fontsize{10.6}{13}\selectfont\bfseries\color{ink}#2}%
  \hfill{\fontsize{10}{12}\selectfont\color{body}#4}\par
  \nointerlineskip\vskip.25ex
  {\fontsize{10.3}{12.5}\selectfont\itshape\color{body}#1}%
  \hfill{\fontsize{10}{12}\selectfont\color{muted}#3}\par
  \end{minipage}\par\vskip.25ex}

%% Bullet list: plain \list, no enumitem.
\newenvironment{cvitems}
  {\begin{list}{\textbullet}%
    {\setlength{\leftmargin}{1.5em}\setlength{\labelsep}{.65em}%
     \setlength{\itemsep}{.28ex}\setlength{\itemsep}{\cv@d\itemsep}%
     \setlength{\parsep}{0pt}%
     \setlength{\topsep}{.3ex}\setlength{\topsep}{\cv@d\topsep}%
     \setlength{\partopsep}{0pt}}%
   \fontsize{10}{13}\selectfont\color{body}\justifying}
  {\end{list}\vskip.15ex}

%% Two-column "label: value" block for skills, languages, references.
\newenvironment{cvfields}[1][.20\linewidth]
  {\par\nointerlineskip\vskip-.35ex
   \begin{tabular}[t]{@{}>{\raggedright\arraybackslash}p{#1}@{\hspace{.9em}}>{\raggedright\arraybackslash}p{\dimexpr\linewidth-#1-.9em\relax}@{}}}
  {\end{tabular}\par\vskip.2ex}
\newlength{\cv@rowsep}\setlength{\cv@rowsep}{.2ex}
\newcommand{\cvfield}[2]{%
  {\fontsize{10}{13}\selectfont\bfseries\color{ink}#1} &
  {\fontsize{10}{13}\selectfont\color{body}#2}\\[\cv@d\cv@rowsep]}

%% Skill meter kept for interface parity — renders as plain text level, no bar.
\newcommand{\cvmeter}[2]{%
  {\fontsize{10}{13}\selectfont\color{body}#1}\hfill
  {\fontsize{9}{13}\selectfont\color{muted}(#2/5)}}

%% One-line paragraph block (profile / summary).
\newcommand{\cvsummary}[1]{%
  {\fontsize{10}{13.4}\selectfont\color{body}\justifying #1\par}\vskip.3ex}

%% ---------------------------------------------------------------- footer
\pagestyle{fancy}\fancyhf{}\renewcommand{\headrulewidth}{0pt}
\newcommand{\cvfooter}[1]{\def\cv@footer{#1}}\cvfooter{}
\fancyfoot[C]{\fontsize{8}{10}\selectfont\color{muted}%
  \ifdefempty{\cv@footer}{}{\cv@footer\ \cv@sep\ }\thepage}
