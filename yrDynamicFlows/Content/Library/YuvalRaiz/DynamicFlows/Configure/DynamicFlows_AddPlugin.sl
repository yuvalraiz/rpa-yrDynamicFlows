namespace: YuvalRaiz.DynamicFlows.Configure
flow:
  name: DynamicFlows_AddPlugin
  inputs:
    - dbhost: db.mfdemos.com
    - dbport: '5432'
    - dbusername: postgres
    - dbpassword:
        sensitive: true
    - dbname: yrDynamicRunning
    - plugin_id: MFDemos_AddUserToGroup
    - central_id: yuval.raiz-rpa.mfdemos.com
    - flow_uuid: MFDemos.UserManagement.plugins.openldap_add_user_to_group
  workflow:
    - get_central:
        do:
          YuvalRaiz.DynamicFlows.Internal.db_retrieve_data.get_central:
            - dbhost: '${dbhost}'
            - dbport: '${dbport}'
            - dbusername: '${dbusername}'
            - dbpassword:
                value: '${dbpassword}'
                sensitive: true
            - dbname: '${dbname}'
            - central_id: '${central_id}'
        publish:
          - oohost
          - ooprotocol
          - ooport
          - oousername
          - oopassword
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_flow_inputs
    - get_flow_inputs:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'''%s://%s:%s/oo/rest/flows/%s/inputs''' % (ooprotocol, oohost, ooport,flow_uuid)}"
            - auth_type: basic
            - username: '${oousername}'
            - password:
                value: '${oopassword}'
                sensitive: true
            - trust_all_roots: 'true'
        publish:
          - return_code
          - input_list: "${cs_json_query(return_result,'$..name')}"
          - input_json_data: '${return_result}'
        navigate:
          - SUCCESS: is_flow_exists
          - FAILURE: on_failure
    - sql_command_1:
        do:
          io.cloudslang.base.database.sql_command:
            - db_server_name: '${dbhost}'
            - db_type: PostgreSQL
            - username: '${dbusername}'
            - password:
                value: '${dbpassword}'
                sensitive: true
            - instance: null
            - db_port: '${dbport}'
            - database_name: '${dbname}'
            - db_url: '${"jdbc:postgresql://%s:%s/%s" % (dbhost,dbport,dbname)}'
            - command: "${'''insert into plugins (plugin_id, flow_uuid, central_id) values ('%s', '%s','%s')''' % (plugin_id, flow_uuid, central_id)}"
            - trust_all_roots: 'true'
        navigate:
          - SUCCESS: _DynamicFlows_Plugin_set_Input_from_jsom
          - FAILURE: on_failure
    - is_flow_exists:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(return_code =='200')}"
        navigate:
          - 'TRUE': FAILURE
          - 'FALSE': sql_command_1
    - _DynamicFlows_Plugin_set_Input_from_jsom:
        loop:
          for: in_name in eval(input_list)
          do:
            YuvalRaiz.DynamicFlows.Configure._DynamicFlows_Plugin_set_Input_from_jsom:
              - dbhost: '${dbhost}'
              - dbport: '${dbport}'
              - dbusername: '${dbusername}'
              - dbpassword:
                  value: '${dbpassword}'
                  sensitive: true
              - dbname: '${dbname}'
              - plugin_id: '${plugin_id}'
              - input_name: '${in_name}'
              - json_data: '${input_json_data}'
          break:
            - FAILURE
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_central:
        x: 40
        'y': 118
      get_flow_inputs:
        x: 195
        'y': 118
      sql_command_1:
        x: 451
        'y': 142
      is_flow_exists:
        x: 327
        'y': 133
        navigate:
          81ccd218-ee7d-ee17-1419-84cfc1c7b7cc:
            targetId: b2425d40-5316-0d28-a648-4b5c7c60cab7
            port: 'TRUE'
      _DynamicFlows_Plugin_set_Input_from_jsom:
        x: 667
        'y': 129
        navigate:
          18e96e58-dbc9-9c7f-1c62-41779b50decb:
            targetId: 071584c5-4d33-b1b1-3a03-5445a61079ad
            port: SUCCESS
    results:
      SUCCESS:
        071584c5-4d33-b1b1-3a03-5445a61079ad:
          x: 1023
          'y': 135
      FAILURE:
        b2425d40-5316-0d28-a648-4b5c7c60cab7:
          x: 331
          'y': 346
