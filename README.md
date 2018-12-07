#tf & elk

- Setup terraform:
  - [ ] [https://www.terraform.io/downloads.html](https://www.terraform.io/downloads.html)
- Configurations & variables: 
  - [ ] Create file `*.tfvars` following `/configs/__tfvars` template

cmd:
 - [ ] terraform init
 - [ ] terraform plan (options)
 - [ ] terraform apply

test:
  - send log via http:
    url: http://{ip}:{logstash_http_port}/twitter/tweet/1
    ```{
    "user" : "Hello",
    "post_date" : "2018-12-03T14:12:12",
    "message" : "nah"
    }```

ref:
  - current svs: `netstat -plnt`
