namespace: YuvalRaiz.DynamicFlows.Internal.db_retrieve_data
flow:
  name: get_plugin
  inputs:
    - dbhost: db.mfdemos.com
    - dbport: '5432'
    - dbusername: postgres
    - dbpassword:
        sensitive: true
    - dbname: yrDynamicRunning
    - plugin_name: salesfix
  workflow:
    - sql_query:
        do:
          io.cloudslang.base.database.sql_query:
            - db_server_name: '${dbhost}'
            - db_type: PostgreSQL
            - username: '${dbusername}'
            - password:
                value: '${dbpassword}'
                sensitive: true
            - db_port: '${dbport}'
            - database_name: '${dbname}'
            - db_url: '${"jdbc:postgresql://%s:%s/%s" % (dbhost,dbport,dbname)}'
            - command: "${'''select flow_uuid, plugins.central_id, host, protocol, port, username, password from plugins, central where plugins.central_id = central.central_id and plugin_id = '%s' ''' % (plugin_name)}"
            - trust_all_roots: 'true'
            - delimiter: '_|_'
            - key: id
        publish:
          - flow_name: "${return_result.split('_|_')[0]}"
          - central_id: "${return_result.split('_|_')[1]}"
          - oohost: "${return_result.split('_|_')[2]}"
          - ooprotocol: "${return_result.split('_|_')[3]}"
          - ooport: "${return_result.split('_|_')[4]}"
          - oousername: "${return_result.split('_|_')[5]}"
          - oopassword:
              value: "${return_result.split('_|_')[6]}"
              sensitive: true
        navigate:
          - HAS_MORE: decrypt_password
          - NO_MORE: decrypt_password
          - FAILURE: on_failure
    - decrypt_password:
        do:
          io.cloudslang.base.utils.base64_decoder:
            - data: '${oopassword}'
        publish:
          - oopassword:
              value: '${result}'
              sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: SUCCESS
  outputs:
    - flow_name
    - oohost: '${oohost}'
    - ooprotocol: '${ooprotocol}'
    - ooport: '${ooport}'
    - oousername: '${oousername}'
    - oopassword:
        value: '${oopassword}'
        sensitive: true
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      sql_query:
        x: 79
        'y': 113
      decrypt_password:
        x: 228
        'y': 110
        navigate:
          7af634c3-a959-cf17-fde5-6277f238bd74:
            targetId: 071584c5-4d33-b1b1-3a03-5445a61079ad
            port: SUCCESS
          62225b9f-6a05-5d78-7df2-ddc85ec80daa:
            targetId: 071584c5-4d33-b1b1-3a03-5445a61079ad
            port: FAILURE
    results:
      SUCCESS:
        071584c5-4d33-b1b1-3a03-5445a61079ad:
          x: 487
          'y': 99
