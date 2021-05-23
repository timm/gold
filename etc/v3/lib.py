import pprint
import re
import random
import sys


class Thing:
  "Classes that can pretty print themselves."
  def __repr__(i):
    return re.sub(r"'", ' ',
                  pprint.pformat(dicts(i.__dict__), compact=True))


def dicts(i, seen=None):
  " Converts `i` into a nested dictionary, then pretty-prints that."
  if isinstance(i, (tuple, list)):
    return [dicts(v, seen) for v in i]
  elif isinstance(i, dict):
    return {k: dicts(i[k], seen) for k in i if str(k)[0] != "_"}
  elif isinstance(i, Thing):
    seen = seen or {}
    j = id(i) % 128021  # ids are LONG; show them shorter.
    if i in seen:
      return f"#:{j}"
    seen[i] = i
    d = dicts(i.__dict__, seen)
    d["#"] = j
    return d
  else:
    return i


class o(Thing):
  "Fast way to initialize an instance that has no methods"
  def __init__(i, **d): i.__dict__.update(**d)


if __name__ == "__main__":
  if "--test" in sys.argv:
    tests()
