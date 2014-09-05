;; emacs el : epicsdb_mode.el
;; Author   : Jeong Han Lee
;; email    : jhlee@ibs.re.kr
;; Date     : Friday, September  5 13:17:02 KST 2014
;; version  : 0.0.1
;;
;; 0.0.1    : Friday, September  5 13:17:37 KST 2014
;;            created


;; The references for writing this codes are 
;; 1) http://ergoemacs.org/emacs/elisp_syntax_coloring.html
;; 2) http://www.emacswiki.org/emacs/SampleMode


;; I intend to develop this emacs mode file for EPICS db, vdb, and dbd files,
;; because I cannot find any syntax highlighting feature in the EPICS community.
;;
;; 1) put this file in ${HOME}/.emacs.d/
;; 2) add the following lines in ${HOME}/.emacs 
;;    (load-file "$HOME/.emacs.d/epicsdb-mode.el")
;;    (require 'epicsdb-mode)



;; define several class of keywords
(setq epicsdb-keywords 
      '(
	"path"
	"addpath"
	"include"
	"menu"
	"choice"
	"recordtype"
	"field"
	"device"
	"driver"
	"registrar"
	"function"
	"variable"
	"breaktable"
	"record"
	"grecord"
	"info"
	"alias")
      )

;;
;; EPICS Record Type https://wiki-ext.aps.anl.gov/epics/index.php/RRM_3-14
;;
(setq epicsdb-types 
      '(
	"aai"
	"aao"
	"ai" 
	"ao"
	"aSub"
	"bi" 
	"bo" 
	"calc"
	"calcout"
	"compress"
	"dfanout"
	"event"
	"fanout"
	"histogram"
	"longin"
	"longout"
	"mbbi"
	"mbbiDirect"
	"mbbo"
	"mbbodirect"
	"permissive"
	"sel"
	"seq"
	"state"
	"stringin"
	"stringout"
	"subArray"
	"sub"
	"waveform"
	)
      )

