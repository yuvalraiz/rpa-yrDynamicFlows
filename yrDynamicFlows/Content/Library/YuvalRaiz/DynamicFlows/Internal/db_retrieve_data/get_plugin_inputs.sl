namespace: YuvalRaiz.DynamicFlows.Internal.db_retrieve_data
flow:
  name: get_plugin_inputs
  inputs:
    - dbhost: db.mfdemos.com
    - dbport: '5432'
    - dbusername: postgres
    - dbpassword:
        sensitive: true
    - dbname: yrDynamicRunning
    - plugin_name: GetTotalCommisionForAM
  workflow:
    - do_nothing_1:
        do:
          io.cloudslang.base.utils.do_nothing: []
        publish:
          - input_section: ','
          - secret_input_section: ','
        navigate:
          - SUCCESS: sql_query_all_rows
          - FAILURE: on_failure
    - sql_query_all_rows:
        do:
          io.cloudslang.base.database.sql_query_all_rows:
            - db_server_name: '${dbhost}'
            - db_type: PostgreSQL
            - username: '${dbusername}'
            - password:
                value: '${dbpassword}'
                sensitive: true
            - db_port: '${dbport}'
            - database_name: '${dbname}'
            - db_url: '${"jdbc:postgresql://%s:%s/%s" % (dbhost,dbport,dbname)}'
            - command: "${'''select input_name, input_value, is_secret,is_code  from plugin_inputs where plugin_id = '%s' ''' % (plugin_name)}"
            - trust_all_roots: 'true'
            - col_delimiter: '_|_'
            - row_delimiter: '_||_'
        publish:
          - all_inputs: '${return_result}'
        navigate:
          - SUCCESS: build_input_sections
          - FAILURE: on_failure
    - build_input_sections:
        do:
          YuvalRaiz.DynamicFlows.Internal.db_retrieve_data.build_input_sections:
            - all_inputs: '${all_inputs}'
        publish:
          - input_section
          - secret_input_section
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - input_section
    - secret_input_section
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      do_nothing_1:
        x: 21
        'y': 99
      sql_query_all_rows:
        x: 152
        'y': 108
      build_input_sections:
        x: 300
        'y': 109
        navigate:
          74aabafe-b1c6-a824-894f-5d9c0dcee594:
            targetId: 4eb29fc4-733a-d7a3-ecc9-7ce99340b53f
            port: SUCCESS
    results:
      SUCCESS:
        071584c5-4d33-b1b1-3a03-5445a61079ad:
          x: 1094
          'y': 1
        4eb29fc4-733a-d7a3-ecc9-7ce99340b53f:
          x: 492
          'y': 113
