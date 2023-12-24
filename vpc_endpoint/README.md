# README

## ポイント

+ VPCで `enable_dns_support = true`と`enable_dns_hostnames = true`にしておく
  + VPC endpointのため
+ VPC endpointにて`private_dns_enabled = true`を設定する
+ ec2には`iam_instance_profile`をせっていする
  + `resource "aws_iam_instance_profile"`でvalueを設定できる

## テスト

+ privateのEC2にSSMでシェルに入れる(interface)
  + subnet_ids
+ `aws s3 ls --region ap-northeast-1`でS3をreadできる(gateway)
  + route_table_ids