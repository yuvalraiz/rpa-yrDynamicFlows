namespace: yrTest
flow:
  name: Prompt
  inputs:
    - a:
        prompt:
          type: text
          message: Please select value
  workflow:
    - do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - input_0:
                prompt:
                  type: text
                  message: "${'please give value for %s:' % (a)}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      do_nothing:
        x: 223
        'y': 160
        navigate:
          2057198e-b3b4-843f-0f4f-0a6a78c6bfa1:
            targetId: d8c679f4-9dac-6964-76d3-7fcd6be0512d
            port: SUCCESS
    results:
      SUCCESS:
        d8c679f4-9dac-6964-76d3-7fcd6be0512d:
          x: 436
          'y': 128
