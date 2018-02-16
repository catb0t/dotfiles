USE: ui.theme.switching dark-mode
USING: system io.encodings.utf8 io.pathnames io io.launcher io.directories combinators eval kernel literals help.lint.coverage vocabs vocabs.parser vocabs.loader tools.test help.lint sequences system namespaces prettyprint.config ; 
IN: scratchpad 

: wf ( name -- )
  {
    [ reload ]
    [ test ]
    [ help-lint ]
    $[ image-path parent-directory [ "git rev-parse --abbrev-ref HEAD" utf8 [ contents ] with-process-reader ] with-directory "matrices" subseq? 
      [ <vocab-help-coverage> "USE: help.lint.coverage \\ print-coverage" eval( -- x ) execute( x -- ) ]
      [ "USE: help.lint.coverage \\ vocab-help-coverage." eval( -- x ) execute( x -- ) ]
      ?
    ]
  } cleave ; inline

length-limit 400 set
string-limit? f set
boa-tuples? t set
c-object-pointers? t set

