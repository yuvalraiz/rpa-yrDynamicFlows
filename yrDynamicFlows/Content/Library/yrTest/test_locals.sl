namespace: yrTest
operation:
  name: test_locals
  python_action:
    use_jython: false
    script: "# do not remove the execute function \ndef execute(): \n    a='yuval'\n    b='raiz'\n    c=locals()\n    d=globals()\n    return locals()\n    \n    # code goes here\n# you can add additional helper methods below."
  outputs:
    - a
    - c
    - d
  results:
    - SUCCESS
