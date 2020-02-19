import yaml
import json
import sys
import base64

def extract_connection_string():

    with open('gql-secret.yaml', 'r') as f:
        doc = yaml.safe_load(f)

    connection_string = ''
    text = doc["metadata"]["annotations"]["kubectl.kubernetes.io/last-applied-configuration"]
    json_output = json.loads(text)
    json_conn_string = json_output["data"]["connection-string"]
    connection_string = base64.b64decode(json_conn_string).decode("utf-8")

    return connection_string

if __name__ == "__main__":
    output_connection_string = extract_connection_string()
    sys.exit(output_connection_string)
