namespace: YuvalRaiz.DynamicFlows.Internal.db_retrieve_data
flow:
  name: get_central
  inputs:
    - dbhost: db.mfdemos.com
    - dbport: '5432'
    - dbusername: postgres
    - dbpassword:
        sensitive: true
    - dbname: yrDynamicRunning
    - central_id: yuval.raiz-rpa.mfdemos.com
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
            - command: "${'''select host, protocol, port, username, password from central where id = '%s' ''' % (central_id)}"
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
          - HAS_MORE: dec_password
          - NO_MORE: dec_password
          - FAILURE: on_failure
    - dec_password:
        do:
          io.cloudslang.base.utils.base64_decoder:
            - data: '${oopassword}'
        publish:
          - oopassword:
              value: '${result}'
              sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - oohost: '${oohost}'
    - ooprotocol: '${ooprotocol}'
    - ooport: '${dbport}'
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
      dec_password:
        x: 249
        'y': 112
        navigate:
          45ae0658-18e6-fbf4-8d84-649d26ec5c30:
            targetId: 071584c5-4d33-b1b1-3a03-5445a61079ad
            port: SUCCESS
      get_data:
        x: 72
        'y': 123
    results:
      SUCCESS:
        071584c5-4d33-b1b1-3a03-5445a61079ad:
          x: 487
          'y': 99
