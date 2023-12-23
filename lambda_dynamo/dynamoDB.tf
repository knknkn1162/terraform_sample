module "dynamo" {
    source = "./dynamoDB"
    table_name = "TranslateHistory"
}