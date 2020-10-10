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
            - command: "${'''select flow_uuid, flow_inputs, flow_secret_inputs from plugins where id = '%s' ''' % (plugin_name)}"
            - trust_all_roots: 'true'
            - delimiter: '_|_'
            - key: id
        publish:
          - flow_name: "${return_result.split('_|_')[0]}"
          - flow_inputs: "${return_result.split('_|_')[1]}"
          - flow_secret_inputs: "${return_result.split('_|_')[2]}"
        navigate:
          - HAS_MORE: SUCCESS
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
  outputs:
    - flow_name
    - flow_inputs
    - flow_secret_inputs
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      sql_query:
        x: 79
        'y': 112
        navigate:
          5a5c9010-f775-54e9-7c92-0b9ca17652aa:
            targetId: 071584c5-4d33-b1b1-3a03-5445a61079ad
            port: NO_MORE
          ae721165-e9ac-1acb-0186-8cb6060aa3b0:
            targetId: 071584c5-4d33-b1b1-3a03-5445a61079ad
            port: HAS_MORE
    results:
      SUCCESS:
        071584c5-4d33-b1b1-3a03-5445a61079ad:
          x: 487
          'y': 99
