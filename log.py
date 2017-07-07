

import logging

logging.basicConfig(level=logging.DEBUG,
                format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',
                datefmt='%a, %d %b %Y %H:%M:%S',
                filename='/var/log/yr-app.log',
                filemode='w')

log = logging.getLogger()
stdout_handler = logging.StreamHandler(sys.stdout)
log.addHandler(stdout_handler)

