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
    - plugin_id
    - central_id: yuval.raiz-rpa.mfdemos.com
    - flow_uuid: YuvalRaiz.mailu.mailu_create_alias
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
            - url: "${'''%s://%s:%s/oo/rest/flows/%s/inputsn''' % (ooprotocol, oohost, ooport,flow_uuid)}"
            - auth_type: basic
            - username: '${oousername}'
            - password:
                value: '${oopassword}'
                sensitive: true
            - trust_all_roots: 'true'
        publish:
          - X_CSRF_TOKEN: "${response_headers.split('X-CSRF-TOKEN: ')[1].split('\\n')[0]}"
          - return_code
        navigate:
          - SUCCESS: is_flow_exists
          - FAILURE: on_failure
    - enc_password:
        do:
          io.cloudslang.base.utils.base64_encoder:
            - data: '${oopassword}'
        publish:
          - oopassword:
              value: '${result}'
              sensitive: true
        navigate:
          - SUCCESS: sql_command
          - FAILURE: on_failure
    - sql_command:
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
            - command: "${'''insert into centrals (id, host, protocol, port, username, password) values ('%s', '%s','%s','%s','%s','%s' )''' % (central_id, oohost, ooprotocol,ooport,oousername,oopassword)}"
            - trust_all_roots: 'true'
        navigate:
          - SUCCESS: SUCCESS
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
          - SUCCESS: enc_password
          - FAILURE: on_failure
    - is_flow_exists:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(return_code =='200')}"
        navigate:
          - 'TRUE': sql_command_1
          - 'FALSE': FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      sql_command_1:
        x: 503
        'y': 121
      enc_password:
        x: 676
        'y': 285
      sql_command:
        x: 888
        'y': 278
        navigate:
          3da05a51-a232-a734-2b42-5879c39cff1c:
            targetId: 071584c5-4d33-b1b1-3a03-5445a61079ad
            port: SUCCESS
      get_central:
        x: 40
        'y': 118
      get_flow_inputs:
        x: 195
        'y': 119
      is_flow_exists:
        x: 322
        'y': 123
        navigate:
          a0e2f0dd-5557-e893-42fe-182808f158f4:
            targetId: daa4f7e5-9b2f-726b-cabe-6b66ec19a93f
            port: 'FALSE'
    results:
      SUCCESS:
        071584c5-4d33-b1b1-3a03-5445a61079ad:
          x: 1004
          'y': 124
      FAILURE:
        daa4f7e5-9b2f-726b-cabe-6b66ec19a93f:
          x: 319
          'y': 310
