print('++++++++++++')
import a
import importlib
importlib.reload(a)  # force a.py to execute
print("Runner __name__:", __name__)
print('++++++++++++')
