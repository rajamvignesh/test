import src.main_api as webhook_lm

def get_lm_data():
    try:
        webhook_lm.process_lm_data()
        get_lm_dt = webhook_lm.get_lm_res
        if get_lm_dt['status'] == 200:
            print ("connection successfull")
            pass
        else:
            raise Exception("LM API Not Connected.")
    except Exception as exception:
        raise

def test_data():
    get_lm_data()