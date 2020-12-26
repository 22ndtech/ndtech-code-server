docker run -it `
-p 127.0.0.1:8080:8080 `
-v C:\Users\jeff\.config:/home/coder/.config `
--rm --entrypoint /bin/bash 22ndtech/ndtech-code-server