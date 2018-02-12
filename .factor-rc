USE: ui.theme.switching dark-mode
USE: math.matrices 
USE: english
USING: combinators eval kernel literals help.lint.coverage vocabs vocabs.parser vocabs.loader tools.test help.lint sequences system namespaces prettyprint.config ; 
IN: scratchpad

: wf ( name -- ) 
  { 
    [ reload ] 
    [ test ] 
    [ help-lint ] 
    $[ 
      "master" vm-git-ref subseq? 
      [ [ "USE: help.lint.coverage \\ vocab-help-coverage." eval( -- x ) execute( x -- ) ] ] 
      [ [ <vocab-help-coverage> "USE: help.lint.coverage \\ print-coverage" eval( -- x ) execute( x -- ) ] ]
      if      
    ]
  } cleave ; inline 

length-limit 400 set
string-limit? f set
boa-tuples? t set
c-object-pointers? t set