;;
;; EPICS Field Commons https://wiki-ext.aps.anl.gov/epics/index.php/RRM_3-14_dbCommon
;;
(setq epicsdb-constants 
      '(
	;; SCAN Fields
	"SCAN"
	"PINI"
	"PHAS"
	"EVNT"
	"PRIO"
	"DISV"
	"DISA"
	"SDIS"
	"PROC"
	"DISS"
	"LCNT"
	"PACT"
	"FLNK"
	"SPVT"
	;; ALAM Fields
	"STAT"
	"SEVR"
	"NSTA"
	"NSEV"
	"ACKS"
	"ACKT"
	"UDF"
	;; Device Fields
	"RSET"
	"DSET"
	"DPVT"
	;; Debugging Fields
	"TPRO"
	"BKPT"
	;; Miscellaneous Field
	"NAME"
	"DESC"
	"ASG"
	"TSE"
	"TSEL"
	"DTYP"
	"MLOK"
	"MLIS"
	"DISP"
	"PUTF"
	"RPRO"
	"ASP"
	"PPN"
	"PPNR"
	"RDES"
	"TIME"
	;; Input Records, Common Fields
	"INP"
	"DTYP"
	"RVAL"
	"VAL"
	"SIMM"
	"SIML"
	"SVAL"
	"SIOL"
	"SIMS"
	"OUT"
	"OVA"
	;; Output Records, Common Fields
	"OUT"
;;	"DTYP"
;;	"VAL"
	"OVAL"
	"RVAL"
	"RBV"
	"DOL"
	"OMSL"
	"OIF"
;;	"SIMM"
;;	"SIML"
;;	"SIOL"
;;	"SIMS"
	"IVOA"
	"IVOV"
	;; AI Records
;;	"VAL"
;;	"INP"
;;	"DTYP"
	"LINR"
;;	"RVAL"
	"ROFF"
	"EGUF"
;;	"EGUL"
	"AOFF"
	"ASLO"
	"ESLO"
	"EOFF"
	"SMOO"
	"EGU"
	"HOPR"
	"LOPR"
	"PREC"
;;	"NAME"
;;	"DESC"
	"HIHI"
	"LOLO"
	"HIGH"
	"LOW"
	"HSV"
	"HHSV"
	"LLSV"
	"LSV"
	"HYST"
	"ADEL"
	"MDEL"
	"ORAW"
	"LAIM"
	"ALST"
	"MLST"
	"INIT"
	"PBRK"
	"LBRK"
;;	"PACT"
	"DPVT"
	"UDF"
	"NSEV"
	"NSTA"
;;	"EGUF"
	"EGUL"
	"ESLO"
	"EOFF"
;;	"RVAL"
;; AO
	"OMSL"
	"DOL"
	"OIF"
	"DRVH"
	"DRVL"
	"OROC"
;;	"OVAL"
	"ORBV"
	"LALM"
	"ALST"
	"MLST"
	"PBRK"
	"LBRK"
	"OMOD"
;;	"PACT"
	"DPVT"
;;  aSub;; calcout /calc
	"LFLG"
	"EFLG"
	"SUBL"
	"INAM"
	"SNAM"
	"ONAM"
	"SADR"
	"BRSV"
	"PREC"
	"INPA"
	"INPB"
	"INPC"
	"INPD"
	"INPE"
	"INPF"
	"INPG"
	"INPH"
	"INPI"
	"INPJ"
	"INPK"
	"INPL"
	"INPN"
	"INPM"
	"INPO"
	"INPP"
	"INPQ"
	"INPR"
	"INPS"
	"INPT"
	"INPU"
	"CALC"
	"RPCL"
	"OCAL"
	"DOPT"
	"INAV"
	"INBV"
	"INCV"
	"INDV"
	"INEV"
	"INFV"
	"INGV"
	"INHV"
	"INIV"
	"INJV"
	"INLV"
	"OUTV"
	"CLCV"
	"OCLV"
	"DLYA"
	"HYST"
	"A"
	"B"
	"C"
	"D"
	"E"
	"F"
	"G"
	"H"
	"I"
	"J"
	"K"
	"L"
	"M"
	"N"
	"O"
	"P"
	"Q"
	"R"
	"S"
	"T"
	"U"
;;
	"FTA"
	"FTB"
	"FTC"
	"FTD"
	"FTE"
	"FTF"
	"FTG"
	"FTH"
	"FTI"
	"FTJ"
	"FTK"
	"FTL"
	"FTM"
	"FTN"
	"FTO"
	"FTP"
	"FTQ"
	"FTR"
	"FTS"
	"FTT"
	"FTU"
;;
	"NOA"
	"NOB"
	"NOC"
	"NOD"
	"NOE"
	"NOF"
	"NOG"
	"NOH"
	"NOI"
	"NOJ"
	"NOK"
	"NOL"
	"NOM"
	"NON"
	"NOO"
	"NOP"
	"NOQ"
	"NOR"
	"NOS"
	"NOT"
	"NOU"
;;
	"NEA"
	"NEB"
	"NEC"
	"NED"
	"NEE"
	"NEF"
	"NEG"
	"NEH"
	"NEI"
	"NEJ"
	"NEK"
	"NEL"
	"NEM"
	"NEN"
	"NEO"
	"NEP"
	"NEQ"
	"NER"
	"NES"
	"NET"
	"NEU"
;;
	"OUTA"
	"OUTB"
	"OUTC"
	"OUTD"
	"OUTE"
	"OUTF"
	"OUTG"
	"OUTH"
	"OUTI"
	"OUTJ"
	"OUTK"
	"OUTL"
	"OUTM"
	"OUTN"
	"OUTO"
	"OUTP"
	"OUTQ"
	"OUTR"
	"OUTS"
	"OUTT"
	"OUTU"
;;
	"VALA"
	"VALB"
	"VALC"
	"VALD"
	"VALE"
	"VALF"
	"VALG"
	"VALH"
	"VALI"
	"VALJ"
	"VALK"
	"VALL"
	"VALM"
	"VALN"
	"VALO"
	"VALP"
	"VALQ"
	"VALR"
	"VALS"
	"VALT"
	"VALU"
;;
	"OVLA"
	"OVLB"
	"OVLC"
	"OVLD"
	"OVLE"
	"OVLF"
	"OVLG"
	"OVLH"
	"OVLI"
	"OVLJ"
	"OVLK"
	"OVLL"
	"OVLM"
	"OVLN"
	"OVLO"
	"OVLP"
	"OVLQ"
	"OVLR"
	"OVLS"
	"OVLT"
	"OVLU"
;;
	"NEVA"
	"NEVB"
	"NEVC"
	"NEVD"
	"NEVE"
	"NEVF"
	"NEVG"
	"NEVH"
	"NEVI"
	"NEVJ"
	"NEVK"
	"NEVL"
	"NEVM"
	"NEVN"
	"NEVO"
	"NEVP"
	"NEVQ"
	"NEVR"
	"NEVS"
	"NEVT"
	"NEVU"

	"LFLG"
	"EFLG"
	"SUBL"
	"INAM"
	"SNAM"
	"ONAM"
	"SADR"
	"BRSV"
	

	"OOPT"
	"DOPT"
	"OCAL"
	"OVAL"
	"OEVT"
	"ODLY"
	"IVOA"
	"IVOV"
	;; MBBO
	"MASK"
	"NOBT"
	"SHFT"
	"ZRVL"
	"ONVL"
	"TWVL"
	"THVL"
	"FRVL"
	"FVVL"
	"SXVL"
	"SVVL"
	"EIVL"
	"NIVL"
	"TEVL"
	"ELVL"
	"TVVL"
	"TTVL"
	"FTVL"
	"FFVL"
	"ZRST"
	"ONST"
	"TWST"
	"THST"
	"FRST"
	"FVST"
	"SXST"
	"SVST"
	"EIST"
	"NIST"
	"TEST"
	"ELST"
	"TVST"
	"TTST"
	"FTST"
	"FFST"
	"UNSV"
	"COSV"
	"ZRSV"
	"ONSV"
	"TWSV"
	"THSV"
	"FRSV"
	"FVSV"
	"SXSV"
	"SVSV"
	"EISV"
	"NISV"
	"TESV"
	"ELSV"
	"TVSV"
	"FTSV"
	"FFSV"
	"ORAW"
	"LALM"
	"MLST"
	"SDEF"
;;	"PACT"
	"DPVT"
	"UDF"
	"NOBT"
	"MASK"
	"SHFT"
	;; seq
	"DOL1"
	"DOL2"
	"DOL3"
	"DOL4"
	"DOL5"
	"DOL6"
	"DOL7"
	"DOL8"
	"DOL9"
	"DOLA"
	"DO1"
	"DO2"
	"DO3"
	"DO4"
	"DO5"
	"DO6"
	"DO7"
	"DO8"
	"DO9"
	"DOA"
	"LNK1"
	"LNK2"	
	"LNK3"
	"LNK4"	
	"LNK5"
	"LNK6"	
	"LNK7"
	"LNK8"	
	"LNK9"
	"LNKA"	
	"DLY1"
	"DLY2"
	"DLY3"
	"DLY4"
	"DLY5"
	"DLY6"
	"DLY7"
	"DLY8"
	"DLY9"
	"DLYA"
	"SELM"
	"SELN"
	"SELL"

	"ZNAM"
	"ZSV"
	"MPST"
	"APST"
	"NELM"
	)
      )

