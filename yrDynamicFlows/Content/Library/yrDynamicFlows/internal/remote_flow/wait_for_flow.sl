########################################################################################################################
#!!
#!!#
########################################################################################################################
namespace: yrDynamicFlows.internal.remote_flow
flow:
  name: wait_for_flow
  inputs:
    - oohost
    - ooprotocol
    - ooport
    - oousername
    - oopassword:
        sensitive: true
    - execution_id
    - X_CSRF_TOKEN:
        required: false
  workflow:
    - set_base_url:
        do:
          io.cloudslang.base.utils.do_nothing:
            - base_url: "${'''%s://%s:%s/oo/rest/v2''' % (ooprotocol, oohost, ooport)}"
        publish:
          - base_url
        navigate:
          - SUCCESS: has_token
          - FAILURE: on_failure
    - get_exec_status:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'''%s/executions/%s/summary''' % (base_url,execution_id)}"
            - auth_type: basic
            - username: '${oousername}'
            - password:
                value: '${oopassword}'
                sensitive: true
            - trust_all_roots: 'true'
            - headers: |-
                ${'''X-CSRF-TOKEN: %s
                Content-Type: application/json''' % (X_CSRF_TOKEN)}
        publish:
          - running_status: "${cs_json_query(return_result,'$.[*].status')[2:-2]}"
          - flow_status: "${cs_json_query(return_result,'$.[*].resultStatusName')[2:-2]}"
        navigate:
          - SUCCESS: is_Running
          - FAILURE: on_failure
    - is_Running:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(running_status=='RUNNING')}"
        navigate:
          - 'TRUE': sleep
          - 'FALSE': is_Completed
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '30'
        navigate:
          - SUCCESS: get_exec_status
          - FAILURE: on_failure
    - is_Completed:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(running_status == 'COMPLETED')}"
        navigate:
          - 'TRUE': get_flow_outputs
          - 'FALSE': Run_Issue
    - get_flow_outputs:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'''%s/executions/%s/execution-log''' % (base_url,execution_id)}"
            - auth_type: basic
            - username: '${oousername}'
            - password:
                value: '${oopassword}'
                sensitive: true
            - trust_all_roots: 'true'
            - headers: |-
                ${'''X-CSRF-TOKEN: %s
                Content-Type: application/json''' % (X_CSRF_TOKEN)}
        publish:
          - flow_outputs: "${cs_json_query(return_result,'$.flowOutput')[1:-1]}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - authenticate:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'''%s/version''' % (base_url)}"
            - auth_type: basic
            - username: '${oousername}'
            - password:
                value: '${oopassword}'
                sensitive: true
            - trust_all_roots: 'true'
        publish:
          - X_CSRF_TOKEN: "${response_headers.split('X-CSRF-TOKEN: ')[1].split('\\n')[0]}"
        navigate:
          - SUCCESS: get_exec_status
          - FAILURE: on_failure
    - has_token:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${X_CSRF_TOKEN}'
        navigate:
          - IS_NULL: authenticate
          - IS_NOT_NULL: get_exec_status
  outputs:
    - flow_status: '${flow_status}'
    - flow_outputs: '${flow_outputs}'
  results:
    - SUCCESS
    - FAILURE
    - Run_Issue
extensions:
  graph:
    steps:
      set_base_url:
        x: 51
        'y': 80
      get_exec_status:
        x: 205
        'y': 280
      is_Running:
        x: 355
        'y': 289
      sleep:
        x: 311
        'y': 457
      is_Completed:
        x: 556
        'y': 289
        navigate:
          26ab0633-cf82-7fb1-6988-9d30e16d7b67:
            targetId: 199a6a69-a33b-004a-8566-644efccfc68e
            port: 'FALSE'
      get_flow_outputs:
        x: 746
        'y': 283
        navigate:
          540456a9-fbcc-75d4-7693-8b514c9f95f3:
            targetId: a0c13d2e-cf0e-7713-59c0-99d7b3e87a45
            port: SUCCESS
      authenticate:
        x: 338
        'y': 86
      has_token:
        x: 183
        'y': 85
    results:
      SUCCESS:
        a0c13d2e-cf0e-7713-59c0-99d7b3e87a45:
          x: 941
          'y': 281
      Run_Issue:
        199a6a69-a33b-004a-8566-644efccfc68e:
          x: 543
          'y': 456
