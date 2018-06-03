USE: ui.theme.switching dark-mode
USING: ui.tools.listener system io.encodings.utf8 io.pathnames io io.launcher io.directories combinators threads eval kernel literals help.lint.coverage vocabs vocabs.parser vocabs.loader tools.test help.lint sequences system namespaces prettyprint.config ;
IN: scratchpad

: wf ( name -- )
  {
    [ reload ]
    [ test ]
    [ help-lint ]
    $[ image-path parent-directory [
        "git rev-parse --abbrev-ref HEAD" utf8 [ contents ] with-process-reader
      ] with-directory "matrices" swap subseq?
      [ <vocab-help-coverage> "USE: help.lint.coverage \\ print-coverage" eval( -- x ) execute( x -- ) ]
      [ "USE: help.lint.coverage \\ vocab-help-coverage." eval( -- x ) execute( x -- ) ]
      ?
    ]
  } cleave ; inline

400 length-limit set-global
f string-limit? set-global
t boa-tuples? set-global
t c-object-pointers? set-global
[ .3 sleep "monospace" 10 set-listener-font ] in-thread