;; (setq epicsdb-events '("at_rot_target" "at_target" "attach"))
;; (setq epicsdb-functions '("test"))

;; create the regex string for each class of keywords
;;(setq epicsdb-comments-regexp  (regexp-opt epicsdb-comments  'words))

(setq epicsdb-keywords-regexp  (regexp-opt epicsdb-keywords  'words))
(setq epicsdb-type-regexp      (regexp-opt epicsdb-types     'words))
(setq epicsdb-constants-regexp (regexp-opt epicsdb-constants 'words))

;; (setq epicsdb-event-regexp     (regexp-opt epicsdb-events    'words))
;; (setq epicsdb-functions-regexp (regexp-opt epicsdb-functions 'words))


;; clear memory
;;(setq epicsdb-comments nil)
(setq epicsdb-keywords nil)
(setq epicsdb-types nil)
(setq epicsdb-constants nil)

;;(setq epicsdb-events nil)
;;(setq epicsdb-functions nil)



(defvar epicsdb-mode-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax-entry ?# "<" st)
    (modify-syntax-entry ?\n ">" st)
    st)
  "Syntax table for `epicsdb-mode'."
  )


;;
;; http://www.gnu.org/software/emacs/manual/html_node/elisp/Faces-for-Font-Lock.html
;;
;; font-lock-warning-face
;; font-lock-function-name-face
;; font-lock-variable-name-face
;; font-lock-keyword-face
;; font-lock-comment-face
;; font-lock-comment-delimiter-face
;; font-lock-type-face
;; font-lock-constant-face
;; font-lock-builtin-face
;; font-lock-preprocessor-face
;; font-lock-string-face
;; font-lock-doc-face
;; font-lock-negation-char-face


(setq epicsdb-font-lock-keywords
  `(
    ;;    (,epicsdb-comments-regexp    . font-lock-type-comment-face)
    (,epicsdb-type-regexp       . font-lock-type-face)
    (,epicsdb-constants-regexp   . font-lock-constant-face)
    ;;    (,epicsdb-event-regexp      . font-lock-builtin-face)
    ;;    (,epicsdb-functions-regexp  . font-lock-function-name-face)
    (,epicsdb-keywords-regexp   . font-lock-keyword-face)
    ;; note: order above matters. “epicsdb-keywords-regexp” goes last because
    ;; otherwise the keyword “state” in the function “state_entry”
    ;; would be highlighted.
))

;;
;; vdb, db, dbd
;; http://www.emacswiki.org/emacs/AutoModeAlist

(add-to-list 'auto-mode-alist '("\\.*db*\\'" . epicsdb-mode))
;;(add-to-list 'auto-mode-alist '("\\.db\\'" . epicsdb-mode))
;;(add-to-list 'auto-mode-alist '("\\.dbd\\'" . epicsdb-mode))


;; define the mode
(define-derived-mode epicsdb-mode c-mode
  "epicsdb mode"
  "Major mode for editing Epics DB…"
  :syntax-table epicsdb-mode-syntax-table
  ;; cofe for syntax highlighting
  (setq font-lock-defaults '((epicsdb-font-lock-keywords)))
  (setq comment-start "#")
  (setq comment-start-skip "#+\\s-*")
  ;; clear memory
  (setq epicsdb-keywords-regexp nil)
  (setq epicsdb-types-regexp nil)
  (setq epicsdb-constants-regexp nil)
  (setq epicsdb-events-regexp nil)
  (setq epicsdb-functions-regexp nil)
)

(provide 'epicsdb-mode)