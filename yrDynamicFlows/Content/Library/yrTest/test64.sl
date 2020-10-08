namespace: yrTest
flow:
  name: test64
  inputs:
    - input1: yuval
  workflow:
    - base64_encoder:
        do:
          io.cloudslang.base.utils.base64_encoder:
            - data: '${input1}'
        publish:
          - result
        navigate:
          - SUCCESS: base64_decoder
          - FAILURE: on_failure
    - base64_decoder:
        do:
          io.cloudslang.base.utils.base64_decoder:
            - data: '${result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      base64_encoder:
        x: 95
        'y': 150
      base64_decoder:
        x: 283
        'y': 154
        navigate:
          4621c631-98da-6c12-afad-2eeae9755322:
            targetId: 6f51f491-8da0-5791-b4b3-0914dba80cd0
            port: SUCCESS
    results:
      SUCCESS:
        6f51f491-8da0-5791-b4b3-0914dba80cd0:
          x: 482
          'y': 150
