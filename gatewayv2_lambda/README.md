# README.md

+ メリット
    + 安く済む
+ デメリット
    + v2のHTTP APIはmockが作れない

## demo

```sh
terraform plan
terraform apply
```

```sh
curl https://9db6rfhgqh.execute-api.ap-northeast-1.amazonaws.com/dev/sample --get --data-urlencode input_text=おはよう
```