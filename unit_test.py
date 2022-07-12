import main_api

def get_lm_data():
    try:
        main_api.process_lm_data()
        get_lm_dt = main_api.get_lm_res
        print (get_lm_dt)
        if get_lm_dt['status'] == 200:
            pass
        else:
            raise Exception("LM API Not Connected.")
    except Exception as exception:
        raise

def test_data():
    get_lm_data()