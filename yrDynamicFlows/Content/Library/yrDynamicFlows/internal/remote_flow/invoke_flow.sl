########################################################################################################################
#!!
#! @input flow_inputs: , seperated as part of json object with out the { }
#! @input wait_to_finish: true, false
#!!#
########################################################################################################################
namespace: yrDynamicFlows.internal.remote_flow
flow:
  name: invoke_flow
  inputs:
    - oohost: rpa.mfdemos.com
    - ooprotocol: https
    - ooport: '8443'
    - oousername: yuval.raiz
    - oopassword:
        sensitive: true
    - flow_name: YuvalRaiz.Demo.Sales_Commission.GetTotalCommissionForAM
    - flow_inputs:
        default: 'account_manager": "Yuval Raiz'
        required: false
    - flow_secret_inputs:
        default: "${'''\"a\": \"b\"'''}"
        required: false
        sensitive: true
    - wait_to_finish:
        required: false
    - run_sync:
        default: "${get(wait_to_finish,'true')}"
        private: true
        required: false
  workflow:
    - set_base_url:
        do:
          io.cloudslang.base.utils.do_nothing:
            - base_url: "${'''%s://%s:%s/oo/rest/v2''' % (ooprotocol, oohost, ooport)}"
            - flow_merge_inputs: '${flow_inputs}'
        publish:
          - base_url
          - flow_merge_inputs
        navigate:
          - SUCCESS: is_null
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
          - SUCCESS: execute
          - FAILURE: on_failure
    - execute:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${'''%s/executions''' % (base_url)}"
            - auth_type: basic
            - username: '${oousername}'
            - password:
                value: '${oopassword}'
                sensitive: true
            - trust_all_roots: 'true'
            - headers: |-
                ${'''X-CSRF-TOKEN: %s
                Content-Type: application/json''' % (X_CSRF_TOKEN)}
            - body: |-
                ${'''{
                "flowUuid": "%s",
                "runName": "DynamicTest",
                "inputs": {
                %s
                }
                }''' % (flow_name,flow_inputs)}
            - content_type: application/json
        publish:
          - status_code
          - execution_id: '${return_result}'
        navigate:
          - SUCCESS: is_invoked_OK
          - FAILURE: on_failure
    - is_invoked_OK:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(status_code == '201')}"
        navigate:
          - 'TRUE': is_wait_for_finish
          - 'FALSE': FAILURE_INVOKE
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${flow_secret_inputs}'
        navigate:
          - IS_NULL: authenticate
          - IS_NOT_NULL: merge_secret_inputs
    - merge_secret_inputs:
        do:
          io.cloudslang.base.utils.do_nothing:
            - flow_merge_inputs: "${'''%s%s%s''' % ('' if flow_inputs is None else flow_inputs, '' if flow_inputs is None else ',', flow_secret_inputs)}"
        publish:
          - flow_merge_inputs
        navigate:
          - SUCCESS: authenticate
          - FAILURE: on_failure
    - is_wait_for_finish:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${run_sync}'
        navigate:
          - 'TRUE': wait_for_flow
          - 'FALSE': SUCCESS
    - wait_for_flow:
        do:
          yrDynamicFlows.internal.remote_flow.wait_for_flow:
            - oohost: '${oohost}'
            - ooprotocol: '${ooprotocol}'
            - ooport: '${ooport}'
            - oousername: '${oousername}'
            - oopassword:
                value: '${oopassword}'
                sensitive: true
            - execution_id: '${execution_id}'
            - X_CSRF_TOKEN: '${X_CSRF_TOKEN}'
        publish:
          - flow_status
          - flow_outputs
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
          - Run_Issue: Run_Issue
  outputs:
    - flow_status: '${flow_status}'
    - flow_outputs: '${flow_outputs}'
    - execution_id: '${execution_id}'
  results:
    - SUCCESS
    - FAILURE_INVOKE
    - FAILURE
    - Run_Issue
extensions:
  graph:
    steps:
      set_base_url:
        x: 17
        'y': 74
      authenticate:
        x: 248
        'y': 225
      execute:
        x: 380
        'y': 225
      is_invoked_OK:
        x: 510
        'y': 235
        navigate:
          c89a761e-763e-82a2-af41-f790c9ce6323:
            targetId: 7e19ce07-523b-3908-7139-fc633c459bb3
            port: 'FALSE'
      is_null:
        x: 172
        'y': 70
      merge_secret_inputs:
        x: 338
        'y': 68
      is_wait_for_finish:
        x: 661
        'y': 234
        navigate:
          93f3a45c-0004-042b-322d-489732f9779d:
            targetId: a0c13d2e-cf0e-7713-59c0-99d7b3e87a45
            port: 'FALSE'
      wait_for_flow:
        x: 658
        'y': 394
        navigate:
          3d205545-e158-e1c7-a5d3-705ff282e359:
            targetId: a0c13d2e-cf0e-7713-59c0-99d7b3e87a45
            port: SUCCESS
          8d53a3eb-5fa7-ba03-b9b3-9d2ded2524f7:
            targetId: 199a6a69-a33b-004a-8566-644efccfc68e
            port: Run_Issue
    results:
      SUCCESS:
        a0c13d2e-cf0e-7713-59c0-99d7b3e87a45:
          x: 807
          'y': 297
      FAILURE_INVOKE:
        7e19ce07-523b-3908-7139-fc633c459bb3:
          x: 445
          'y': 564
      Run_Issue:
        199a6a69-a33b-004a-8566-644efccfc68e:
          x: 666
          'y': 561
