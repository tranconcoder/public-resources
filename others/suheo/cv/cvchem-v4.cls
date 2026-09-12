%% cvchem.cls — Awesome-CV style, one column, self-contained.
%% No fontawesome5/titlesec/enumitem/tcolorbox: icons are TikZ, lists are raw.
%% Compile with xelatex (Vietnamese diacritics need fontspec).
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cvchem-v4}[2026/08/18 One-column graphic CV]

\newif\ifcv@vietnamese \cv@vietnamesefalse
\DeclareOption{vietnamese}{\cv@vietnamesetrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[11pt,a4paper]{article}

\RequirePackage[T1]{fontenc}
\RequirePackage{fontspec}
\RequirePackage{xcolor}
\RequirePackage{tikz}
\RequirePackage{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{ragged2e}
\RequirePackage{etoolbox}
\RequirePackage{array}
\RequirePackage{calc}
\RequirePackage[hidelinks]{hyperref}

\geometry{a4paper,left=1.6cm,right=1.6cm,top=1.5cm,bottom=1.6cm,footskip=.6cm}

%% ---------------------------------------------------------------- palette
%% Accent is the only branded colour; everything else is neutral greys so
%% the page still reads well printed in black and white.
\definecolor{accent}{HTML}{0E7C6B}
\definecolor{accentdark}{HTML}{07564A}
\definecolor{ink}{HTML}{1A1A1A}
\definecolor{body}{HTML}{3C3C3C}
\definecolor{muted}{HTML}{7A7A7A}
\definecolor{rule}{HTML}{D8D8D8}
\newcommand{\cvaccent}[1]{\definecolor{accent}{HTML}{#1}}

%% ---------------------------------------------------------------- fonts
%% Liberation Sans (Arial metrics) draws Vietnamese capitals with stacked
%% diacritics correctly; Carlito drops the dot below on Ậ/Ệ and offsets Ả/Ọ.
\setmainfont{Liberation Sans}[
  BoldFont={Liberation Sans Bold}, ItalicFont={Liberation Sans Italic},
  BoldItalicFont={Liberation Sans Bold Italic}, Ligatures=TeX]
\newfontfamily\headfont{Liberation Sans}[Ligatures=TeX]
\color{body}

%% ---------------------------------------------------------------- icons
%% Hand-drawn TikZ glyphs; \cvicon scales them to the current font size.
\newcommand{\cv@ic}[1]{%
  \begin{tikzpicture}[x=1ex,y=1ex,baseline=-.45ex,line width=.16ex,
      accent,line cap=round,line join=round,scale=.95]#1\end{tikzpicture}}

\newcommand{\icmail}{\cv@ic{\draw(-1,-.75)rectangle(1,.75);\draw(-1,.75)--(0,-.05)--(1,.75);}}
\newcommand{\icphone}{\cv@ic{\draw[rounded corners=.18ex](-.6,-1)rectangle(.6,1);\draw(-.6,.62)--(.6,.62);\draw(-.6,-.6)--(.6,-.6);\fill(0,-.8)circle(.13);}}
\newcommand{\ichome}{\cv@ic{\draw(-1,0)--(0,.9)--(1,0);\draw(-.72,0)--(-.72,-.9)--(.72,-.9)--(.72,0);}}
\newcommand{\icpin}{\cv@ic{\draw(0,-1)..controls(-.95,.15)and(-.8,1)..(0,1)..controls(.8,1)and(.95,.15)..(0,-1);\draw(0,.35)circle(.32);}}
\newcommand{\icweb}{\cv@ic{\draw(0,0)circle(.95);\draw(-.95,0)--(.95,0);\draw(0,.95)..controls(-.6,.3)and(-.6,-.3)..(0,-.95);\draw(0,.95)..controls(.6,.3)and(.6,-.3)..(0,-.95);}}
\newcommand{\iclab}{\cv@ic{\draw(-.35,1)--(-.35,.2)--(-.95,-.9)--(.95,-.9)--(.35,.2)--(.35,1);\draw(-.6,1)--(.6,1);\draw(-.62,-.35)--(.62,-.35);}}
\newcommand{\iccal}{\cv@ic{\draw(-1,-.8)rectangle(1,.85);\draw(-1,.35)--(1,.35);\draw(-.5,.85)--(-.5,1.15);\draw(.5,.85)--(.5,1.15);}}
\newcommand{\icaward}{\cv@ic{\draw(0,.3)circle(.7);\draw(-.42,.82)--(-.6,-1.1)--(0,-.6)--(.6,-1.1)--(.42,.82);}}
\newcommand{\icflask}{\cv@ic{\draw(-.3,1)--(-.3,.25)--(-.95,-.85)--(.95,-.85)--(.3,.25)--(.3,1);\draw(-.55,1)--(.55,1);\fill[accent,opacity=.28](-.62,-.3)--(.62,-.3)--(.95,-.85)--(-.95,-.85)--cycle;\fill(-.2,-.55)circle(.1);\fill(.28,-.62)circle(.08);}}
\newcommand{\icgear}{\cv@ic{\foreach\a in{0,45,...,315}{\fill[accent](\a:.98)circle(.2);}\draw[line width=.22ex](0,0)circle(.62);}}
\newcommand{\icbook}{\cv@ic{\draw(-.95,.75)--(-.95,-.7)--(0,-.4)--(.95,-.7)--(.95,.75)--(0,1.02)--cycle;\draw(0,1.02)--(0,-.4);}}
\newcommand{\icmol}{\cv@ic{\draw[line width=.24ex](-.8,-.45)--(0,.6)--(.8,-.45)--(-.8,-.45);\fill(-.8,-.45)circle(.34);\fill(0,.6)circle(.34);\fill(.8,-.45)circle(.34);}}
\newcommand{\iclink}{\cv@ic{\draw(-.15,.35)--(-.75,.95);\draw(-.75,.35)arc(90:270:.3)--(-.15,-.25);\draw(.15,-.35)--(.75,-.95);\draw(.75,-.35)arc(-90:90:.3)--(.15,.25);}}

%% ---------------------------------------------------------------- header
\newcommand{\cvname}[2]{\def\cv@first{#1}\def\cv@last{#2}}
\newcommand{\cvtitle}[1]{\def\cv@title{#1}}
\newcommand{\cvphoto}[1]{\def\cv@photo{#1}}
\newcommand{\cvquote}[1]{\def\cv@quote{#1}}
\cvname{}{}\cvtitle{}\def\cv@photo{}\def\cv@quote{}

%% Contact lines: \cvcontact{icon}{text}{url} — url may be empty.
\newcommand{\cv@contacts}{}
\newcommand{\cvcontact}[3]{%
  \ifdefempty{\cv@contacts}{}{\appto\cv@contacts{\cv@sep}}%
  \ifstrempty{#3}%
    {\appto\cv@contacts{#1\,#2}}%
    {\expandafter\appto\expandafter\cv@contacts\expandafter{#1\,\href{#3}{#2}}}}
\newcommand{\cv@sep}{\hskip.55em\textcolor{rule}{\rule[.12ex]{.08ex}{1.05ex}}\hskip.55em}

%% Benzene-ring chain, purely decorative and tinted so it never competes with
%% the name above it.
\newcommand{\cv@hexband}{%
  \noindent\begin{tikzpicture}[x=1mm,y=1mm,line width=.32pt]
    \pgfmathsetmacro{\hr}{2.9}
    \pgfmathsetmacro{\hw}{\hr*1.732}
    \foreach \i in {0,...,15}{%
      \pgfmathsetmacro{\cx}{\i*\hw}
      \draw[accent,opacity=.42]
        (\cx+0,\hr) -- (\cx+\hr*0.866,\hr/2) -- (\cx+\hr*0.866,-\hr/2)
        -- (\cx+0,-\hr) -- (\cx-\hr*0.866,-\hr/2) -- (\cx-\hr*0.866,\hr/2) -- cycle;
      \ifodd\i\else
        \draw[accent,opacity=.42] (\cx-\hr*0.55,\hr*0.32)--(\cx+\hr*0.55,\hr*0.32);
        \draw[accent,opacity=.42] (\cx-\hr*0.55,-\hr*0.32)--(\cx+\hr*0.55,-\hr*0.32);
      \fi}
  \end{tikzpicture}}

\newcommand{\makecvheader}{%
  \begingroup\centering
  {\headfont\fontsize{30}{34}\selectfont\color{ink}%
    \MakeUppercase{\cv@first}\ \textbf{\MakeUppercase{\cv@last}}\par}
  \ifdefempty{\cv@title}{}{%
    \vskip.55ex{\fontsize{10.5}{13}\selectfont\color{accent}\MakeUppercase{\cv@title}\par}}
  \vskip1.1ex
  {\fontsize{9}{11}\selectfont\color{muted}\cv@contacts\par}
  \ifdefempty{\cv@quote}{}{%
    \vskip1.2ex{\fontsize{9.5}{12}\selectfont\itshape\color{body}\cv@quote\par}}
  \vskip1.2ex
  \hbox to\linewidth{\hss\cv@hexband\hss}\par
  \vskip.6ex{\color{accent}\rule{\linewidth}{1.1pt}}\par
  \endgroup\vskip1.4ex}

%% ---------------------------------------------------------------- sections
%% Section rule is drawn manually so no titlesec dependency is needed.
%% \section[\icflask]{Title} — the optional argument is an icon macro.
\renewcommand{\section}[2][]{%
  \par\cv@av{1.75ex}\penalty-200%
  \noindent{\fontsize{13}{15}\selectfont
    \ifstrempty{#1}{}{\raisebox{.05ex}{#1}\hskip.6em}}%
  {\headfont\fontsize{13}{15}\selectfont\bfseries\color{accent}%
    \MakeUppercase{#2}}\par
  \vskip.45ex\noindent{\color{rule}\rule{\linewidth}{.55pt}}\par
  \nointerlineskip\vskip.35ex\@afterindentfalse\@afterheading}
\setlength{\parindent}{0pt}

%% ---------------------------------------------------------------- density
%% \cvdensity{0.8} tightens every vertical gap; 1.2 opens it up. Use it to pull
%% a slightly-over CV back onto one page instead of hand-tuning each skip.
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
\newlength{\cv@rail}\setlength{\cv@rail}{1.15em}
\newif\ifcv@timeline \cv@timelinetrue
\newcommand{\cvtimeline}[1]{\csname cv@timeline#1\endcsname}

\newcommand{\cv@dot}{%
  \ifcv@timeline
    \llap{\begin{tikzpicture}[x=1ex,y=1ex,baseline=0pt,overlay]
      \fill[accent](0,.72)circle(.44);
      \draw[accent,opacity=.28,line width=.4pt](0,.05)--(0,-3.4);
    \end{tikzpicture}\hskip\cv@rail}%
  \fi}

\newcommand{\cventry}[4]{%
  \par\cv@av{.85ex}\penalty-100%
  \noindent\cv@dot\begin{minipage}{\linewidth}%
  {\fontsize{11}{13}\selectfont\bfseries\color{ink}#1}%
  \hfill{\fontsize{9}{11}\selectfont\color{muted}\ifstrempty{#3}{}{\iccal\,#3}}\par
  \nointerlineskip\vskip.3ex
  {\fontsize{10}{12}\selectfont\itshape\color{accentdark}#2}%
  \hfill{\fontsize{9}{11}\selectfont\color{muted}\ifstrempty{#4}{}{\icpin\,#4}}\par
  \end{minipage}\par\vskip.2ex}

%% Bullet list: plain \list, no enumitem.
\newenvironment{cvitems}
  {\begin{list}{\textcolor{accent}{\raisebox{.22ex}{\rule{.42ex}{.42ex}}}}%
    {\setlength{\leftmargin}{1.5em}\setlength{\labelsep}{.65em}%
     \setlength{\itemsep}{.28ex}\setlength{\itemsep}{\cv@d\itemsep}%
     \setlength{\parsep}{0pt}%
     \setlength{\topsep}{.3ex}\setlength{\topsep}{\cv@d\topsep}%
     \setlength{\partopsep}{0pt}}%
   \fontsize{9.8}{12.6}\selectfont\color{body}\justifying}
  {\end{list}\vskip.15ex}

%% Two-column "label: value" block for skills, languages, references.
\newenvironment{cvfields}[1][.20\linewidth]
  {\par\nointerlineskip\vskip-.35ex
   \begin{tabular}[t]{@{}>{\raggedright\arraybackslash}p{#1}@{\hspace{.9em}}>{\raggedright\arraybackslash}p{\dimexpr\linewidth-#1-.9em\relax}@{}}}
  {\end{tabular}\par\vskip.2ex}
\newlength{\cv@rowsep}\setlength{\cv@rowsep}{.2ex}
\newcommand{\cvfield}[2]{%
  {\fontsize{9.8}{12.4}\selectfont\bfseries\color{ink}#1} &
  {\fontsize{9.8}{12.4}\selectfont\color{body}#2}\\[\cv@d\cv@rowsep]}

%% Skill meter: \cvmeter{label}{0-5}. Squares, not a bar — prints legibly.
%% \cvmeter{label}{0-5} — rounded bar; the filled share is what prints, the
%% track keeps the row legible in greyscale.
\newcommand{\cvmeter}[2]{%
  {\fontsize{9.8}{12.4}\selectfont\color{body}#1}\hfill
  \begin{tikzpicture}[x=1ex,y=1ex,baseline=-.35ex]
    \fill[rule,rounded corners=.35ex](0,-.42)rectangle(11,.42);
    \pgfmathsetmacro{\w}{#2*11/5}
    \ifdim\w pt>0pt
      \fill[accent,rounded corners=.35ex](0,-.42)rectangle(\w,.42);
    \fi
    \foreach \i in {1,...,4}{\draw[white,line width=.32pt](\i*11/5,-.42)--(\i*11/5,.42);}
  \end{tikzpicture}}

%% One-line paragraph block (profile / summary).
\newcommand{\cvsummary}[1]{%
  {\fontsize{9.8}{12.8}\selectfont\color{body}\justifying #1\par}\vskip.3ex}

%% ---------------------------------------------------------------- footer
\pagestyle{fancy}\fancyhf{}\renewcommand{\headrulewidth}{0pt}
\newcommand{\cvfooter}[1]{\def\cv@footer{#1}}\cvfooter{}
\fancyfoot[C]{\fontsize{8}{10}\selectfont\color{muted}%
  \ifdefempty{\cv@footer}{}{\cv@footer\ \cv@sep\ }\thepage}
