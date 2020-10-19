namespace: YuvalRaiz.DynamicFlows.Configure
flow:
  name: _DynamicFlows_Plugin_set_Input_from_jsom
  inputs:
    - dbhost
    - dbport
    - dbusername
    - dbpassword:
        sensitive: true
    - dbname
    - plugin_id
    - input_name
    - json_data
  workflow:
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_data}'
            - json_path: "${'''$..[?(@.name==\"%s\")]''' % (input_name)}"
        publish:
          - json_obj: '${return_result}'
        navigate:
          - SUCCESS: DynamicFlows_Plugin_set_Input
          - FAILURE: on_failure
    - DynamicFlows_Plugin_set_Input:
        do:
          YuvalRaiz.DynamicFlows.Configure.DynamicFlows_Plugin_set_Input:
            - dbhost: '${dbhost}'
            - dbport: '${dbport}'
            - dbusername: '${dbusername}'
            - dbpassword:
                value: '${dbpassword}'
                sensitive: true
            - dbname: '${dbname}'
            - plugin_id: '${plugin_id}'
            - input_name: '${input_name}'
            - encrypted: "${cs_json_query(json_obj,'$..encrypted')[1:-1]}"
            - mandatory: "${cs_json_query(json_obj,'$..mandatory')[1:-1]}"
            - defaultValue: "${cs_json_query(json_obj,'$..defaultValue')[1:-1]}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      json_path_query:
        x: 41
        'y': 186
      DynamicFlows_Plugin_set_Input:
        x: 270
        'y': 195
        navigate:
          3b9eac5a-bca4-53e8-5557-f241a9e7e4fb:
            targetId: 3d74ccd9-a1ba-e0a4-963b-1f3422773e84
            port: SUCCESS
    results:
      SUCCESS:
        3d74ccd9-a1ba-e0a4-963b-1f3422773e84:
          x: 485
          'y': 168
