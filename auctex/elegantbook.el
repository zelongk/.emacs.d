;; -*- lexical-binding: t; -*-

(TeX-add-style-hook
 "elegantbook"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("book" "a4paper" "oneside")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("kvoptions" "") ("etoolbox" "") ("setspace" "") ("csquotes" "") ("hyperref" "") ("geometry" "") ("indentfirst" "") ("comment" "") ("mtpro2" "lite") ("iftex" "") ("newtxtext" "") ("helvet" "scaled=.90") ("fontspec" "no-math") ("ctex" "UTF8" "scheme=plain" "fontset=none") ("anyfontsize" "") ("newtxmath" "") ("esint" "") ("xcolor" "table") ("mwe" "") ("enumerate" "") ("enumitem" "shortlabels" "inline") ("caption" "labelfont={bf,color=structurecolor}") ("footmisc" "flushmargin" "stable") ("graphicx" "") ("amsmath" "") ("mathrsfs" "") ("amsfonts" "") ("amssymb" "") ("physics" "") ("physics2" "") ("mathtools" "") ("booktabs" "") ("multirow" "") ("tikz" "") ("fancyvrb" "") ("makecell" "") ("lipsum" "") ("hologo" "") ("titlesec" "center" "pagestyles") ("appendix" "title" "titletoc" "header") ("biblatex" "backend=\\ELEGANT@bibend" "citestyle=\\ELEGANT@citestyle" "bibstyle=\\ELEGANT@bibstyle") ("inputenc" "utf8") ("fontenc" "T1" "T2A") ("babel" "italian" "french" "dutch" "magyar" "spanish" "mongolian" "portuguese") ("luatexja" "") ("apptools" "") ("pifont" "") ("manfnt" "") ("bbding" "") ("tcolorbox" "many") ("amsthm" "") ("multicol" "") ("adforn" "") ("fancyhdr" "") ("listings" "") ("bm" "") ("calc" "") ("tocloft" "titles")))
   (add-to-list 'LaTeX-verbatim-environments-local "lstlisting")
   (add-to-list 'LaTeX-verbatim-environments-local "SaveVerbatim")
   (add-to-list 'LaTeX-verbatim-environments-local "VerbatimOut")
   (add-to-list 'LaTeX-verbatim-environments-local "LVerbatim*")
   (add-to-list 'LaTeX-verbatim-environments-local "LVerbatim")
   (add-to-list 'LaTeX-verbatim-environments-local "BVerbatim*")
   (add-to-list 'LaTeX-verbatim-environments-local "BVerbatim")
   (add-to-list 'LaTeX-verbatim-environments-local "Verbatim*")
   (add-to-list 'LaTeX-verbatim-environments-local "Verbatim")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "lstinline")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "href")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "lstinline")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "Verb*")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "Verb")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "latex2e"
    "kvoptions"
    "etoolbox"
    "book"
    "bk10"
    "setspace"
    "csquotes"
    "hyperref"
    "geometry"
    "indentfirst"
    "comment"
    "mtpro2"
    "iftex"
    "newtxtext"
    "helvet"
    "fontspec"
    "ctex"
    "anyfontsize"
    "newtxmath"
    "esint"
    "xcolor"
    "mwe"
    "enumerate"
    "enumitem"
    "caption"
    "footmisc"
    "graphicx"
    "amsmath"
    "mathrsfs"
    "amsfonts"
    "amssymb"
    "physics"
    "physics2"
    "mathtools"
    "booktabs"
    "multicol"
    "multirow"
    "tikz"
    "fancyvrb"
    "makecell"
    "lipsum"
    "hologo"
    "titlesec"
    "appendix"
    "biblatex"
    "babel"
    "inputenc"
    "fontenc"
    "luatexja"
    "apptools"
    "pifont"
    "manfnt"
    "bbding"
    "tcolorbox"
    "amsthm"
    "adforn"
    "fancyhdr"
    "listings"
    "bm"
    "calc"
    "tocloft")
   (TeX-add-symbols
    '("elegantnewtheorem" "Text" "Text" "Text")
    '("hltext" 2)
    '("hlmath" 2)
    '("numberline" 1)
    '("datechange" 2)
    '("dateinfoline" 2)
    '("chaptermark" 1)
    '("sectionmark" 1)
    '("circled" 1)
    '("tabref" 1)
    '("figref" 1)
    '("bioinfo" 2)
    '("question" 1)
    '("cover" 1)
    '("logo" 1)
    '("extrainfo" 1)
    '("version" 1)
    '("institute" 1)
    '("subtitle" 1)
    '("email" 1)
    '("mailto" 1)
    '("ekv" 1)
    "songti"
    "heiti"
    "kaishu"
    "fangsong"
    "cbfseries"
    "citshape"
    "cnormal"
    "cfs"
    "ebibname"
    "authorname"
    "institutename"
    "datename"
    "versionname"
    "notename"
    "definitionname"
    "theoremname"
    "axiomname"
    "postulatename"
    "lemmaname"
    "propositionname"
    "corollaryname"
    "examplename"
    "instancename"
    "problemname"
    "exercisename"
    "remarkname"
    "assumptionname"
    "conclusionname"
    "solutionname"
    "propertyname"
    "introductionname"
    "updatename"
    "historyname"
    "beforechap"
    "afterchap"
    "proofname"
    "problemsetname"
    "eitemi"
    "eitemii"
    "eitemiii"
    "xchaptertitle"
    "ELEGANT"
    "dollar"
    "bmmax"
    "listofchanges"
    "definedas"
    "Lis"
    "qed"
    "oldencodingdefault"
    "oldrmdefault"
    "oldsfdefault"
    "oldttdefault"
    "encodingdefault"
    "rmdefault"
    "sfdefault"
    "ttdefault"
    "Bbbk"
    "sumop"
    "prodop"
    "style"
    "openbox")
   (LaTeX-add-environments
    "relsec"
    '("problemset" LaTeX-env-args ["argument"] 0)
    '("introduction" LaTeX-env-args ["argument"] 0)
    '("problem" LaTeX-env-args ["argument"] 0)
    '("exercise" LaTeX-env-args ["argument"] 0)
    '("example" LaTeX-env-args ["argument"] 0)
    '("custom" 1)
    "note"
    "proof"
    "solution"
    "remark"
    "assumption"
    "conclusion"
    "property"
    "change")
   (LaTeX-add-pagestyles
    "plain")
   (LaTeX-add-counters
    "exam"
    "exer"
    "prob")
   (LaTeX-add-comment-incl-excls
    '("solution" "exclude")
    '("proof" "exclude")
    '("inline" "exclude"))
   (LaTeX-add-xcolor-definecolors
    "structurecolor"
    "main"
    "second"
    "third"
    "structure1"
    "main1"
    "second1"
    "third1"
    "structure2"
    "main2"
    "second2"
    "third2"
    "structure3"
    "main3"
    "second3"
    "third3"
    "structure4"
    "main4"
    "second4"
    "third4"
    "structure5"
    "main5"
    "second5"
    "third5"
    "winered"
    "bule"
    "coverlinecolor"
    "lightgrey"
    "frenchplum")
   (LaTeX-add-amsthm-newtheoremstyles
    "defstyle"
    "thmstyle"
    "prostyle")
   (LaTeX-add-listings-lstdefinestyles
    "mystyle"))
 :latex)

