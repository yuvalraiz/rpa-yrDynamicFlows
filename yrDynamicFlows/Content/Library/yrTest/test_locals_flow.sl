namespace: yrTest
flow:
  name: test_locals_flow
  workflow:
    - test_locals:
        do:
          yrTest.test_locals:
            - input_0: aaa
        publish:
          - a
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      test_locals:
        x: 206
        'y': 130
        navigate:
          af08a2e7-e792-b7bd-2f31-e5237f64f39a:
            targetId: aef928c4-5904-f601-97fb-3168fb5a8c9e
            port: SUCCESS
    results:
      SUCCESS:
        aef928c4-5904-f601-97fb-3168fb5a8c9e:
          x: 346
          'y': 87
