namespace: YuvalRaiz.DynamicFlows.Internal.invoke_remote_flow
operation:
  name: check_all_inputs
  inputs:
    - input_list
    - input_hash
  python_action:
    use_jython: false
    script: "def execute(input_list,input_hash): \n    found_all='true'\n    error_message=''\n    return_code=0\n    input_dic=eval(input_hash)\n    error_message=type(input_dic)\n    for input_name in input_list.split(','):\n      if input_dic.get(input_name) is None:\n          error_message='<%s> not found' % input_name\n          return_code=1\n          break\n    return locals()"
  outputs:
    - return_code
    - error_message
  results:
    - SUCCESS: "${return_code=='0'}"
    - FAILURE
