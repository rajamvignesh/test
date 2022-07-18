import src.main_api as webhook_lm
import unittest
from unittest import mock
import os,sys
import azure.functions as func
import json

class Main_test_funct(unittest.TestCase):

    LM_Url = os.environ['LM_URL']
    @mock.patch('src.main_api')
    # ----------- Mock Env Variables ---------------
    @mock.patch.dict("os.environ", {
        "LM_Url": LM_Url,
        "RedisConn": "rds-lm-az2-dev.redis.cache.windows.net:6380,password=MfJdAtwtjyuYg0RliL3WSVVDjoL42ugjMqZiF7NZOUU=,ssl=True,abortConnect=False",
        "LMAccessId":"5N48nz9394dHsgg688sb",
        "LMAccessKey":"XGAx48y%9uLy^tk_JfksL6E5WJ4Za]Y_9L{y{f2J"})

    def test_process_lm_data(self,mock_process_lm_data):
        try:
            Dashboard_name = os.environ['DASHBOARD_NAME']
            Lm_process_data = webhook_lm.process_lm_data(Dashboard_name)
            self.assertEqual(webhook_lm.get_lm_response['status'],200)
            # if webhook_lm.get_lm_response['status'] == 000:
            #     print ("successfull response",webhook_lm.get_lm_response['status'])
            #     pass
            # else:
            #     raise Exception("LM API Not Connected.")
        except Exception as exception:
            raise

    @mock.patch('src.main_api')
    def test_main(self,mock_main_code):
        try:
            # ----------- Mock HTTP Body Request ---------------
            req = func.HttpRequest(
            method='Post',
            body=b'{"dashboardName":""}',
            url='/api/availabilityIssueReport',
            params={'code':'hZccQA9K1NOg9NMbqIYjDLzMEu2v6PsVlbtOMbloMFy5AzFuOIkHqw=='})

            resp = webhook_lm.main(req)
            self.assertEqual(resp.get_body(),b'{"dashboardName":""}')
        except Exception as exception:
            raise


if __name__ == '__main__':
    unittest.main()