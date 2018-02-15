USE: ui.theme.switching dark-mode
USING: combinators eval kernel literals help.lint.coverage vocabs vocabs.parser vocabs.loader tools.test help.lint sequences system namespaces prettyprint.config ; 
IN: scratchpad 

: wf ( name -- )
  {
    [ reload ]
    [ test ]
    [ help-lint ]
    $[ "matrices" vm-git-ref subseq? 
      [ <vocab-help-coverage> "USE: help.lint.coverage \\ print-coverage" eval( -- x ) execute( x -- ) ]
      [ \ <vocab-help-coverage> "USE: help.lint.coverage \\ print-coverage" eval( x -- ) execute( x -- ) ]
      ?
    ]
  } cleave ; inline

length-limit 400 set
string-limit? f set
boa-tuples? t set
c-object-pointers? t set

