import sys, os
sys.path.append("./src/")
from src import main_api as get_lm_func

def get_lm_data():
    try:
        get_lm_func.process_lm_data()
        get_lm_dt = get_lm_func.get_lm_res
        print (get_lm_dt)
        if get_lm_dt['status'] == 200:
            pass
        else:
            raise Exception("LM API Not Connected.")
    except Exception as exception:
        raise

def test_data():
    get_lm_data()