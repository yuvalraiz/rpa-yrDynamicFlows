namespace: YuvalRaiz.DynamicFlows.Configure
flow:
  name: DynamicFlows_AddCentral
  inputs:
    - dbhost: db.mfdemos.com
    - dbport: '5432'
    - dbusername: postgres
    - dbpassword:
        sensitive: true
    - dbname: yrDynamicRunning
    - central_id: yuval.raiz-rpa.mfdemos.com1
    - oohost
    - ooprotocol
    - ooport
    - oousername
    - oopassword:
        sensitive: true
  workflow:
    - check_params:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'''%s://%s:%s/oo/rest/v2/version''' % (ooprotocol, oohost, ooport)}"
            - auth_type: basic
            - username: '${oousername}'
            - password:
                value: '${oopassword}'
                sensitive: true
            - trust_all_roots: 'true'
        publish:
          - X_CSRF_TOKEN: "${response_headers.split('X-CSRF-TOKEN: ')[1].split('\\n')[0]}"
        navigate:
          - SUCCESS: enc_password
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
            - command: "${'''insert into central (id, host, protocol, port, username, password) values ('%s', '%s','%s','%s','%s','%s' )''' % (central_id, oohost, ooprotocol,ooport,oousername,oopassword)}"
            - trust_all_roots: 'true'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      enc_password:
        x: 212
        'y': 133
      sql_command:
        x: 360
        'y': 125
        navigate:
          3da05a51-a232-a734-2b42-5879c39cff1c:
            targetId: 071584c5-4d33-b1b1-3a03-5445a61079ad
            port: SUCCESS
      check_params:
        x: 68
        'y': 136
    results:
      SUCCESS:
        071584c5-4d33-b1b1-3a03-5445a61079ad:
          x: 500
          'y': 130
