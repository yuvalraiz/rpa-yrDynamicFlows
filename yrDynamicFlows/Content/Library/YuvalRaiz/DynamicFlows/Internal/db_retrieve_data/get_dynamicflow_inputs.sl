namespace: YuvalRaiz.DynamicFlows.Internal.db_retrieve_data
flow:
  name: get_dynamicflow_inputs
  inputs:
    - dbhost
    - dbport
    - dbusername
    - dbpassword:
        sensitive: true
    - dbname
    - dynamic_flow_id
  workflow:
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
            - command: |-
                ${'''select distinct input_value from dynamic_flow_steps as s, plugin_inputs as pi where s.plugin_id = pi.plugin_id and is_code = True and dynamic_flow_id = '%s' order by input_value;
                ''' % (dynamic_flow_id)}
            - trust_all_roots: 'true'
            - col_delimiter: '_|_'
            - row_delimiter: ','
        publish:
          - all_inputs: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - input_list: '${all_inputs}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      sql_query_all_rows:
        x: 120
        'y': 119
        navigate:
          1d2115b3-46d4-dfb4-221b-af6d1f1df0e2:
            targetId: 071584c5-4d33-b1b1-3a03-5445a61079ad
            port: SUCCESS
    results:
      SUCCESS:
        071584c5-4d33-b1b1-3a03-5445a61079ad:
          x: 487
          'y': 99
