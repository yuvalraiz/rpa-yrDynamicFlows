namespace: YuvalRaiz.DynamicFlows.Internal.db_retrieve_data
operation:
  name: build_input_sections_orig
  inputs:
    - all_inputs
  python_action:
    use_jython: false
    script: "import base64\n# do not remove the execute function \ndef execute(all_inputs): \n    input_section=''\n    code_input_section=''\n    code_input_params=''\n    secret_input_section=''\n    code_secret_input_section=''\n    for an_input in all_inputs.split('_||_'):\n        input_name,input_value,is_secret,is_code = an_input.split('_|_')\n        if is_secret=='f':\n            if is_code=='f':\n                input_section = '%s,\\n\"%s\": \"%s\"' % (input_section,input_name,input_value)\n            else:\n                code_input_section = '%s,\\n\"%s\": \"%%s\"' % (code_input_section,input_name)\n                code_input_params  = '%s,%s' % (code_input_params,input_value)\n        else:\n            if is_code=='f':\n                secret_input_section = '%s,\\n\"%s\": \"%s\"' % (secret_input_section,input_name,base64.b64decode(input_value).decode('UTF-8'))\n            else:\n                code_secret_input_section = '%s,\\n\"%s\": \"%s\"' % (code_secret_input_section,input_name,input_value)\n    if not input_section == '':\n        input_section = input_section[2:]\n    if not code_input_section == '':\n        code_input_section = \"'''\"+code_input_section[2:]+\"''' % (\"+code_input_params[1:]+\")\"\n    if not secret_input_section == '':\n        secret_input_section = secret_input_section[2:]\n    if not code_secret_input_section == '':\n        code_secret_input_section = code_secret_input_section[2:]\n    return locals()\n    # code goes here\n# you can add additional helper methods below."
  outputs:
    - input_section: '${input_section}'
    - secret_input_section: '${secret_input_section}'
    - code_input_section: '${code_input_section}'
    - code_secret_input_section: '${code_secret_input_section}'
  results:
    - SUCCESS
