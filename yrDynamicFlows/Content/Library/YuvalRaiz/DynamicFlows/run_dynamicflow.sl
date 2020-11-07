namespace: YuvalRaiz.DynamicFlows
flow:
  name: run_dynamicflow
  inputs:
    - dbhost: db.mfdemos.com
    - dbport: '5432'
    - dbusername: postgres
    - dbpassword:
        sensitive: true
    - dbname: yrDynamicRunning
    - dynamic_flow_id: MFDemos-CreateUser
    - input_hash: |-
        ${'''{
        'dn': 'uid=test.user,ou=demo,ou=DemoUsers,dc=mfdemos,dc=com',
        'group_dn': 'cn=obmAdmins,ou=DemoUsers,dc=mfdemos,dc=com',
        'user_dn': 'uid=test.user,ou=demo,ou=DemoUsers,dc=mfdemos,dc=com',
        'first_name': 'Test',
        'full_name': 'Test User',
        'last_name': 'User',
        'mail': 'test.user@gmail.com',
        'manager_dn': 'uid=sales.manager,ou=demo,ou=DemoUsers,dc=mfdemos,dc=com',
        'second_email': '',
        'uid': 'test.user',
        'user_password': 'ABCD'
        }'''}
  workflow:
    - get_dynamicflow_inputs:
        do:
          YuvalRaiz.DynamicFlows.Internal.db_retrieve_data.get_dynamicflow_inputs:
            - dbhost: '${dbhost}'
            - dbport: '${dbport}'
            - dbusername: '${dbusername}'
            - dbpassword:
                value: '${dbpassword}'
                sensitive: true
            - dbname: '${dbname}'
            - dynamic_flow_id: '${dynamic_flow_id}'
        publish:
          - input_list
        navigate:
          - SUCCESS: check_all_inputs
          - FAILURE: on_failure
    - check_all_inputs:
        do:
          YuvalRaiz.DynamicFlows.Internal.invoke_remote_flow.check_all_inputs:
            - input_list: '${input_list}'
            - input_hash: '${input_hash}'
        navigate:
          - SUCCESS: get_all_flow_steps
          - FAILURE: on_failure
    - get_all_flow_steps:
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
            - command: "${'''select plugin_id  from dynamic_flow_steps  where dynamic_flow_id = '%s' order by dynamic_flow_stepid''' % (dynamic_flow_id)}"
            - trust_all_roots: 'true'
            - col_delimiter: '_|_'
            - row_delimiter: '_||_'
        publish:
          - all_steps: '${return_result}'
        navigate:
          - SUCCESS: run_dynamicflow_step
          - FAILURE: on_failure
    - run_dynamicflow_step:
        loop:
          for: "plugin_id in all_steps.split('_||_')"
          do:
            YuvalRaiz.DynamicFlows.Internal.invoke_remote_flow.run_dynamicflow_step:
              - dbhost: '${dbhost}'
              - dbport: '${dbport}'
              - dbusername: '${dbusername}'
              - dbpassword:
                  value: '${dbpassword}'
                  sensitive: true
              - dbname: '${dbname}'
              - plugin_id: '${plugin_id}'
              - input_hash: '${input_hash}'
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_dynamicflow_inputs:
        x: 75
        'y': 113
      check_all_inputs:
        x: 244
        'y': 123
      get_all_flow_steps:
        x: 383
        'y': 132
      run_dynamicflow_step:
        x: 551
        'y': 130
        navigate:
          932327ad-b6e1-4f6d-90e1-0922a598821e:
            targetId: 433bc6b3-ebc1-7fcc-2019-14560a08097c
            port: SUCCESS
    results:
      SUCCESS:
        433bc6b3-ebc1-7fcc-2019-14560a08097c:
          x: 732
          'y': 119
