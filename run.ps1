docker run -it `
-p 127.0.0.1:8080:8080 `
-v C:\Users\jeff\.config:/home/coder/.config `
-e GITHUB_USER=$ENV:GITHUB_USER `
-e GITHUB_TOKEN=$ENV:GITHUB_TOKEN `
-e GITHUB_ORGANIZATION="22ndtech" `
-e GIT_USER_NAME="$ENV:GIT_USER_NAME" `
-e GIT_USER_EMAIL="$ENV:GIT_USER_EMAIL" `
-e DIGITAL_OCEAN_INITIAL_TOKEN="$Env:DIGITAL_OCEAN_INITIAL_TOKEN" `
-e DO_EXTERNAL_DNS_TOKEN="$Env:DO_EXTERNAL_DNS_TOKEN" `
-e GIT_REPOSITORY_NAME="${args}" `
-v ${Env:CERTS_PATH}:/home/coder/.kube `
-v ${ENV:GITHUB_PROJECTS}:/work `
-v c:\data\vscode-user-data:/vscode-user-data `
--rm 22ndtech/ndtech-code-server