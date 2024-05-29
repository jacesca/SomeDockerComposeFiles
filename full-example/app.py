import time
import redis


cache = redis.Redis(host='redis', port=6379, socket_timeout=1)


def get_hit_count():
    retries = 5
    while True:
        try:
            return cache.incr('hits')
        except redis.exceptions.ConnectionError as exc:
            if retries == 0:
                raise exc
            retries -= 1
            time.sleep(0.5)


def hello():
    count = get_hit_count()
    return f'Successfully communicated {count} times.\n'


for i in range(0, 5):
    print(f"{hello()}")
