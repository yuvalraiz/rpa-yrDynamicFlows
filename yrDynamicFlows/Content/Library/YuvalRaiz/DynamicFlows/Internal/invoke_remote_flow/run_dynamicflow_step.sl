########################################################################################################################
#!!
#!!#
########################################################################################################################
namespace: YuvalRaiz.DynamicFlows.Internal.invoke_remote_flow
flow:
  name: run_dynamicflow_step
  inputs:
    - dbhost
    - dbport
    - dbusername
    - dbpassword:
        sensitive: true
    - dbname
    - plugin_id:
        required: true
    - input_hash
  workflow:
    - get_plugin:
        do:
          YuvalRaiz.DynamicFlows.Internal.db_retrieve_data.get_plugin:
            - dbhost: '${dbhost}'
            - dbport: '${dbport}'
            - dbusername: '${dbusername}'
            - dbpassword:
                value: '${dbpassword}'
                sensitive: true
            - dbname: '${dbname}'
            - plugin_name: '${plugin_id}'
        publish:
          - oohost
          - ooprotocol
          - ooport
          - oousername
          - oopassword
          - flow_name
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_plugin_inputs
    - get_plugin_inputs:
        do:
          YuvalRaiz.DynamicFlows.Internal.db_retrieve_data.get_plugin_inputs:
            - dbhost: '${dbhost}'
            - dbport: '${dbport}'
            - dbusername: '${dbusername}'
            - dbpassword:
                value: '${dbpassword}'
                sensitive: true
            - dbname: '${dbname}'
            - plugin_name: '${plugin_id}'
            - input_hash: '${input_hash}'
        publish:
          - input_section
          - secret_input_section
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - flow_status: '${flow_status}'
    - flow_outputs: '${flow_outputs}'
    - execution_id: '${execution_id}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_plugin:
        x: 74
        'y': 131
      get_plugin_inputs:
        x: 215
        'y': 134
        navigate:
          4aaf2a78-45c6-8be5-3ed6-7391312cf1a8:
            targetId: 93544d88-6895-a930-f906-b36d662cb45d
            port: SUCCESS
    results:
      SUCCESS:
        93544d88-6895-a930-f906-b36d662cb45d:
          x: 670
          'y': 133
