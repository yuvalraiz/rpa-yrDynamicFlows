namespace: YuvalRaiz.DynamicFlows.Internal.db_retrieve_data
flow:
  name: get_central
  inputs:
    - dbhost
    - dbport
    - dbusername
    - dbpassword:
        sensitive: true
    - dbname
    - central_id
  workflow:
    - get_data:
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
            - command: "${'''select host, protocol, port, username, password from central where central_id = '%s' ''' % (central_id)}"
            - trust_all_roots: 'true'
            - delimiter: '_|_'
            - key: id
        publish:
          - oohost: "${return_result.split('_|_')[0]}"
          - ooprotocol: "${return_result.split('_|_')[1]}"
          - ooport: "${return_result.split('_|_')[2]}"
          - oousername: "${return_result.split('_|_')[3]}"
          - oopassword:
              value: "${return_result.split('_|_')[4]}"
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
      get_data:
        x: 100
        'y': 150
      decrypt_password:
        x: 400
        'y': 150
        navigate:
          34137907-6ef0-5b55-64f3-48c991c69e1f:
            targetId: 3f21311b-1207-75ff-3e0b-f2f97dd27b3a
            port: SUCCESS
          84efe9dc-63d7-5154-2699-9bdff3676d50:
            targetId: 3f21311b-1207-75ff-3e0b-f2f97dd27b3a
            port: FAILURE
    results:
      SUCCESS:
        3f21311b-1207-75ff-3e0b-f2f97dd27b3a:
          x: 700
          'y': 150
