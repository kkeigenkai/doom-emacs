;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq user-full-name "Sergei Pshonnov"
      user-mail-address "sergei@pshonnov.ru")

(setq doom-theme 'modus-operandi)

(setq shell-file-name "/opt/homebrew/Cellar/bash/5.2.15/bin//bash")
(setq-default vterm-shell "/opt/homebrew/bin/fish")

(setq-default explicit-shell-file-name "/opt/homebrew/bin/fish")

(setq display-line-numbers-type nil)

(setq doom-font (font-spec :family "PragmataPro Liga" :size 17 :weight 'regular))
(setq doom-variable-pitch-font (font-spec :family "PragmataPro Liga" :size 17 :weight 'regular))

(setq doom-themes-enable-italic t)
(setq doom-font-increment 1)

(set-popup-rule! "^\\*Flycheck errors\\*$" :quit nil)

(after! flycheck
  (define-fringe-bitmap 'flycheck-fringe-bitmap-double-arrow-hi-res [224]
    nil nil '(center repeated))
  (define-fringe-bitmap 'flycheck-fringe-bitmap-double-arrow [224]
    nil nil '(center repeated)))

(use-package flymake
  :defer t
  :init
  ;; as flymakes fail silently there is no need to activate it on a per major mode basis
  (add-hook! (prog-mode text-mode) #'flymake-mode)
  :config
  (setq flymake-fringe-indicator-position 'right-fringe))

(use-package flymake-popon
  :hook (flymake-mode . flymake-popon-mode)
  :config
  (setq flymake-popon-method 'popon))

(setq doom-modeline-bar-width 1
      doom-modeline-workspace-name nil)
(custom-set-faces!
  `(doom-modeline-bar :background ,(face-background 'mode-line))
  `(doom-modeline-bar-inactive :background ,(face-background 'mode-line-inactive)))

(setq modus-themes-mode-line '(borderless))

(setq display-time-24hr-format t
      display-time-format ""
      display-time-default-load-average nil)
(display-time-mode +1)

(after! writeroom-mode
  (setq +zen-text-scale 1.2)
  (setq writeroom-width 0.7))

(after! lsp-mode
  ;; https://github.com/emacs-lsp/lsp-mode/issues/3577#issuecomment-1709232622
  (delete 'lsp-terraform lsp-client-packages))

;; (after! lsp-ui
;;   (setq lsp-ui-sideline-enable nil  ; no more useful than flycheck
;;         ))

(map! :leader
      :desc "Toggle breakpoint"
      "t b" #'dap-breakpoint-toggle)

(after! go-mode
  ;; Make sure you don't have other goimports hooks enabled.
  (defun lsp-go-install-save-hooks ()
    (add-hook 'before-save-hook #'lsp-format-buffer t t)
    (add-hook 'before-save-hook #'lsp-organize-imports t t))
  (add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

  (setq  lsp-go-use-gofumpt t)

  (require 'dap-dlv-go)
  (setq lsp-gopls-hover-kind "FullDocumentation")
  (setq lsp-gopls-staticcheck t)
  (setq lsp-go-analyses '((fieldalignment . t)
                           (nilness . t)
                           (shadow . t)
                           (unusedparams . t)
                           (unusedwrite . t)
                           (useany . t)
                           (unusedvariable . t)))
  (lsp-register-custom-settings
   '(("gopls.completeUnimported" t t)
     ("gopls.staticcheck" t t)
     ("gopls.hints" ((assignVariableTypes . t)
                     (parameterNames . t)
                     (compositeLiteralFields . t)
                     (constantValues . t)
                     (functionTypeParameters . t)
                     (rangeVariableTypes . t))))))

(setq
    org-latex-pdf-process
    '("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
      "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
      "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

(setq org-latex-caption-above nil)

(with-eval-after-load 'ox-latex
  (add-to-list 'org-latex-classes
               '("pres"
                 "\\documentclass[presentation, aspectratio=54]{beamer}
\\usepackage[utf8]{inputenc}
\\usepackage[english,russian]{babel}
\\usepackage[T2A]{fontenc}
\\usepackage{mathtools}
\\usepackage{amsmath}
\\usepackage{tabu}
\\usepackage[margin=2cm]{geometry}
\\usetheme[height=20pt]{metropolis}
\\metroset{background=light,sectionpage=none,block=fill}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(add-to-list 'org-latex-classes
               '("lab"
                 "\\documentclass[a4paper,14pt,notitlepage]{extarticle}
\\usepackage[14pt]{extsizes}
\\usepackage[utf8]{inputenc}
\\usepackage{polyglossia}
\\setmainlanguage{russian}
\\setotherlanguage{english}
\\setkeys{russian}{babelshorthands=true}
\\setmainfont{Times New Roman}
\\setromanfont{Times New Roman}
\\setsansfont{Arial}
\\setmonofont{Courier New}
\\newfontfamily{\\cyrillicfont}{Times New Roman}
\\newfontfamily{\\cyrillicfontrm}{Times New Roman}
\\newfontfamily{\\cyrillicfonttt}{Courier New}
\\newfontfamily{\\cyrillicfontsf}{Arial}
\\usepackage[left=3cm,right=1.5cm,top=2cm,bottom=2cm]{geometry}
\\sloppy
\\usepackage{amsmath}
\\usepackage{graphicx}
\\usepackage{pdfpages}
\\usepackage{setspace}
\\usepackage{cmap}
\\usepackage{breakcites}
\\usepackage{apacite}
\\usepackage{natbib}
\\usepackage{paralist}

\\setdefaultenum{1.}
                             {1.1}
                             {1.1.1}
                             {1.1.1.1}
\\let\\itemize\\compactitem
\\let\\description\\compactdesc
\\let\\enumerate\\compactenum

% Настройка списка
\\renewcommand{\\labelitemi}{\\textbullet}
\\renewcommand{\\labelitemii}{-}
\\renewcommand{\\labelitemiii}{\\textbullet}
\\usepackage{indentfirst}
\\setlength{\\parindent}{1.25cm}
\\linespread{1.5}
\\usepackage{soul}
\\usepackage{microtype}
\\usepackage{titlesec}
\\titlespacing{\\section}{0pt}{0pt}{0pt}
\\titleformat*{\\section}{\\center\\bfseries}
\\titlespacing{\\subsection}{0pt}{0pt}{0pt}
\\titleformat*{\\subsection}{\\center\\bfseries}
\\usepackage[labelsep=endash]{caption}
\\captionsetup{justification=centering,tablename=Таблица,figurename=Рисунок}
\\usepackage{float}
\\let\\origfigure\\figure
\\let\\endorigfigure\\endfigure
\\renewenvironment{figure}[1][2] {\\expandafter\\origfigure\\expandafter[H]}{\\endorigfigure}
\\usepackage[T1,hyphens]{url}
\\usepackage{hyperref}
\\usepackage[nobiblatex]{xurl}
\\let\\stdsection\\section
\\renewcommand\\section{\\newpage\\stdsection}

\\pagenumbering{arabic}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

(setq org-directory "~/org/")

(use-package! org-modern
  :defer t
  :after (org)
  :init
  (global-org-modern-mode)
  (setq
   org-hide-emphasis-markers t
   org-pretty-entities t
   org-ellipsis " ▼"
   ;; org-modern-star '( "⌾" "✸" "◈" "◇")
   org-modern-list '((42 . "◦") (43 . "•") (45 . "➤"))
   org-modern-tag nil
   org-modern-priority nil
   org-modern-todo nil
   org-modern-table nil))

(custom-set-faces
 '(org-level-1 ((t (:inherit outline-1 :height 1.5))))
 '(org-level-2 ((t (:inherit outline-2 :height 1.3))))
 '(org-level-3 ((t (:inherit outline-3 :height 1.25))))
 '(org-level-4 ((t (:inherit outline-4 :height 1.15))))
 '(org-level-5 ((t (:inherit outline-5 :height 1.1)))))

(use-package org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))
