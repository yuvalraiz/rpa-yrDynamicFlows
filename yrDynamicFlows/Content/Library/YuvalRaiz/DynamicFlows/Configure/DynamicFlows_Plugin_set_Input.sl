namespace: YuvalRaiz.DynamicFlows.Configure
flow:
  name: DynamicFlows_Plugin_set_Input
  inputs:
    - dbhost
    - dbport
    - dbusername
    - dbpassword:
        sensitive: true
    - dbname
    - plugin_id
    - input_name
    - encrypted
    - mandatory
    - defaultValue
  workflow:
    - show_input_field:
        do:
          io.cloudslang.base.utils.do_nothing:
            - user_choose:
                prompt:
                  type: text
                  message: "${'''<%s>: mandatory(%s) default:(%s)\\n = keep $variable or =contant''' % (input_name,mandatory,defaultValue)}"
        publish:
          - output_0: '${user_choose}'
        navigate:
          - SUCCESS: is_keep
          - FAILURE: on_failure
    - is_keep:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(output_0=='=')}"
        navigate:
          - 'TRUE': get_constant_value_1
          - 'FALSE': is_constant
    - is_constant:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(output_0[0]=='=')}"
        navigate:
          - 'TRUE': is_encrypted
          - 'FALSE': is_variable
    - is_variable:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(output_0[0]=='$')}"
        navigate:
          - 'TRUE': get_variable_name
          - 'FALSE': show_input_field
    - get_variable_name:
        do:
          io.cloudslang.base.utils.do_nothing:
            - user_input: '${output_0[1:]}'
        publish:
          - input_value: '${user_input}'
        navigate:
          - SUCCESS: sql_command_1
          - FAILURE: on_failure
    - get_constant_value_1:
        do:
          io.cloudslang.base.utils.do_nothing:
            - input_value: '${defaultValue}'
        publish:
          - input_value
        navigate:
          - SUCCESS: sql_command_1
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
            - command: "${'''insert into plugin_inputs (plugin_id, input_name, is_secret, input_value, is_code) values ('%s', '%s',%s, '%s', %s)''' % (plugin_id, input_name, encrypted, input_value, output_0[0]=='$')}"
            - trust_all_roots: 'true'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - is_encrypted:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(encrypted=='true')}"
        navigate:
          - 'TRUE': encrypt_password
          - 'FALSE': get_variable_name
    - encrypt_password:
        do:
          io.cloudslang.base.utils.base64_encoder:
            - data: '${output_0[1:]}'
        publish:
          - input_value: '${result}'
        navigate:
          - SUCCESS: sql_command_1
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      show_input_field:
        x: 86
        'y': 103
      get_variable_name:
        x: 455
        'y': 478
      sql_command_1:
        x: 789
        'y': 298
        navigate:
          9baa24a8-9777-e10c-ee41-c345810395f4:
            targetId: 3d74ccd9-a1ba-e0a4-963b-1f3422773e84
            port: SUCCESS
      is_encrypted:
        x: 447
        'y': 290
      get_constant_value_1:
        x: 439
        'y': 113
      is_variable:
        x: 299
        'y': 477
      encrypt_password:
        x: 576
        'y': 288
      is_constant:
        x: 301
        'y': 291
      is_keep:
        x: 297
        'y': 105
    results:
      SUCCESS:
        3d74ccd9-a1ba-e0a4-963b-1f3422773e84:
          x: 914
          'y': 105
