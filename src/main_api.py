import logging
import hashlib
import base64
import time
import hmac
import os
import requests
import json
import redis
import re

import azure.functions as func

# lm_hostname = os.environ.get('LM_Url')
# conn_str = os.environ.get('RedisConn')
conn_str = "rds-lm-az2-dev.redis.cache.windows.net:6380,password=MfJdAtwtjyuYg0RliL3WSVVDjoL42ugjMqZiF7NZOUU=,ssl=True,abortConnect=False"
lm_hostname = "nttltdsandbox.logicmonitor.com"
connStr = conn_str.split(',')
myHostname = connStr[0].split(':')[0]
myPassword=re.findall(r"(?<==).*",connStr[1])[0]


def generate_token(resource_path):
    try:
        # access_id = os.environ.get('LMAccessId')
        # access_key = os.environ.get('LMAccessKey')
        access_id = "5N48nz9394dHsgg688sb"
        access_key = "XGAx48y%9uLy^tk_JfksL6E5WJ4Za]Y_9L{y{f2J"

        AccessId = access_id
        AccessKey = access_key
        httpVerb ='GET'
        resourcePath = resource_path
        epoch = str(int(time.time() * 1000))
        requestVars = httpVerb + epoch + resourcePath
        hmac1 = hmac.new(AccessKey.encode(),msg=requestVars.encode(),digestmod=hashlib.sha256).hexdigest()
        signature = base64.b64encode(hmac1.encode())
        token = 'LMv1 ' + AccessId + ':' + signature.decode() + ':' + epoch
        logging.info(token)
        return token
    except:
        return "Token Invalid"


def process_lm_data():
    try:        
        global get_lm_res
        ## get dashboard ID ##    
        dashboard_name = "NTTA-NI Sunnyvale Lab"
        logging.info(dashboard_name)
        resource_path = '/dashboard/dashboards'
        dashboard_token = generate_token(resource_path)
        lm_dashboard_url = f'https://{lm_hostname}/santaba/rest/dashboard/dashboards?filter=name:{dashboard_name}'
        headers = {
        'Authorization': dashboard_token
        }

        response = requests.request("GET", url=lm_dashboard_url, headers=headers)
        data = response.json()
        get_lm_res = data
        # print (get_lm_res)
        logging.info(data)
        status_response = response.status_code
        logging.info(status_response)
        if status_response == 200:
            if (data['status'] != 200) or (data["data"]["items"] == []):
                logging.info("Faied to get dashboard ID")
                result = ({"data":"Failed to get dashboard ID"})
                result = json.dumps(result)
                return result, status_response
            else:    
                dashboard_id = data["data"]["items"][0]["id"]
                logging.info(dashboard_id)
                logging.info(response.status_code)
        else:
            logging.info("Faied to get dashboard ID")
            result = ({"data":"Failed to get dashboard ID"})
            result = json.dumps(result)
            return result, status_response
    except:
        logging.info("failed to process data")

if __name__ == "__main__":
    process_lm_data()