namespace: yrTest
flow:
  name: mergeSensetive
  inputs:
    - flow_inputs_contain: "${'''\"user\": \"yuval.raiz\"'''}"
    - flow_inputs_empty:
        required: false
        sensitive: false
    - flow_secret_inputs_contain:
        default: "${'''\"password\": \"1234\"'''}"
        required: false
        sensitive: true
    - flow_secret_inputs_empty:
        required: false
        sensitive: true
  workflow:
    - c_c:
        do:
          io.cloudslang.base.utils.do_nothing:
            - flow_inputs: '${flow_inputs_contain}'
            - flow_secret_inputs: '${flow_secret_inputs_contain}'
        publish:
          - c_c: "${'''%s%s%s''' % ('' if flow_inputs is None else flow_inputs, '' if flow_inputs is None or flow_secret_inputs is None else ',', '' if flow_secret_inputs is None else flow_secret_inputs)}"
        navigate:
          - SUCCESS: c_e
          - FAILURE: on_failure
    - c_e:
        do:
          io.cloudslang.base.utils.do_nothing:
            - flow_inputs: '${flow_inputs_contain}'
            - flow_secret_inputs: '${flow_secret_inputs_empty}'
        publish:
          - c_e: "${'''%s%s%s''' % ('' if flow_inputs is None else flow_inputs, '' if flow_inputs is None or flow_secret_inputs is None else ',', '' if flow_secret_inputs is None else flow_secret_inputs)}"
        navigate:
          - SUCCESS: e_c
          - FAILURE: on_failure
    - e_c:
        do:
          io.cloudslang.base.utils.do_nothing:
            - flow_inputs: '${flow_inputs_empty}'
            - flow_secret_inputs: '${flow_secret_inputs_contain}'
        publish:
          - e_c: "${'''%s%s%s''' % ('' if flow_inputs is None else flow_inputs, '' if flow_inputs is None or flow_secret_inputs is None else ',', '' if flow_secret_inputs is None else flow_secret_inputs)}"
        navigate:
          - SUCCESS: e_e
          - FAILURE: on_failure
    - e_e:
        do:
          io.cloudslang.base.utils.do_nothing:
            - flow_inputs: '${flow_inputs_empty}'
            - flow_secret_inputs: '${flow_secret_inputs_empty}'
        publish:
          - e_e: "${'''%s%s%s''' % ('' if flow_inputs is None else flow_inputs, '' if flow_inputs is None or flow_secret_inputs is None else ',', '' if flow_secret_inputs is None else flow_secret_inputs)}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - c_c
    - c_e
    - e_c
    - e_e
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      e_e:
        x: 421
        'y': 93
        navigate:
          37dc1f6f-98c8-9891-69ec-187609d64395:
            targetId: 39cd6a00-c50e-b526-33e8-35376869911b
            port: SUCCESS
      c_c:
        x: 38
        'y': 81
      e_c:
        x: 303
        'y': 88
      c_e:
        x: 171
        'y': 82
    results:
      SUCCESS:
        39cd6a00-c50e-b526-33e8-35376869911b:
          x: 600
          'y': 95
