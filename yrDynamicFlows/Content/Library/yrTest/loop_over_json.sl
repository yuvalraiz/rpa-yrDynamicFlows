namespace: yrTest
flow:
  name: loop_over_json
  workflow:
    - do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing: []
        publish:
          - input_list: |-
              ${cs_replace('''
              [{"uuid":"2472cfad-1e37-42e8-b711-a6c8492d6cce","name":"FirstName","valueDelimiter":null,"description":"","encrypted":false,"multiValue":false,"mandatory":true,"sources":null,"type":"String","validationId":null,"defaultValue":null},{"uuid":"0a132a9d-b086-4b53-9b59-3856477d89cc","name":"LastName","valueDelimiter":null,"description":"","encrypted":false,"multiValue":false,"mandatory":true,"sources":null,"type":"String","validationId":null,"defaultValue":null},{"uuid":"70f859aa-54bd-4fc6-864b-af78ba033177","name":"UserType","valueDelimiter":null,"description":"LDAP,OS","encrypted":false,"multiValue":false,"mandatory":true,"sources":null,"type":"String","validationId":null,"defaultValue":null},{"uuid":"970cba9d-0ef8-43ab-83d8-e39ed1a2d274","name":"ExternalEmail","valueDelimiter":null,"description":"","encrypted":false,"multiValue":false,"mandatory":false,"sources":null,"type":"String","validationId":null,"defaultValue":null},{"uuid":"77a21371-f6ce-4bfc-894d-217bb29fc6da","name":"Password","valueDelimiter":null,"description":"","encrypted":false,"multiValue":false,"mandatory":true,"sources":null,"type":"String","validationId":null,"defaultValue":""},{"uuid":"99e947a5-2e42-4306-8980-ac4d6325643c","name":"BU","valueDelimiter":null,"description":"IT,SALES","encrypted":false,"multiValue":false,"mandatory":true,"sources":null,"type":"String","validationId":null,"defaultValue":null},{"uuid":"fe07e0cd-98d0-4138-9e53-e4d73e4185a7","name":"SMAX_Request","valueDelimiter":null,"description":"","encrypted":false,"multiValue":false,"mandatory":false,"sources":null,"type":"String","validationId":null,"defaultValue":null},{"uuid":"15ea7e67-3207-4435-a5c2-9750d2412235","name":"NotificationEmail","valueDelimiter":null,"description":"","encrypted":false,"multiValue":false,"mandatory":false,"sources":null,"type":"String","validationId":null,"defaultValue":null},{"uuid":"94b50de4-b1aa-43de-b8f0-497d5852cec9","name":"bypass","valueDelimiter":null,"description":"","encrypted":false,"multiValue":false,"mandatory":false,"sources":null,"type":"String","validationId":null,"defaultValue":null}]
              ''',null,Null,)}
        navigate:
          - SUCCESS: do_nothing_1
          - FAILURE: on_failure
    - do_nothing_1:
        loop:
          for: ''
          do:
            io.cloudslang.base.utils.do_nothing:
              - json_object: null
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
  results:
    - FAILURE
extensions:
  graph:
    steps:
      do_nothing:
        x: 95
        'y': 136
      do_nothing_1:
        x: 304
        'y': 136
