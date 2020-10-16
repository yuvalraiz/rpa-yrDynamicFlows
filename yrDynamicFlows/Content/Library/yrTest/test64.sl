namespace: yrTest
flow:
  name: test64
  inputs:
    - input1
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
        publish:
          - data: '${result}'
        navigate:
          - SUCCESS: do_nothing
          - FAILURE: on_failure
    - do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - data: '${input1}'
        publish:
          - output_0: '${base64.b64decode(data)}'
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
        x: 94
        'y': 150
      base64_decoder:
        x: 283
        'y': 154
      do_nothing:
        x: 345
        'y': 353
        navigate:
          5dc37d33-9e02-2c2a-7171-91900832dd19:
            targetId: 6f51f491-8da0-5791-b4b3-0914dba80cd0
            port: SUCCESS
    results:
      SUCCESS:
        6f51f491-8da0-5791-b4b3-0914dba80cd0:
          x: 482
          'y': 150
